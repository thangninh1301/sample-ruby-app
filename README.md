# README
**DISCLAIMER:**
Read the entire README before you start.\

Things you may want to cover:


<summary><strong>Main software</strong></summary>
<br>

| Component      | Version        |
| -------------- | -------------- |
| ruby           | 2.7.1          |
| rails          | 6.0.3.4        |
| nginx          | last           |
| puma           | install as gem |
| ubuntu         | 18.04          |


<details>  

<summary><strong>Deployment environment</strong></summary>
<br>

**Create user deploy**
- Create user `deploy` with root privilege 

**Postgres**

- Install using  `$sudo apt install postgresql-10 libpq-dev`
- Edit pg_hba.conf `$sudo vim /etc/postgresql/10/main/pg_hba.conf`<br/>
change `local   all        all                                     peer`
to  `local   all        all                                     md5`
- Save and exit
- Create user `$sudo -i -u postgres psql` <br/>
  Type: `create user sample_app with password "ZypCPp7c";` <br/>
  Type: `alter user sample_app superuser;`
  
**Ruby 2.7.1 and Rails  6.0.3.4**

- Guide : https://gorails.com/setup/ubuntu/18.04

**Install gem**
- `cd ~/sample_app && bundle i`

**Nginx**
- Install using  `$sudo apt install nginx`
- replace `/etc/nginx/sites-available/default` with `sample_app/default`
- `$sudo service nginx restart`

**Install redis**
- Guide: https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-redis-on-ubuntu-18-04

**Run puma as service**
- Run in local IDE `bundle execcap production puma:systemd:config puma:systemd:enable`
- Run in server `sudo vim /etc/systemd/puma_sample_app_production.service`
- Replace `$HOME` to `/home/deploy/`
- `$sudo systemctl daemon-reload`
- `$sudo service puma_sample_app_production restart`
</details>  

<details>  

<summary><strong>How to deploy</strong></summary>
<br>

**Run in local IDE**
- `$bundle exec cap production deploy`
</details>  
