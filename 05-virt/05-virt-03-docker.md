
# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

## Как сдавать задания

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.

Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в github репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Любые вопросы по решению задач задавайте в чате учебной группы.

---

## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

[Ссылка на ответ](https://hub.docker.com/r/blynksekir80/netology)


## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;


_Наиболее оптимальным размещением на мой взгляд будет физический сервер_
- Nodejs веб-приложение;

_Docker, т.к контейниризация  позволяет оптимизировать процесс разработки и вывода в продакшн Node.js-проектов._
- Мобильное приложение c версиями для Android и iOS;

_Наиболее оптимальны для использования виртуальные машины, т к среды выполнения отличны от Linux и не подходят для Docker_
- Шина данных на базе Apache Kafka;

_Ничто не мешает вынести в контейнеры. Для Apache Kafka имеются  готовые образы Docker_

- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;

_Сам производитель рекомендует реализовывать в  Docker.Имеет смысл прислушаться._
- Мониторинг-стек на базе Prometheus и Grafana;

_Так же контейнеры один из способов инсталляции рекомендованных производителем, выбираем Docker_
- MongoDB, как основное хранилище данных для java-приложения;

_Физический или виртуальный сервер видятся оптимальным выбором_
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

_Допустимы все 3 варианта. Реализация выбирается исходя из поставленной задачи_

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

```
vagrant@vagrant:~$ docker pull centos
Using default tag: latest
latest: Pulling from library/centos
a1d0c7532777: Pull complete
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:latest
docker.io/library/centos:latest
vagrant@vagrant:~$ docker pull debian
Using default tag: latest
latest: Pulling from library/debian
0c6b8ff8c37e: Pull complete
Digest: sha256:fb45fd4e25abe55a656ca69a7bef70e62099b8bb42a279a5e0ea4ae1ab410e0d
Status: Downloaded newer image for debian:latest
docker.io/library/debian:latest

vagrant@vagrant:~$ mkdir data
vagrant@vagrant:~$ pwd
/home/vagrant

vagrant@vagrant:~$ docker run --rm --name cent -itd -v /home/vagrant/data:/data centos
a279ebc0c538be458c200ffea2e73022f9bda8679ead4427b157e7cd7cb7a67e
vagrant@vagrant:~$ docker run --rm --name deb -itd -v /home/vagrant/data:/data debian
70260743bd1379848d561dc197f040d31e1ab97bf2a1bfe0d465b26a48b82a0d
vagrant@vagrant:~$ docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS          PORTS     NAMES
70260743bd13   debian    "bash"        14 seconds ago   Up 12 seconds             deb
a279ebc0c538   centos    "/bin/bash"   46 seconds ago   Up 43 seconds             cent

vagrant@vagrant:~$ docker exec -it cent bash
[root@a279ebc0c538 /]# ls
bin  data  dev  etc  home  lib  lib64  lost+found  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
[root@a279ebc0c538 /]# cd /data
[root@a279ebc0c538 data]# touch file1 
[root@a279ebc0c538 data]# ls
file1
[root@a279ebc0c538 data]# exit
exit

vagrant@vagrant:~$ touch data/file2

vagrant@vagrant:~$ docker exec -it deb bash
root@70260743bd13:/# ls /data
file1  file2

```


---
