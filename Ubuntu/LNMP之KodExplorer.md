1. 安装nginx和php
```shell
sudo apt update
sudo apt install php7.4 php7.4-fpm php7.4-gd php7.4-curl php7.4-mbstring nginx -y
sudo apt install unzip net-tools lrzsz -y
```

2. 配置虚拟主机
```shell

server {
listen 80;
server_name kod.oldboyedu.com;
root /code;
index index.php index.html;
location ~ \.php$ {
root /code;
fastcgi_pass 127.0.0.1:9000;
fastcgi_index index.php;
fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
include fastcgi_params;
}
}
```

3. 配置php
```shell
mv /etc/nginx/sites-enabled/default /tmp/
cd /etc/php/7.4/fpm/pool.d/
sed -i 's#listen = /run/php/php7.4-fpm.sock#listen = 127.0.0.1:9000#' www.conf
grep 9000 www.conf
```

4. 下载并解压可道云
```shell
sudo mkdir /code/&&cd /code/
sudo wget http://static.kodcloud.com/update/download/kodexplorer4.40.zip
sudo unzip kodexplorer4.40.zip -d /code/
sudo chown -R www-data:www-data /code/
```

5. 检查
```shell
sudo systemctl restart nginx php7.4-fpm
netstat -lntup|egrep -w "9000|80"
```

6. 浏览器输入服务器ip

![image.png](https://cdn.nlark.com/yuque/0/2023/png/28700099/1703406527176-d254a802-a85e-41ec-b89e-26bbe14935af.png#averageHue=%23617794&clientId=u65db0b0b-2086-4&from=paste&height=747&id=ub2f842f0&originHeight=934&originWidth=1920&originalType=binary&ratio=1.25&rotation=0&showTitle=false&size=1177706&status=done&style=none&taskId=u692b5ec2-4886-482e-8d05-3d4c7fe4d80&title=&width=1536)
