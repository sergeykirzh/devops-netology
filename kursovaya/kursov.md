# Курсовая работа по итогам модуля "DevOps и системное администрирование"

Курсовая работа необходима для проверки практических навыков, полученных в ходе прохождения курса "DevOps и системное администрирование".

Мы создадим и настроим виртуальное рабочее место. Позже вы сможете использовать эту систему для выполнения домашних заданий по курсу



## Результат

Результатом курсовой работы должны быть снимки экрана или текст:


- Процесс установки и настройки ufw
```
	#Включение ufw в серверной Ubuntu 
	sudo ufw enable
	
	#Запрещаем по умолчанию  все входящие подключения, а исходящие разрешим
	sudo ufw default deny incoming
	sudo ufw default allow outgoing
	
	#Разрешаем ssh и https 
	sudo ufw allow ssh
	sudo ufw allow https
	
	#Разрешаем трафик на lo	
	sudo ufw allow in on lo
	sudo ufw allow out on lo
```
- Процесс установки и выпуска сертификата с помощью hashicorp vault
```
	#Добавим gpg ключ пакета hashicorp
	serg@vagrant:~$ curl -fsSL1 https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
	OK
  
	#Добавим офицальный репозиторий hashicorp 	
	serg@vagrant:~$ sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
	Hit:1 http://archive.ubuntu.com/ubuntu focal InRelease
	Get:2 https://apt.releases.hashicorp.com focal InRelease [9,495 B]
	Get:3 http://archive.ubuntu.com/ubuntu focal-updates InRelease [114 kB]
	Get:4 http://security.ubuntu.com/ubuntu focal-security InRelease [114 kB]
	Get:5 http://archive.ubuntu.com/ubuntu focal-backports InRelease [108 kB]
	Get:6 https://apt.releases.hashicorp.com focal/main amd64 Packages [41.1 kB]
	Get:7 http://archive.ubuntu.com/ubuntu focal-updates/main i386 Packages [574 kB]
	Get:8 http://security.ubuntu.com/ubuntu focal-security/main i386 Packages [345 kB]
	...
	
	#Обновление и установка пакета
	serg@vagrant:~$ sudo apt-get update && sudo apt-get install vault
	Hit:1 http://archive.ubuntu.com/ubuntu focal InRelease
	Hit:2 http://archive.ubuntu.com/ubuntu focal-updates InRelease
	Hit:3 http://security.ubuntu.com/ubuntu focal-security InRelease
	Hit:4 http://archive.ubuntu.com/ubuntu focal-backports InRelease
	Hit:5 https://apt.releases.hashicorp.com focal InRelease
	Reading package lists... Done
	Reading package lists... Done
	Building dependency tree
	Reading state information... Done
	The following NEW packages will be installed:
	  vault
	0 upgraded, 1 newly installed, 0 to remove and 109 not upgraded.
	Need to get 69.4 MB of archives.
	After this operation, 188 MB of additional disk space will be used.
	Get:1 https://apt.releases.hashicorp.com focal/main amd64 vault amd64 1.9.2 [69.4 MB]
	Fetched 69.4 MB in 12s (5,758 kB/s)
	Selecting previously unselected package vault.
	(Reading database ... 63347 files and directories currently installed.)
	Preparing to unpack .../archives/vault_1.9.2_amd64.deb ...
	Unpacking vault (1.9.2) ...
	Setting up vault (1.9.2) ...
	Generating Vault TLS key and self-signed certificate...
	Generating a RSA private key
	.................++++
	................++++
	writing new private key to 'tls.key'
	-----
	Vault TLS key and self-signed certificate have been generated in '/opt/vault/tls'.
	
	#Приводим конфигурацию к виду
    cat /etc/vault.d/vault.hcl
	
	# Full configuration options can be found at https://www.vaultproject.io/docs/configuration

	ui = false

	#mlock = true
	#disable_mlock = true

	storage "file" {
	  path = "/opt/vault/data"
	}

	#storage "consul" {
	#  address = "127.0.0.1:8500"
	#  path    = "vault"
	#}

	# HTTP listener
	listener "tcp" {
	  address = "127.0.0.1:8200"
	  tls_disable = 1
	}

	# HTTPS listener
	#listener "tcp" {
	#  address       = "0.0.0.0:8200"
	# tls_cert_file = "/opt/vault/tls/tls.crt"
	# tls_key_file  = "/opt/vault/tls/tls.key"
	#}

	# Enterprise license_path
	# This will be required for enterprise as of v1.8
	#license_path = "/etc/vault.d/vault.hclic"

	# Example AWS KMS auto unseal
	#seal "awskms" {
	#  region = "us-east-1"
	#  kms_key_id = "REPLACE-ME"
	#}

	# Example HSM auto unseal
	#seal "pkcs11" {
	#  lib            = "/usr/vault/lib/libCryptoki2_64.so"
	#  slot           = "0"
	#  pin            = "AAAA-BBBB-CCCC-DDDD"
	#  key_label      = "vault-hsm-key"
	#  hmac_key_label = "vault-hsm-hmac-key"
	#}

	#Запускаем службу Vault
	systemctl enable vault
	systemctl start vault
	
	#Экспортируем переменную VAULT_ADDR
	export VAULT_ADDR=http://127.0.0.1:8200
	#Инициализируем
	vault operator init
	# Полученные ключи и токен рута копируем в файлы - они пригодятся для работы с секретами.Логинимся
	vault operator unseal $(cat vaultkeys/key1) > /dev/null
	vault operator unseal $(cat vaultkeys/key2) > /dev/null
	vault operator unseal $(cat vaultkeys/key3) > /dev/null
	vault login  $(cat vaultkeys/root_token) > /dev/null
	
	#Выпускаем  сертификаты
	
	#Корневой сертификат
	vault  secrets enable -path=pki_root_ca -max-lease-ttl=87600h pki
	vault write -field=certificate pki_root_ca/root/generate/internal common_name="Root Certificate Kirzhaev"   ttl=87600h > CA_cert.crt
	vault write pki_root_ca/config/urls  issuing_certificates="$VAULT_ADDR/v1/pki_root_ca/ca"  crl_distribution_points="$VAULT_ADDR/v1/pki_root_ca/crl"
	
	#Промежуточный сертификат подписываем корневым
	vault  secrets enable -path=pki_int -max-lease-ttl=43800h pki
	vault write -format=json pki_int/intermediate/generate/internal  common_name="example.com Intermediate Authority"  | jq -r '.data.csr' > pki_intermediate.csr
	vault write -format=json pki_root_ca/root/sign-intermediate csr=@pki_intermediate.csr  format=pem_bundle ttl="43800h"  | jq -r '.data.certificate' > intermediate.cert.pem
	vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem
	
	#Добавляем роль
	vault write pki_int/roles/kirzhaev-dot-com allowed_domains="kirzhaev.com"  allow_subdomains=true  max_ttl="720h"
	
	#Запрашиваем сертификат
	vault write -format=json pki_int/issue/kirzhaev-dot-com common_name="test.kirzhaev.com" ttl="720h"	 > test.kirzhaev.com.crt
		

		
```
- Процесс установки и настройки сервера nginx
```
	#Устанавливаем и включаем сервис

	serg@vagrant:~$ sudo apt install nginx
	Reading package lists... Done
	Building dependency tree
	Reading state information... Done
	...
	
	sudo systemctl enable nginx
	
	#Простенький конфиг
	serg@vagrant:~$ cat  /etc/nginx/sites-available/default
	server {
			listen 443 ssl default_server;
			ssl on;
			ssl_certificate /etc/nginx/conf.d/test.kirzhaev.com.crt.pem;
			ssl_certificate_key /etc/nginx/conf.d/test.kirzhaev.com.crt.key;
			root /var/www/html;

			
			server_name _;

			location / {
				   
					try_files $uri $uri/ =404;
			}

	}

	#Старт сервера
	sudo systemctl start nginx
```
- Страница сервера nginx в браузере хоста не содержит предупреждений 
![IMG1](img/img1.PNG)
![IMG2](img/img2.PNG)
![IMG3](img/img3.PNG)

