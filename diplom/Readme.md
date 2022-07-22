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

- Подготовлены ansible роли, после разворачивания получили следующие сервисы:

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

![IMG](img/AlertManager_.PNG)


**grafana**

![IMG](img/GRAFANA.PNG)



- Учетная запись для входа в web-интерфейс у gitlab: root, wordpress: serg, у оставшихся: admin; пароль везде:
- Переменные задаются в variables.tf, S3 backend  настраивается в versions.tf
- По умолчанию сертификаты генерируются в тестовой зоне




