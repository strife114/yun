#!/bin/bash
mysql -uroot -p123456 -e "create database kodbox;create user kodbox@'192.168.6.%' identified by '123456';grant all privileges on *.* to 'kodbox'@'%' identified by '123456';flush privileges;"