- Скрипт генерации нового сертификата работает (сертификат сервера ngnix должен быть "зеленым")

```bash
	#!/usr/bin/env bash

	export VAULT_ADDR=http://127.0.0.1:8200
	SourcePath="/root/vault"
	DestPAtch="/etc/nginx/conf.d/"
	cd $SourcePath
	vault operator unseal $(cat vaultkeys/key1) > /dev/null
	vault operator unseal $(cat vaultkeys/key2) > /dev/null
	vault operator unseal $(cat vaultkeys/key3) > /dev/null
	vault login  $(cat vaultkeys/root_token) > /dev/null

	vault write -format=json pki_int/issue/kirzhaev-dot-com common_name="test.kirzhaev.com" ttl="720h" > test.kirzhaev.com.crt
	cat test.kirzhaev.com.crt | jq -r .data.certificate > test.kirzhaev.com.crt.pem
	cat test.kirzhaev.com.crt | jq -r .data.issuing_ca >> test.kirzhaev.com.crt.pem
	cat test.kirzhaev.com.crt | jq -r .data.private_key > test.kirzhaev.com.crt.key
	cp  test.kirzhaev.com.crt.* $DestPAtch
	systemctl  restart nginx
	vault operator seal
	rm test.kirzhaev.com.crt.*

```	
	#После запуска видно, что сертификат обновился.Вывод журнала(Время  на сервере в UTC)
	Dec 30 11:48:18 vagrant vault[672]: 2021-12-30T11:48:18.020Z [INFO]  core.cluster-listener.tcp: starting listener: listener_address=127.0.0.1:8201
	Dec 30 11:48:18 vagrant vault[672]: 2021-12-30T11:48:18.020Z [INFO]  core.cluster-listener: serving cluster requests: cluster_listen_address=127.0.0.1:8201
	Dec 30 11:48:18 vagrant vault[672]: 2021-12-30T11:48:18.020Z [INFO]  core: post-unseal setup starting
	Dec 30 11:48:18 vagrant vault[672]: 2021-12-30T11:48:18.021Z [INFO]  core: loaded wrapping token key
	Dec 30 11:48:18 vagrant vault[672]: 2021-12-30T11:48:18.021Z [INFO]  core: successfully setup plugin catalog: plugin-directory="\"\""
	Dec 30 11:48:18 vagrant vault[672]: 2021-12-30T11:48:18.021Z [INFO]  core: successfully mounted backend: type=system path=sys/
	Dec 30 11:48:18 vagrant vault[672]: 2021-12-30T11:48:18.022Z [INFO]  core: successfully mounted backend: type=identity path=identity/
	Dec 30 11:48:18 vagrant vault[672]: 2021-12-30T11:48:18.022Z [INFO]  core: successfully mounted backend: type=pki path=pki_root_ca/
	Dec 30 11:48:18 vagrant vault[672]: 2021-12-30T11:48:18.022Z [INFO]  core: successfully mounted backend: type=pki path=pki_int/
	Dec 30 11:48:18 vagrant vault[672]: 2021-12-30T11:48:18.022Z [INFO]  core: successfully mounted backend: type=cubbyhole path=cubbyhole/
	Dec 30 11:48:18 vagrant vault[672]: 2021-12-30T11:48:18.023Z [INFO]  core: successfully enabled credential backend: type=token path=token/
	Dec 30 11:48:18 vagrant vault[672]: 2021-12-30T11:48:18.023Z [INFO]  rollback: starting rollback manager
	Dec 30 11:48:18 vagrant vault[672]: 2021-12-30T11:48:18.024Z [INFO]  core: restoring leases
	Dec 30 11:48:18 vagrant vault[672]: 2021-12-30T11:48:18.024Z [INFO]  identity: entities restored
	Dec 30 11:48:18 vagrant vault[672]: 2021-12-30T11:48:18.024Z [INFO]  identity: groups restored
	Dec 30 11:48:18 vagrant vault[672]: 2021-12-30T11:48:18.024Z [INFO]  expiration: lease restore complete
	Dec 30 11:48:18 vagrant vault[672]: 2021-12-30T11:48:18.025Z [INFO]  core: post-unseal setup complete
	Dec 30 11:48:18 vagrant vault[672]: 2021-12-30T11:48:18.025Z [INFO]  core: vault is unsealed
	Dec 30 11:48:18 vagrant vault[672]: 2021-12-30T11:48:18.025Z [INFO]  core: usage gauge collection is disabled
	Dec 30 11:48:18 vagrant systemd[1]: Stopping A high performance web server and a reverse proxy server...
	Dec 30 11:48:18 vagrant systemd[1]: nginx.service: Succeeded.
	Dec 30 11:48:18 vagrant systemd[1]: Stopped A high performance web server and a reverse proxy server.
	Dec 30 11:48:18 vagrant systemd[1]: Starting A high performance web server and a reverse proxy server...
	Dec 30 11:48:18 vagrant vault[672]: 2021-12-30T11:48:18.871Z [INFO]  core: marked as sealed
	Dec 30 11:48:18 vagrant vault[672]: 2021-12-30T11:48:18.871Z [INFO]  core: pre-seal teardown starting
	Dec 30 11:48:18 vagrant vault[672]: 2021-12-30T11:48:18.872Z [INFO]  rollback: stopping rollback manager
	Dec 30 11:48:18 vagrant vault[672]: 2021-12-30T11:48:18.872Z [INFO]  core: pre-seal teardown complete
	Dec 30 11:48:18 vagrant vault[672]: 2021-12-30T11:48:18.872Z [INFO]  core: stopping cluster listeners
	Dec 30 11:48:18 vagrant vault[672]: 2021-12-30T11:48:18.872Z [INFO]  core.cluster-listener: forwarding rpc listeners stopped
	Dec 30 11:48:19 vagrant vault[672]: 2021-12-30T11:48:19.022Z [INFO]  core.cluster-listener: rpc listeners successfully shut down
	Dec 30 11:48:19 vagrant vault[672]: 2021-12-30T11:48:19.022Z [INFO]  core: cluster listeners successfully shut down
	Dec 30 11:48:19 vagrant vault[672]: 2021-12-30T11:48:19.022Z [INFO]  core: vault is sealed

