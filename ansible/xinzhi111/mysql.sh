#!/bin/bash
mysql -e "create kodbox;"
mysql -e "create user kodbox@'192.168.6.%' identified by '123456';"
mysql -e "grant all on *.* to kodbox@'localhost' identified by '123456';"
mysql -e "flush privileges;"
