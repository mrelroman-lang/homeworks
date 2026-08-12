# Домашнее задание  №3 по теме Ansible

Краткое описание: что делает этот playbook

## Оглавление

- [Требования](#требования)
- [Переменные](#переменные)
- [Структура проекта](#структура-проекта)
- [Как запустить](#как-запустить)
- [Примеры использования](#примеры-использования)
- [Зависимости](#зависимости)
- [Тестирование](#тестирование)
- [Работа Ansible-Playbook](#Работа Ansible-Playbook)
- [Известные проблемы и ограничения](#известные-проблемы-и-ограничения)
- [Лицензия](#лицензия)

## Требования

- **ОС**: Linux .deb (Ubuntu 20.04/22.04)
- **Ansible**: использовалась версия 2.21.2 
- **Python**: версия ≥ 3.9
- **Доступ**: SSH-доступ к целевым хостам, права sudo (пароль не нужен)
- **Сеть**: доступность целевых хостов по SSH (порт 22)

## Переменные
Clickhouse, Vector and Ligthouse Ansible-Playbook
Данный playbook скачивает и устанавливает Clichouse и Vector на хосты из файла inventory.

ClickHouse — это  СУБД.

Vector — A lightweight, ultra-fast tool for building observability pipelines.

LightHouse — GUI для ClickHouse.

Nginx - web сервер , необходимы для работы LightHouse.

Версия ОС всех хостов
Ubuntu 24.04 

Имя	Тег	Верси
Clickhouse	сlickhouse	22.8.5.29
Vector	vector	0.44.0
LightHouse	ligthouse	latest
Nginx	nginx	latest
можно указать нужную версию в дерриктории group_vars

## Структура проекта
hmeworks/03_ansible/task3/playbook/
├── group_vars/
│ ├── clickhouse/
│ | └── vars.yaml
│ ├── lighthouse/
│ | └── vars.yaml
│ └── vector/
│   └── vars.yaml
├── inventory/
│ └── prod.yaml
├── templates/
│ ├── lighthouse.conf.j2
│ ├── nginx.conf.j2
│ └── vector.yaml.j2
├── ansible.cfg
|── site.yml
└── README.md

---
`inventory/` — хосты и данные для подключения, `templates/` —шаблоны файлов конфигурвций, `group_vars/` - общие переменные

## Как запустить
### Подготовка инвентаря
Отредактируйте `inventory/prod.yaml`, указав ip адреса хостов.

### Запуск playbook
ansible-playbook -i inventory/prod.yaml site.yml --vv

## Работа Ansible-Playbook
Install nginx - устанавлbвает последнюю версию nginx NGINX | Create general config - настроивает конфигурацию Nginx по шаблону template файла nginx.conf.j2

LightHouse
Install Lighthouse - устанавливает дистрибутив LightHouse с репозитория git указанного в переменных в group_vars Lighthouse | Create ligthouse config - настроивает конфигурацию Lighthouse по шаблону template файла lighthouse.conf.j2

Clickhouse
Download distr - скачивает дистрибутив clickhouse Install clickhouse packages - устанавилвает пакеты для клиента сервара Create database - создает БД с таблицей

Vector
Install Vector - устанавилвает дистрибутив Vector Config template - настроит vector используя файл конфигурации jinja2 из папки templates


## Известные проблемы и ограничения
Не поддерживается ОС Windows как целевой хост.
Требуется доступ в интернет на целевых хостах для установки пакетов.
При первом запуске не получается сделать всё правильно, так как вылезают кучи ошибок, начиная от устаревших ссылок и версий ПО и до блокировки ресурсов. Может потребоваться не один день для отладки проекта.

## Лицензия
Проект распространяется под лицензией MIT.