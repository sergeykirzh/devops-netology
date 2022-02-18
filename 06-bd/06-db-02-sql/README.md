# Домашнее задание к занятию "6.2. SQL"

## Введение

Перед выполнением задания вы можете ознакомиться с
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume,
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.
```
# Use postgres/example user/password credentials
version: '3.1'

networks:
  postgres:
    driver: bridge

volumes:
  postgres_data: {}
  postgres_backup: {}

services:

  db:
    image: postgres:12
    networks:
      - postgres
    restart: always
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - postgres_backup:/backup
    environment:
      POSTGRES_PASSWORD: 1111

  adminer:
    image: adminer
    networks:
      - postgres

    restart: always
    ports:
      - 8080:8080

```

## Задача 2

В БД из задачи 1:
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,

**Ответ**

```
test_db=# \l
                                     List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |       Access privileges
-----------+----------+----------+------------+------------+--------------------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                   +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                   +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/postgres                  +
           |          |          |            |            | postgres=CTc/postgres         +
           |          |          |            |            | "test-admin-user"=CTc/postgres
(4 rows)

```

- описание таблиц (describe)

**Ответ**

```
test_db-# \d clients
                                       Table "public.clients"
      Column       |       Type        | Collation | Nullable |               Default
-------------------+-------------------+-----------+----------+-------------------------------------
 id                | integer           |           | not null | nextval('clients_id_seq'::regclass)
 фамилия           | character varying |           |          |
 cтрана проживания | character varying |           |          |
 заказ             | integer           |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "idx_land" btree ("cтрана проживания")
Foreign-key constraints:
    "fk_orders" FOREIGN KEY ("заказ") REFERENCES orders(id) ON DELETE CASCADE

test_db-# \d orders
                                    Table "public.orders"
    Column    |       Type        | Collation | Nullable |              Default
--------------+-------------------+-----------+----------+------------------------------------
 id           | integer           |           | not null | nextval('orders_id_seq'::regclass)
 наименование | character varying |           |          |
 цена         | integer           |           |          |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "fk_orders" FOREIGN KEY ("заказ") REFERENCES orders(id) ON DELETE CASCADE
```

- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db

**Ответ**
```
SELECT grantee, table_name, privilege_type
 FROM information_schema."table_privileges" where table_name in ('clients','orders')
 AND table_catalog = 'test_db'
 ORDER BY grantee,table_name;
```

- список пользователей с правами над таблицами test_db

**Ответ**

```
     grantee      | table_name | privilege_type
------------------+------------+----------------
 test-admin-user  | clients    | TRIGGER
 test-admin-user  | clients    | REFERENCES
 test-admin-user  | clients    | TRUNCATE
 test-admin-user  | clients    | DELETE
 test-admin-user  | clients    | INSERT
 test-admin-user  | clients    | SELECT
 test-admin-user  | clients    | UPDATE
 test-admin-user  | orders     | INSERT
 test-admin-user  | orders     | SELECT
 test-admin-user  | orders     | UPDATE
 test-admin-user  | orders     | DELETE
 test-admin-user  | orders     | TRUNCATE
 test-admin-user  | orders     | REFERENCES
 test-admin-user  | orders     | TRIGGER
 test-simple-user | clients    | DELETE
 test-simple-user | clients    | INSERT
 test-simple-user | clients    | SELECT
 test-simple-user | clients    | UPDATE
 test-simple-user | orders     | DELETE
 test-simple-user | orders     | UPDATE
 test-simple-user | orders     | SELECT
 test-simple-user | orders     | INSERT
(22 rows)


```

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

**Ответ**

```
INSERT INTO orders (наименование, цена) VALUES
('Шоколад',10)
,('Принтер', 3000)
,('Книга', 500)
,('Монитор', 7000)
,('Гитара', 4000)
```

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

**Ответ**

