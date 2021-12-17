### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-02-py/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | ошибка, разные типы   |
| Как получить для переменной `c` значение 12?  | c = str(a)+b |
| Как получить для переменной `c` значение 3?  | c = a+int(b)

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

path =  "/home/serg/devops-netology/"
bash_command = ["cd "+path, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
#is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(path+prepare_result)
#        break

```

### Вывод скрипта при запуске при тестировании:
```
serg@vagrant:~$ ./dz_4.2.2.py
/home/serg/devops-netology/test
/home/serg/devops-netology/test1

```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
import sys

if len(sys.argv)==1:
        path=os.getcwd()
elif len(sys.argv)==2:
        if not os.path.isdir(sys.argv[1]):
                print("dyrectory "+str(sys.argv[1])+" not found")
                exit()
        else:
                path = sys.argv[1]
else:
        print("unknown argument")
        exit()
if not  path.endswith("/"):
        path = path +  "/"
bash_command = ["cd "+path, "git status 2>&1"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('fatal:') != -1:
       print("directory "+path+" is not a git repository")
       exit()
    if result.find('modified') != -1:
        prepare_result = result.repl
		print(path+prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```
serg@vagrant:~$ ./dz4.2.3.py ~/devops-netology
/home/serg/devops-netology/test
/home/serg/devops-netology/test1

serg@vagrant:~$ ./dz4.2.3.py ~/devops-netology/
/home/serg/devops-netology/test
/home/serg/devops-netology/test1


serg@vagrant:~$ ./dz4.2.3.py blalblalbla
dyrectory blalblalbla not found

serg@vagrant:~$ ./dz4.2.3.py
directory /home/serg/ is not a git repository

serg@vagrant:~$ cd ~/devops-netology
serg@vagrant:~/devops-netology$ ../dz4.2.3.py
/home/serg/devops-netology/test
/home/serg/devops-netology/test1

```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import socket
import time

dservices={}
services = ["drive.google.com","mail.google.com","google.com"]

for  service in services:
        dservices[service]=socket.gethostbyname(service)
print('\n##########################################################################################################\n')
print(dservices)
print('\n##########################################################################################################\n')

#Для  примера возьмем 100 итераций с таймаутом опроса 5с
i=0
while  i <= 100:
        for k, v in dservices.items():
                ip = socket.gethostbyname(k)
                if v != ip:
                        print("[ERROR] "+ k +"  IP mismatch: "+ v +" "+ip)
                        dservices[k]=ip
        i+=1
        time.sleep(5)


```

### Вывод скрипта при запуске при тестировании:
```
serg@vagrant:~$ ./dz4.2.4.py

##########################################################################################################

{'drive.google.com': '209.85.233.194', 'mail.google.com': '142.251.1.19', 'google.com': '74.125.205.139'}

##########################################################################################################

[ERROR] mail.google.com  IP mismatch: 142.251.1.19 142.251.1.17
[ERROR] google.com  IP mismatch: 74.125.205.139 64.233.162.101
[ERROR] google.com  IP mismatch: 64.233.162.101 173.194.73.139
[ERROR] google.com  IP mismatch: 173.194.73.139 173.194.73.102
[ERROR] drive.google.com  IP mismatch: 209.85.233.194 74.125.131.194
[ERROR] mail.google.com  IP mismatch: 142.251.1.17 64.233.165.83
[ERROR] mail.google.com  IP mismatch: 64.233.165.83 64.233.165.17

```
