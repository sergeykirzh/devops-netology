
# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"


---

## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.

*Значительное увеличение скорости предоставления инфраструктуры для разработки, простая масштабируемость. Возможность получения идентичных сред разработки, тестирования, разворачивания.*

- Какой из принципов IaaC является основополагающим?

*Основополагающий принцип - идемпотентность, т. е. какое бы количество раз мы не разворачивали инфраструктуру по определенноиу паттерну, результат всегда будет один и тот же.*

## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?

*Для доставки конфигурации не требуется установка дополнительных агентов, достаточен доступ по ssh;низкий порог входа для инженеров.*
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?
```
 С моей точки зрения более надежный механизм pull, тк 
    1. Происходит постоянное клиент-серверное взаимодействие и в случае появления новой конфигурации на сервере
       оперативно реплицируются изменения на целевое устройство. 
    2. Отсутствует риск недоставки конфигурации для нового хоста, достаточно только инсталляции нацеленного на сервер конфигураций агента. 
       В случае push мы должны каким-то образом вести актуальный реестр всего зоопарка устройств и оперативно доставлять конфу.	
```

## Задача 3

Установить на личный компьютер:

- VirtualBox
- Vagrant
- Ansible

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

```
svkirzha@debian:~$ vboxmanage --version
6.1.32r149290
svkirzha@debian:~$ vagrant --version
Vagrant 2.2.19
svkirzha@debian:~$ ansible --version
ansible 2.9.27
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u'/home/svkirzha/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 2.7.16 (default, Oct 10 2019, 22:02:15) [GCC 8.3.0]

```

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
```

svkirzha@debian:~/vagrant$ vagrant up
Bringing machine 'server1.netology' up with 'virtualbox' provider...
==> server1.netology: Checking if box 'bento/ubuntu-20.04' version '202112.19.0' is up to date...
==> server1.netology: Clearing any previously set forwarded ports...
==> server1.netology: Clearing any previously set network interfaces...
==> server1.netology: Preparing network interfaces based on configuration...
    server1.netology: Adapter 1: nat
    server1.netology: Adapter 2: hostonly
==> server1.netology: Forwarding ports...
    server1.netology: 22 (guest) => 20011 (host) (adapter 1)
    server1.netology: 22 (guest) => 2222 (host) (adapter 1)
==> server1.netology: Running 'pre-boot' VM customizations...
==> server1.netology: Booting VM...
==> server1.netology: Waiting for machine to boot. This may take a few minutes...
    server1.netology: SSH address: 127.0.0.1:2222
    server1.netology: SSH username: vagrant
    server1.netology: SSH auth method: private key
==> server1.netology: Running provisioner: ansible...
    server1.netology: Running ansible-playbook...

PLAY [nodes] *******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [server1.netology]

TASK [Create directory for ssh-keys] *******************************************
ok: [server1.netology]

TASK [Adding rsa-key in /root/.ssh/authorized_keys] ****************************
changed: [server1.netology]

TASK [Checking DNS] ************************************************************
changed: [server1.netology]

TASK [Installing tools] ********************************************************
ok: [server1.netology] => (item=[u'git', u'curl'])

TASK [Installing docker] *******************************************************
changed: [server1.netology]

TASK [Add the current user to docker group] ************************************
changed: [server1.netology]

PLAY RECAP *********************************************************************
server1.netology           : ok=7    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

svkirzha@debian:~/vagrant$ ssh root@127.0.0.1 -p 20011
The authenticity of host '[127.0.0.1]:20011 ([127.0.0.1]:20011)' can't be established.
ECDSA key fingerprint is SHA256:RztZ38lZsUpiN3mQrXHa6qtsUgsttBXWJibL2nAiwdQ.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '[127.0.0.1]:20011' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
  System information disabled due to load higher than 1.0


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Fri Jan 21 07:12:55 2022 from 10.0.2.2

root@vagrant:~# docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES


```
