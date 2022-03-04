# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста

**Ответ**

```
FROM centos:7

#Default version elasticsearch
ARG version=7.16.0

RUN yum -y install wget \
    perl-Digest-SHA \
    && yum clean all\
    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${version}-linux-x86_64.tar.gz  \
    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${version}-linux-x86_64.tar.gz.sha512 \
    && shasum -a 512 -c elasticsearch-${version}-linux-x86_64.tar.gz.sha512 \
    && tar -xzf elasticsearch-${version}-linux-x86_64.tar.gz \
    && rm -f elasticsearch-${version}-linux-x86_64.tar*



ENV ES_HOME=/elasticsearch-${version}

WORKDIR $ES_HOME

COPY elasticsearch.yml ./config/

RUN groupadd elasticsearch \
    && useradd -g elasticsearch elasticsearch \
    && mkdir /var/lib/logs \
    && chown elasticsearch /var/lib/logs \
    && mkdir /var/lib/data \
    && chown elasticsearch /var/lib/data \
    && mkdir ./snapshots \
    && chown -R elasticsearch ./

EXPOSE 9200 9300


USER elasticsearch

CMD [ "./bin/elasticsearch" ]


```


- ссылку на образ в репозитории dockerhub


**Ответ**


[Образ](https://hub.docker.com/r/blynksekir80/elastic/tags)

- ответ `elasticsearch` на запрос пути `/` в json виде

**Ответ**

```
{
  "name" : "d4d45217ac97",
  "cluster_name" : "netology_test",
  "cluster_uuid" : "ucgsn8RURK6u7USG6LCcFg",
  "version" : {
    "number" : "7.17.0",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "bee86328705acaa9a6daede7140defd4d9ec56bd",
    "build_date" : "2022-01-28T08:36:04.875279988Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}

```

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html)
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

```
vagrant@vagrant:~$ curl -X PUT "172.17.0.2:9200/ind-1?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 1,
      "number_of_replicas": 0
    }
  }
}
'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-1"
}
vagrant@vagrant:~$ curl -X PUT "172.17.0.2:9200/ind-2?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 2,
      "number_of_replicas": 1
    }
  }
}
'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-2"
}
vagrant@vagrant:~$ curl -X PUT "172.17.0.2:9200/ind-3?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 4,
      "number_of_replicas": 2
    }
  }
}
'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-3"
}

```

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

**Ответ**

```
vagrant@vagrant:~$ curl -X GET  http://172.17.0.2:9200/_cat/indices?v
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases 2c9ne4CETi6ij8T_idhazQ   1   0         41            0     39.5mb         39.5mb
green  open   ind-1            wnvfO9ltTFWoXSKIesopzQ   1   0          0            0       226b           226b
yellow open   ind-3            qygyKKwWRSySC6gc203q5Q   4   2          0            0       904b           904b
yellow open   ind-2            t50YR8sGSUi8w1A9-_lqwg   2   1          0            0       452b           452b



```
Получите состояние кластера `elasticsearch`, используя API.

**Ответ**


```
vagrant@vagrant:~$ curl -X GET  http://172.17.0.2:9200/_cluster/health?pretty
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 10,
  "active_shards" : 10,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}

```

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

**Ответ**

```
Нехватка  нод для реплик  вызвала "желтушность" индексов,  соответственно образовавшиеся  "unassigned_shards" привели в статус "yellow" состояние кластера.

```

Удалите все индексы.

```
 curl -X DELETE  http://172.17.0.2:9200/_all
```

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository)
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

**Ответ**

```
vagrant@vagrant:~$ curl -X PUT "172.17.0.2:9200/_snapshot/netology_backup" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/elasticsearch-7.17.0/snapshots"
  }
}'
{"acknowledged":true}

```

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

**Ответ**

```
vagrant@vagrant:~$ curl -X GET  http://172.17.0.2:9200/_cat/indices?v
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases 2c9ne4CETi6ij8T_idhazQ   1   0         41            0     39.5mb         39.5mb
green  open   test             3GHdF50mTQ-tR5IGCIEBvw   1   0          0            0       226b           226b

```

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html)
состояния кластера `elasticsearch`.

```
vagrant@vagrant:~$ curl -X PUT 172.17.0.2:9200/_snapshot/netology_backup/first_snapshot?wait_for_completion=true
```

**Приведите в ответе** список файлов в директории со `snapshot`ами.

```
[elasticsearch@d4d45217ac97 elasticsearch-7.17.0]$ ll snapshots/
total 48
-rw-r--r-- 1 elasticsearch elasticsearch  1426 Mar  4 08:38 index-0
-rw-r--r-- 1 elasticsearch elasticsearch     8 Mar  4 08:38 index.latest
drwxr-xr-x 6 elasticsearch elasticsearch  4096 Mar  4 08:38 indices
-rw-r--r-- 1 elasticsearch elasticsearch 29321 Mar  4 08:38 meta-Ore-igUpTpaFRfIJ_0NRZQ.dat
-rw-r--r-- 1 elasticsearch elasticsearch   713 Mar  4 08:38 snap-Ore-igUpTpaFRfIJ_0NRZQ.dat

```

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

```
vagrant@vagrant:~$ curl -X GET  http://172.17.0.2:9200/_cat/indices?v
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases 2c9ne4CETi6ij8T_idhazQ   1   0         41            0     39.5mb         39.5mb
green  open   test-2           JcoSPM8eTr-cdo5Wii9Tew   3   0          0            0       678b           678b

```

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее.

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

**Ответ**

```
curl -X POST 172.17.0.2:9200/_snapshot/netology_backup/first_snapshot/_restore?pretty  -H 'Content-Type: application/json' -d'
{
  "indices": "test"
}
'

vagrant@vagrant:~$ curl -X GET  http://172.17.0.2:9200/_cat/indices?v
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases 2c9ne4CETi6ij8T_idhazQ   1   0         41            0     39.5mb         39.5mb
green  open   test-2           JcoSPM8eTr-cdo5Wii9Tew   3   0          0            0       678b           678b
green  open   test             ow-4uaGuRoun60eFAAGgvw   1   0          0            0       226b           226b

```

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---

