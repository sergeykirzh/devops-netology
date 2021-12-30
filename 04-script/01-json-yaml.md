### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-03-yaml/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```json
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис


```json
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            },
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43"
            }
        ]
    }
```

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import socket,time,json,yaml

dservices={}
services = ["drive.google.com","mail.google.com","google.com"]

def outputfile():
        list = []
        for k, v in dservices.items():
                list.append({k:v})
        with open("status.json",'w') as js:
                js.write(json.dumps(list))
        with open("status.yml",'w') as ym:
                ym.write(yaml.dump(list))


for  service in services:
        dservices[service]=socket.gethostbyname(service)
outputfile()
print('\n##########################################################################################################\n')
print(dservices)
print('\n##########################################################################################################\n')
i=0
while  i <= 100:
        for k, v in dservices.items():
                ip = socket.gethostbyname(k)
                if v != ip:
                        print("[ERROR] " + k+"  IP mismatch: "+ v +" "+ip)
                        dservices[k]=ip
                        outputfile()
        i+=1
        time.sleep(5)
```

### Вывод скрипта при запуске при тестировании:
```
serg@vagrant:~$ ./dz.4.2.4.py

##########################################################################################################

{'drive.google.com': '108.177.14.194', 'mail.google.com': '64.233.164.83', 'google.com': '74.125.131.102'}

##########################################################################################################

[ERROR] mail.google.com  IP mismatch: 64.233.164.83 64.233.164.17
[ERROR] google.com  IP mismatch: 74.125.131.102 74.125.131.113

```

### json-файл(ы), который(е) записал ваш скрипт:
```json
[{"drive.google.com": "108.177.14.194"}, {"mail.google.com": "64.233.164.17"}, {"google.com": "74.125.131.113"}]

```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
- drive.google.com: 108.177.14.194
- mail.google.com: 64.233.164.17
- google.com: 74.125.131.113

```


