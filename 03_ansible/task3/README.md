# Подготовка к выполнению
<img width="1906" height="439" alt="0" src="https://github.com/user-attachments/assets/dede5896-c6f5-4358-8f7a-3caddac8647c" />

# Основная часть
## 1 Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает LightHouse.
tasks:

    - name: Ensure Lighthouse directory exists
      ansible.builtin.file:
        path: "{{ lighthouse_location_dir }}"
        state: directory
        owner: root
        group: root
        mode: "0755"
      become: yes  
	  
    - name: Lighthouse | Copy from git
      ansible.builtin.git:
        repo: "{{ lighthouse_vcs }}"
        version: "{{ lighthouse_git_version }}"
        dest: "{{ lighthouse_location_dir }}"
        force: no
        accept_hostkey: yes
        depth: 1
        single_branch: yes
		
    - name: Lighthouse | Create Lighthouse config
      become: true
      ansible.builtin.template:
        src: templates/lighthouse.conf.j2
        dest: /etc/nginx/conf.d/default.conf  #/etc/nginx/conf.d/lighthouse.conf
        mode: '0644'
      notify: reload-nginx

## 2 При создании tasks рекомендую использовать модули: get_url, template, yum, apt.
- пробовал, лучше всего получается через apt.

## 3 Tasks должны: скачать статику LightHouse, установить Nginx или любой другой веб-сервер, настроить его конфиг для открытия LightHouse, запустить веб-сервер.
  tasks:
  
    - name: Update apt cache
      ansible.builtin.apt:
        update_cache: true

    - name: NGINX | Install NGINX
      ansible.builtin.apt:
        name: nginx
        state: present
      notify: start-nginx
      tags:
        - nginx
        - distr

    - name: NGINX | Create nginx configuration
      ansible.builtin.template:
        src: templates/nginx.conf.j2
        dest: /etc/nginx/nginx.conf  #"{{ nginx_config_path }}"
        mode: '0644'
      notify: reload-nginx
      tags:
        - nginx
        - config
	
## 4 Подготовьте свой inventory-файл prod.yml.
clickhouse:
  hosts:
  
    clickhouse-01:
      ansible_host: 93.77.191.112
      ansible_user: ubuntu
      ansible_ssh_private_key_file: ~/.ssh/ssh-rsa
      ansible_host_key_checking: false
      ansible_python_interpreter: /usr/local/bin/python3.11
	  
lighthouse:
  hosts:
  
    lighthouse-01:
      ansible_host: 46.21.247.113
      ansible_user: ubuntu
      ansible_ssh_private_key_file: ~/.ssh/ssh-rsa
      ansible_host_key_checking: false

vector:
   hosts:
  
    vector-01:
      ansible_host: 51.250.90.246
      ansible_user: ubuntu
      ansible_ssh_private_key_file: ~/.ssh/ssh-rsa
      ansible_host_key_checking: false

<img width="1216" height="1016" alt="03_04_clickhouse" src="https://github.com/user-attachments/assets/436d243f-6e23-405b-87c6-d1dd7d6b599c" />

## 5 Запустите ansible-lint site.yml и исправьте ошибки, если они есть.
- ошибок было очень много, начиная от устаревших версий ПО и до заблокированных ресурсов, записыватьб не успевал и не успел. Потратил на исправление ошибок более 90% всего времени.
  
после исправления
<img width="1216" height="1016" alt="03_04_Ansible_ok" src="https://github.com/user-attachments/assets/c3649c75-8a6e-4b50-b26a-86c631fb1e21" />


## 6. Попробуйте запустить playbook на этом окружении с флагом --check.
<img width="1275" height="993" alt="6" src="https://github.com/user-attachments/assets/c605dfeb-1552-4923-b232-a151fe6b37bc" />

## 7. Запустите playbook на prod.yml окружении с флагом --diff. Убедитесь, что изменения на системе произведены.
<img width="1269" height="1010" alt="7" src="https://github.com/user-attachments/assets/f8779f94-3e73-4b4b-bc79-42977cc78f48" />

## 8. Проверка.

<img width="1266" height="1100" alt="vector" src="https://github.com/user-attachments/assets/e316cd17-790d-4a61-9c06-51d9a8ccbcf4" />


## 9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
playbook.md

## 10. Готовый playbook выложите в свой репозиторий, поставьте тег 08-ansible-03-yandex на фиксирующий коммит, в ответ предоставьте ссылку на него.
