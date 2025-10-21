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

   

# 切换分支

1. 代码

   ```
   // 创建并切换
   git checkout -b main
   // 切换分支
   git checkout main
   
   // 查看本地分支
   git branch
   
   
   ```
   
   

# 重命名分支后的新设置

```
# 重命名本地分支
git branch -m master main_hub
# 获取远程最新信息
git fetch github
# 重新设置远程分支
git branch -u github/main main_hub
# 设置本质记录的远程仓库head引用
git remote set-head github -a
```



# 将master副分支合并到main主分支

1. 同步两个分支

   ```
   # 获取远程所有分支的最新信息
   git fetch --all
   
   # 切换到 main 分支
   git checkout main
   # 拉取远程 main 分支的最新代码
   git pull origin main
   
   # 切换到 master 分支
   git checkout master
   # 拉取远程 master 分支的最新代码
   git pull origin master
   ```

2. 在本地先行合并分支

   ```
   # 确保当前位于 main 分支
   git checkout main
   # 将本地 master 分支合并到当前分支 (main)
   git merge master
   ```

3. 处理冲突

   ```
   如果 git merge后提示冲突，你需要手动解决。
   使用 git status查看冲突文件。
   打开这些文件，找到 <<<<<<<, =======, >>>>>>>标记的冲突内容，根据需要修改代码。
   解决所有冲突后，标记文件为已解决状态并提交合并结果
   git add <解决冲突的文件名>
   ```

4. 推送

   ```
   git add .
   git commit -m ""
   git push origin main
   ```

5. 删除副分支

   ```
   # 删除本地 master 分支
   git branch -d master
   # 删除远程 master 分支
   git push origin --delete master
   ```

   























### 🔍 Git 核心命令速查表

下表按使用场景分类，列举了最常用和关键的 Git 命令。

| 类别               | 命令                           | 说明                                               |
| ------------------ | ------------------------------ | -------------------------------------------------- |
| **仓库初始化**     | `git init`                     | 在当前目录初始化一个新的 Git 仓库 。               |
|                    | `git clone <url>`              | 克隆（下载）一个远程仓库到本地 。                  |
| **文件跟踪与提交** | `git add <file>`               | 将工作区的文件修改添加到暂存区 。                  |
|                    | `git commit -m "message"`      | 将暂存区的内容提交到本地仓库，并附上提交信息 。    |
| **查看状态与历史** | `git status`                   | 查看工作区和暂存区的当前状态 。                    |
|                    | `git log`                      | 查看提交历史 。                                    |
| **分支管理**       | `git branch`                   | 列出所有本地分支 。                                |
|                    | `git checkout -b <new-branch>` | 创建并切换到一个新分支 。                          |
|                    | `git merge <branch>`           | 将指定分支合并到当前分支 。                        |
| **远程协作**       | `git remote add <name> <url>`  | 添加一个远程仓库并为其起一个别名（如 `origin`） 。 |
|                    | `git push <remote> <branch>`   | 将本地分支的提交推送到远程仓库 。                  |
|                    | `git pull <remote> <branch>`   | 从远程仓库拉取更新并合并到当前分支 。              |
| **撤销与重置**     | `git restore <file>`           | 撤销工作区中文件的修改（较新版本的Git命令） 。     |
|                    | `git reset --hard <commit>`    | 强制将当前分支的HEAD重置到指定的提交，慎用 。      |

### 💡 理解 Git 的工作流程

要更好地使用这些命令，可以结合 Git 的 **“三个工作区”** 来理解：

1. **工作区**：你直接编辑文件的地方。
2. **暂存区**：使用 `git add`后，文件的更改被放入暂存区，准备下次提交。
3. **本地仓库**：使用 `git commit`后，暂存区的内容被永久保存到本地仓库的一个新提交中 。

日常基本流程就是：在工作区**修改**文件 → 使用 `git add`将更改**添加**到暂存区 → 使用 `git commit`将暂存区的更改**提交**到本地仓库。

### 🛠️ 进阶命令与技巧

当你熟悉基础后，这些命令能让协作更高效：

- **暂存更改**：当需要临时切换上下文但还没完成当前工作时，可以用 `git stash`将未提交的修改保存起来，之后用 `git stash pop`恢复 。
- **比较差异**：使用 `git diff`可以查看工作区与暂存区（`git diff`）、暂存区与最新提交（`git diff --staged`）之间的差异 。
- **标签管理**：为重要的提交（如版本发布）打上标签，使用 `git tag -a v1.0 -m "Version 1.0"`创建带注释的标签，然后用 `git push origin --tags`推送到远程 。

### ⚠️ 重要注意事项

- **谨慎使用 `git reset --hard`**：此命令会丢弃工作区和暂存区的所有更改，且难以恢复，使用前请务必确认 。
- **先拉取再推送**：在执行 `git push`之前，最好先执行 `git pull`拉取远程的最新更改，避免冲突。
- **提交信息清晰**：编写有意义的提交信息，方便日后回溯历史。

### 🚀 如何开始练习

1. **配置用户信息**（第一步）：

   ```
   git config --global user.name "你的用户名"
   git config --global user.email "你的邮箱"
   ```

2. **在本地创建一个练习文件夹**，使用 `git init`初始化。

3. **创建几个文本文件，模拟修改**，然后练习 `git add`和 `git commit`。

4. **在GitHub或Gitee上创建一个空的远程仓库**，然后使用 `git remote add origin <你的仓库URL>`关联本地仓库，最后用 `git push -u origin main`推送上去。









# 代码

```
// 清理本地远程跟踪分支缓存
git fetch origin --prune

# 列出所有远程分⽀
git branch -r
# 列出所有本地分⽀和远程分⽀
git branch -a
# 新建⼀个分⽀，但依然停留在当前分⽀
git branch [branch-name]
# 新建⼀个分⽀，并切换到该分⽀
git checkout -b [branch]
# 新建⼀个分⽀，指向指定commit
git branch [branch] [commit]
# 新建⼀个分⽀，与指定的远程分⽀建⽴追踪关系
git branch --track [branch] [remote-branch]

# 设置远程分支
git branch -u origin/main main
```