```
INSERT INTO clients ("фамилия", "cтрана проживания") VALUES
('Иванов Иван Иванович','USA')
,('Петров Петр Петрович','Canada')
,('Иоганн Себастьян Бах','Japan')
,('Ронни Джеймс Дио','Russia')
,('Ritchie Blackmore','Russia')
```

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы

**Ответ**

```
test_db=# SELECT COUNT(*) FROM orders;
 count
-------
     5
(1 row)

test_db=# SELECT COUNT(*) FROM clients;
 count
-------
     5
(1 row)

```


- приведите в ответе:
    - запросы
    - результаты их выполнения.



## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |



Приведите SQL-запросы для выполнения данных операций.

**Ответ**

```
UPDATE clients 
SET заказ = (SELECT id FROM orders WHERE наименование = 'Книга')
WHERE фамилия = 'Иванов Иван Иванович';
UPDATE clients
SET заказ = (SELECT id FROM orders WHERE наименование = 'Монитор')
WHERE фамилия = 'Петров Петр Петрович';
UPDATE clients
SET заказ = (SELECT id FROM orders WHERE наименование = 'Гитара')
WHERE фамилия = 'Иоганн Себастьян Бах';

```

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

**Ответ**

```
SELECT фамилия, "cтрана проживания", наименование, цена
FROM clients cl
JOIN
orders o ON o.id = cl.заказ; 

   фамилия        | cтрана проживания | наименование | цена
----------------------+-------------------+--------------+------
 Иванов Иван Иванович | USA               | Книга        |  500
 Петров Петр Петрович | Canada            | Монитор      | 7000
 Иоганн Себастьян Бах | Japan             | Гитара       | 4000
(3 rows)

```


Подсказк - используйте директиву `UPDATE`.

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

**Ответ**

```
 test_db=# EXPLAIN (ANALYZE)
SELECT фамилия, "cтрана проживания", наименование, цена
FROM clients cl
JOIN
orders o ON o.id = cl.заказ;
                                                    QUERY PLAN
-------------------------------------------------------------------------------------------------------------------
 Hash Join  (cost=37.00..57.24 rows=810 width=100) (actual time=0.026..0.029 rows=3 loops=1)
   Hash Cond: (cl."заказ" = o.id)
   ->  Seq Scan on clients cl  (cost=0.00..18.10 rows=810 width=68) (actual time=0.007..0.008 rows=5 loops=1)
   ->  Hash  (cost=22.00..22.00 rows=1200 width=40) (actual time=0.008..0.008 rows=5 loops=1)
         Buckets: 2048  Batches: 1  Memory Usage: 17kB
         ->  Seq Scan on orders o  (cost=0.00..22.00 rows=1200 width=40) (actual time=0.003..0.005 rows=5 loops=1)
 Planning Time: 0.091 ms
 Execution Time: 0.047 ms
(8 rows)


```

```
Seq Scan — последовательное, блок за блоком, чтение данных таблицы .
cost - величина,призванная оценить затратность операции. Первое значение 0.00 — затраты на получение первой строки. Второе  — затраты на получение всех строк.
rows — приблизительное количество возвращаемых строк при выполнении операции Seq Scan.
width — средний размер одной строки в байтах.


Сначала просматривается (Seq Scan) таблица clients. Для каждой её строки вычисляется хэш (Hash).
Затем сканируется Seq Scan таблица orders, и для каждой строки этой таблицы вычисляется хэш, который сравнивается (Hash Join) с хэшем таблицы clients по условию Hash Cond.
Если соответствие найдено, выводится результирующая строка, иначе строка будет пропущена.
Использовано 17kB в памяти для размещения хэшей таблицы orders.



```

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).



Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.



Приведите список операций, который вы применяли для бэкапа данных и восстановления.

**Ответ**

**backup**
```
pg_dumpall -U postgres  >  /backup/restore**

```
psql -U postgres -f /backup/test_db.out  postgres
```
---

