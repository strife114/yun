# 初次安装git的操作

1. 本地生成密钥

   ```
   ssh-keygen -t rsa -C "1272776782@qq.com"
   
   
   ```

2. 告诉本机系统

   ```
   ssh-add ~/.ssh/id_rsa
   
   # 可能出现报错Could not open a connection to your authentication agent.
   ssh-agent bash
   ```

3. 查看生成的公钥

   ```
   cat ~/.ssh/id_rsa.pub
   
   
   # 或者去
   C:\Users\ASUS\.ssh
   ```

4. 上传公钥

   ```
   复制公钥到gitee的公钥页面（在个人页面的设置中）
   ```

5. 配置user

   ```
   git config --global user.name "Strife"
   git config --global user.email "1272776782@qq.com"
   ```

6. 初始化（在当前目录新建一个git代码库）

   ```
   git init
   ```

7. **添加变更文件**

   ```
   git add .
   ```

8. **提交文件**

   ```
   git commmit -am "message" // 表示提交全部变更文件
   
   
   
   
   
   ```
   
9. 添加远程地址

   ```
    git remote add origin git@gitee.com:Strife-Dispute/yun.git
    
    
    # 测试
    ssh -T git@gitee.com
    
    
    # 注意
    1. 可能出现的错误：fatal: remote origin already exists.
    
    
    # 解决方法
    1. 执行 git remote rm origin
   ```

10. 合并master

    ```
    git pull origin master --allow-unrelated-histories
    ```

11. **推送**

    ```
    git push -u origin master 或
    git push 你的gitee上的仓库名 master  # 推送到指定的仓库的master分支
    
    # 强制推送
    git push -u origin master -f
    
    
    # 注意
    1. 提交时可能会出现一下错误
           error: failed to push some refs to 'https://gitee.com/tomFat/interview.git'
    
    # 解决方法
    1. 提交前执行git pull origin master
    ```
    





# 推送

1. 添加当前目录的所有文件到暂存区

   ```
   git add .
   ```

2. 提交暂存区到本地仓库

   ```
   git commit -m "message"
   
   
   
   
   # 可以先查看变化了什么再提交到本地仓库
   git commit -v
   
   # 注意
   1. 必须加上注释信息
   ```

3. 推送本地仓库到目标仓库

   ```
   git push origin master
   ```

4. 注意事项

   ```
   1. 推送的目录里面必须有文件
   2. 提交时必须加上注释信息
   ```

   