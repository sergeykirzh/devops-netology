# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

**Ответ**

```
- вывода списка БД

 \l[+]   [PATTERN]      list databases

- подключения к БД

 \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}

- вывода списка таблиц

\d[S+]                 list tables, views, and sequences

- вывода описания содержимого таблиц

\d[S+]  NAME           describe table, view, sequence, or index

- выхода из psql

  \q                     quit psql

```

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

**Ответ**

```
SELECT attname FROM  pg_stats 
WHERE tablename = 'orders' 
AND avg_width = (SELECT  MAX(avg_width) FROM pg_stats where tablename = 'orders');

 attname
---------
 title
(1 row)
```
## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

**Ответ**

```
ALTER TABLE  public.orders DROP CONSTRAINT orders_pkey;
DROP SEQUENCE public.orders_id_seq CASCADE;
ALTER  TABLE orders RENAME TO ordersbak;
CREATE TABLE public.orders 
(
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0
)
PARTITION BY RANGE (price);

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;
ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);

ALTER SEQUENCE public.orders_id_seq RESTART;

ALTER TABLE  public.orders
    ADD CONSTRAINT orders_pkey_cp PRIMARY KEY (id,price);
	
CREATE TABLE public.orders_1 PARTITION OF orders
FOR VALUES FROM (500) TO (MAXVALUE);	

CREATE TABLE public.orders_2 PARTITION OF orders
FOR VALUES FROM (0) TO (500);

INSERT INTO public.orders(title, price) SELECT title,price FROM public.ordersbak;
DROP TABLE public.ordersbak;
```

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

**Ответ**

```
 Возможность партицирования можно заложить при проектировании  таблицы.
```


## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

**Ответ**

```
pg_dump -U postgres -d "test_database" > /backup/test_database_bak.sql
```

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

**Ответ**

```
CREATE TABLE public.orders 
(
    id integer NOT NULL,
    title character varying(80)  NOT NULL,
    price integer DEFAULT 0,
    UNIQUE(title)
);
```
---