```
	
	![IMG3](img/img3.PNG)
	
	
	
- Crontab работает (выберите число и время так, чтобы показать что crontab запускается и делает что надо)

```
    #Конфиг
	cat /etc/crontab
	# /etc/crontab: system-wide crontab
	# Unlike any other crontab you don't have to run the `crontab'
	# command to install the new version when you edit this file
	# and files in /etc/cron.d. These files also have username fields,
	# that none of the other crontabs do.

	SHELL=/bin/sh
	PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

	# Example of job definition:
	# .---------------- minute (0 - 59)
	# |  .------------- hour (0 - 23)
	# |  |  .---------- day of month (1 - 31)
	# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
	# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
	# |  |  |  |  |
	# *  *  *  *  * user-name command to be executed
	17 *    * * *   root    cd / && run-parts --report /etc/cron.hourly
	25 6    * * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )
	47 6    * * 7   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )
	52 6    1 * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )
	11  12   30 * *   root    /root/vault/test.kirzhaev.com.update.sh

	#Лог
	Dec 30 12:11:01 vagrant cron[669]: (*system*) RELOAD (/etc/crontab)
	Dec 30 12:11:01 vagrant CRON[10522]: pam_unix(cron:session): session opened for user root by (uid=0)
	Dec 30 12:11:01 vagrant CRON[10523]: (root) CMD (   /root/vault/test.kirzhaev.com.update.sh)

```

