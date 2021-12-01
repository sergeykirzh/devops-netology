
# Домашнее задание к занятию "3.7. Компьютерные сети, лекция 2"

1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?
	
	**Linux**
	```
	serg@vagrant:~$ ip addr
	1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
		link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
		inet 127.0.0.1/8 scope host lo
		   valid_lft forever preferred_lft forever
		inet6 ::1/128 scope host
		   valid_lft forever preferred_lft forever
	2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
		link/ether 08:00:27:73:60:cf brd ff:ff:ff:ff:ff:ff
		inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
		   valid_lft 58078sec preferred_lft 58078sec
		inet6 fe80::a00:27ff:fe73:60cf/64 scope link
		   valid_lft forever preferred_lft forever

	```
	
	**Windows -  удобно смотреть в Powershell**
	
	```
	PS C:\Users\serg> Get-NetAdapter                                                                                    
	Name                      InterfaceDescription                    ifIndex Status       MacAddress             LinkSpeed
	----                      --------------------                    ------- ------       ----------             ---------
	Сетевое подключение Bl... Bluetooth Device (Personal Area Netw...      20 Disconnected B4-6B-FC-5E-2C-0B         3 Mbps
	Беспроводная сеть         Intel(R) Dual Band Wireless-AC 8265          13 Disconnected B4-6B-FC-5E-2C-07          0 bps
	VirtualBox Host-Only N... VirtualBox Host-Only Ethernet Adapter        11 Up           0A-00-27-00-00-0B         1 Gbps
	Ethernet                  Intel(R) Ethernet Connection (4) I21...       8 Up           10-65-30-27-D0-29       100 Mbps
	Ethernet 2                Cisco AnyConnect Secure Mobility Cli...       5 Not Present  00-05-9A-3C-7A-00          0 bps

	```
	
	
2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?
	
	*Протокол `LLDP`, пакет `lldpd`, команда `lldpctl`*
3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.
	
	*Технология `VLAN`, пакет `vlan`*
	
	**Конфиг**
	
	```
	auto vlan1400
	iface vlan1400 inet static
			address 192.168.1.1
			netmask 255.255.255.0
			vlan_raw_device eth0
			
    ```
	
	*либо*
	
	```
	auto eth0.1400
	iface eth0.1400 inet static
			address 192.168.1.1
			netmask 255.255.255.0
			vlan_raw_device eth0
	```
	
	*Настройка VLAN выполняется также с помощью программы `vconfig`*
4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.
   
   *LAG в Linux – бондинг. протокол LACP*
   
   **Опции**
   ```
   balance-rr
	Последовательно кидает пакеты, с первого по последний интерфейс.
   active-backup
	Один из интерфейсов активен. Если активный интерфейс выходит из строя (link down и т.д.),
	другой интерфейс заменяет активный. Не требует дополнительной настройки коммутатора
   balance-xor
	Передачи распределяются между интерфейсами на основе формулы 
	((MAC-адрес источника) XOR (MAC-адрес получателя)) % число интерфейсов.
	Один и тот же интерфейс работает с определённым получателем. 
	Режим даёт балансировку нагрузки и отказоустойчивость.
   broadcast
	Все пакеты на все интерфейсы
    802.3ad
	Link Agregation — IEEE 802.3ad, требует от коммутатора настройки.
   balance-tlb
	Входящие пакеты принимаются только активным сетевым интерфейсом,
	исходящий распределяется в зависимости от текущей загрузки каждого интерфейса. 
	Не требует настройки коммутатора.
   balance-alb
	Тоже самое что balance-tlb, только входящий трафик тоже распределяется между интерфейсами.
	Не требует настройки коммутатора, но интерфейсы должны уметь изменять MAC.
	```
   **Пример настройки в Ubuntu**
   ```
    файл «/etc/network/interfaces» следует настроить следующим образом:

	auto bond0
	iface bond0 inet dhcp
	   bond-slaves none
	   bond-mode active-backup
	   bond-miimon 100

	auto eth0
	   iface eth0 inet manual
	   bond-master bond0
	   bond-primary eth0 eth1

	auto eth1
	iface eth1 inet manual
	   bond-master bond0
	   bond-primary eth0 eth1
	   
   ```
5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.
	
	*В сети с маской /29 8 IP адресов. Из сети /24 можно получить  32 подсети с маской /29. Примеры -  10.10.10.0/29; 10.10.10.8/29; 10.10.10.16/29; 10.10.10.24/29; 10.10.10.32/29; 10.10.10.40/29...*
6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.
	
	*Возможно задействовать сеть 100.64.0.0/10. Пример под 40-50 хостов 100.64.0.0/26*
7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?
	
	```
						           Linux                 Windows
	Проверка ARP таблицы	 	 		 ip neigh                 arp -a
	Полная очистка ARP кэша 			 ip neigh flush all       arp -d *
	Удаление IP адреса из таблицы        ip neigh flush 192.168.0.56	arp -d 192.168.0.56	
	```
	
	


