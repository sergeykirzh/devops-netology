# Домашнее задание к занятию "3.2. Работа в терминале, лекция 2"

1. Какого типа команда `cd`? Попробуйте объяснить, почему она именно такого типа; опишите ход своих мыслей, если считаете что она могла бы быть другого типа.
  
   *Встроенная в командную оболочку команда.Служит для навигации по директориям внутри файловой системы*
1. Какая альтернатива без pipe команде `grep <some_string> <some_file> | wc -l`? `man grep` поможет в ответе на этот вопрос. Ознакомьтесь с [документом](http://www.smallo.ruhr.de/award.html) о других подобных некорректных вариантах использования pipe.
   
   ```
   grep  -c <some_string> <some_file> 
   
   ```
1. Какой процесс с PID `1` является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?
   ```
    serg@vagrant:~$ ps 1
      PID TTY      STAT   TIME COMMAND
        1 ?        Ss     0:01 /sbin/init
	serg@vagrant:~$ readlink /sbin/init
	/lib/systemd/systemd
   ```
   */sbin/init - это символическая ссылка на /lib/systemd/systemd*
   
1. Как будет выглядеть команда, которая перенаправит вывод stderr `ls` на другую сессию терминала?
   ```
   ls -l 2> /dev/pts/1
   ```
1. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.
	```
	serg@vagrant:~$ echo Testline > source_file
	serg@vagrant:~$ cat < source_file  > dest_file
	serg@vagrant:~$ cat dest_file
	Testline
   	```
1. Получится ли находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?
   
   *Mы можем связать pty эмулятором TTY и наблюдать там выводимые данные.*
1. Выполните команду `bash 5>&1`. К чему она приведет? Что будет, если вы выполните `echo netology > /proc/$$/fd/5`? Почему так происходит?
	```
	$ bash 5>&1
	$ echo netology > /proc/$$/fd/5
	netology
	```
	*Создали новый файловый дескриптор с номером 5 и связали его с stdout.Подали на ввод команде echo  аргумент netology и перенаправили поток в файловый дескриптор
5, который связан с stdout. В результате получили вывод строки netology на терминал*
1. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty? Напоминаем: по умолчанию через pipe передается только stdout команды слева от `|` на stdin команды справа.
Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.
   ```
   serg@vagrant:/home$ ls /root/ /var/ 5>&1 1>&2 2>&5 | tr s S
   lS: cannot open directory '/root/': PermiSSion denied
   /var/:
   backups  cache  crash  lib  local  lock  log  mail  opt  run  snap  spool  tmp
   ```
1. Что выведет команда `cat /proc/$$/environ`? Как еще можно получить аналогичный по содержанию вывод?
   
   *Выведет переменные окружения текущего процесса командной оболочки bash.Вывод аналогичен у команды `env`*
1. Используя `man`, опишите что доступно по адресам `/proc/<PID>/cmdline`, `/proc/<PID>/exe`.
   
   `/proc/<PID>/cmdline` *- Этот файл, доступный только для чтения, содержит полную командную строку для процесса, если только процесс не является зомби процессом.*
   
   `/proc/<PID>/exe` *- Представляет собой символическую ссылку, содержащую фактический путь к выполняемой команде. Эта символическая ссылка может быть разыменована в обычном режиме, попытка открыть его приведет к открытию исполняемого файла.*
1. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью `/proc/cpuinfo`.

	`sse sse2 sse4_1 sse4_2`
1. При открытии нового окна терминала и `vagrant ssh` создается новая сессия и выделяется pty. Это можно подтвердить командой `tty`, которая упоминалась в лекции 3.2. Однако:

    ```bash
	vagrant@netology1:~$ ssh localhost 'tty'
	not a tty
    ```

	Почитайте, почему так происходит, и как изменить поведение.
	
	*При таком сценарии запускаемая команда выполняется не внутри терминала. Для выполнения команды внутри терминала команда приобретет вид* `ssh -t localhost 'tty'`*. В этом случае сформируется подключение, выделится pty, исполнится команда, закроется подключение.* 
1. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись `reptyr`. Например, так можно перенести в `screen` процесс, который вы запустили по ошибке в обычной SSH-сессии.
   ```
   screen -S test
   ping 8.8.8.8 
   Ctrl-z  
   jobs -l 
   screen -r
   reptyr 1283  
   ```
1. `sudo echo string > /root/new_file` не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без `sudo` под вашим пользователем. Для решения данной проблемы можно использовать конструкцию `echo string | sudo tee /root/new_file`. Узнайте что делает команда `tee` и почему в отличие от `sudo echo` команда с `sudo tee` будет работать.

*tee – чтение с stdin и запись в stdout и file.
Вторая команда будет работать поскольку непосредственная запись в файл выполняется от рута.*

 
 