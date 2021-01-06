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
- Create `/sample_app/shared/config/application.yml` include SECRET_KEY_BASE
- Create `/sample_app/shared/config/database.yaml` with content: <br/>
```
production:
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  database: sample_app_production
  username: sample_app
  password: 'ZypCPp7c'
  host: 'cdc.xxxxxxxxxxx.ap-southeast-1.rds.amazonaws.com'
  port: 5432
```

**Ruby 2.7.1 and Rails  6.0.3.4**

- Guide : https://gorails.com/setup/ubuntu/18.04

**Nginx**
- Install using  `$sudo apt install nginx`
- replace content`/etc/nginx/sites-available/default` with content <br/>
```
upstream myapp {
     unix:/home/deploy/sample_app/shared/tmp/sockets/puma.sock;
   }
   
   server {
           listen 80 default_server;
           listen [::]:80 default_server;
   
           root /home/deploy/sample_app/current/public;
           index index.html index.htm index.nginx-debian.html;
           server_name sample_app;
   
           location ^~ /assets/ {
                   gzip_static on;
                   expires 12h;
                   add_header Cache-Control public;
           }
   
           location / {
                   proxy_http_version 1.1;
                   proxy_cache_bypass $http_upgrade;
   
                   proxy_set_header Upgrade $http_upgrade;
                   proxy_set_header Connection 'upgrade';
                   proxy_set_header Host $host;
                   proxy_set_header X-Real-IP $remote_addr;
                   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                   proxy_set_header X-Forwarded-Proto $scheme;
   
                   proxy_pass http://myapp;
           }

           location /cable {
                   proxy_pass http://backend;
                   proxy_http_version 1.1;
                   proxy_set_header Upgrade "websocket";
                   proxy_set_header Connection "Upgrade";
                   proxy_set_header X-Real-IP $remote_addr;
                   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           }
}
```
- `$sudo service nginx restart`

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
