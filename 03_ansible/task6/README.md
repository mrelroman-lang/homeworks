# Домашнее задание к занятию 6 «Создание собственных модулей»

## Подготовка к выполнению

![](./assets/6_Подготовка.png)

## Основная часть

Ваша цель — написать собственный module, который вы можете использовать в своей role через playbook. Всё это должно быть собрано в виде collection и отправлено в ваш репозиторий.

** Проверьте module на исполняемость локально.

![](./assets/6_4.png)

** Напишите single task playbook и используйте module в нём.
** Проверьте через playbook на идемпотентность.

![](./assets/6_5_6.png)

** Инициализируйте новую collection:
![](./assets/6_8.png)

** Single task playbook преобразуйте в single task role и перенесите в collection. У role должны быть default всех параметров module.

![](./assets/6_10.11.png)

** Создайте .tar.gz этой collection: `ansible-galaxy collection build` в корневой директории collection.

![](./assets/6_13.png)

** Установите collection из локального архива,
** Запустите playbook, убедитесь, что он работает.

![](./assets/6_15_16.png)

** В ответ необходимо прислать ссылки на collection и tar.gz архив, а также скриншоты выполнения пунктов 4, 6, 15 и 16.
- https://github.com/mrelroman-lang/my_own_collection
- https://github.com/mrelroman-lang/homeworks/tree/main/03_ansible/task6
