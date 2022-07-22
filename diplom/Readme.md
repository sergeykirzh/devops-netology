# Дипломное задание по курсу «DevOps-инженер»

## Дипломный практикум в YandexCloud

## Проведенные работы:

- Зарегистрировано доменное имя **sksaransk.ru** у регистратора **reg.ru**
 - Созданы  два workspace: stage и prod
 - Сконфигурирован S3 backend в YC облаке 
 
![IMG](img/YC_BACKEND.PNG)

 - Токен для подключения к YC Cloud  экспортирован в переменную окружения YC_TOKEN
 - После последовательго применения команд terraform init, terraform plan, terraform apply в облаке инициализируется 7 хостов

![IMG](img/YC.PNG)

- Подготовдены ansible роли, после разворачивания получили следующие сервисы:

  **Сайт на wordpress**
  
  
 ![IMG](img/WORDPRESS.PNG)
 
 **.gitlab-ci.yml**


 ![IMG](img/GITLAB_CI.PNG)
 
 **gitlab job**
 
  ![IMG](img/GITLAB_JOB.PNG)
  
  
  **gitlab runner**
  
 ![IMG](img/GITLAB_RUNNER.PNG)


**prometheus**

![IMG](img/PROMETHEUS1.PNG)


**alertmanager**

![IMG](img/AlertManager.PNG)






Настроить внешний Reverse Proxy на основе Nginx и LetsEncrypt.
Настроить кластер MySQL.
Установить WordPress.
Развернуть Gitlab CE и Gitlab Runner.
Настроить CI/CD для автоматического развёртывания приложения.
Настроить мониторинг инфраструктуры с помощью стека: Prometheus, Alert Manager и Grafana.
