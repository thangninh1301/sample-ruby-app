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

<summary><strong>Deployment</strong></summary>
<br>

**Clone project**

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

**Environment variables**
- Gen secret key `$cd /home/ubuntu/sample_app && rails secret` 
- Set env variables: <br/>
`RAILS_ENV=production` <br/>
`SAMPLE_APP_DATABASE_PASSWORD=ZypCPp7c` <br/>
`RAILS_SERVE_STATIC_FILES=true` <br/>
`SECRET_KEY_BASE=generated_key`

**Run puma as service**
- Copy file `sample_app/puma.service` to `/etc/systemd/system/`
- `$sudo systemctl daemon-reload`
- `$sudo systemctl enable puma`
- `$sudo service puma restart`
</details>  

