

# 使用步驟

## 第一步驟 修改專案目錄
```
volumes:
    - "/Desktop/laravel/blog:/var/www/html/"
```
## 第二步驟 啟動 docker
```
docker-compose up -d 
```

# docker 基本指令
|指令|描述|
|---|---|
|docker images| 查看所有映像檔|
|docker ps -a| 查看所有容器|
|docker ps| 查看目前運行中的容器|
|docker rmi <hashid> | 刪除映像檔|
|docker rm <hashid> | 刪除容器|
|docker start <container>| 啟動關閉中的容器|
|docker stop <container>| 關閉啟動中的容器|
|docker run -it <image> bash| 啟動容器並用bash進入容器中|

# docker run 參數說明
|參數|描述|
|---|---|
|--name|容器名稱|
|-p 8080:80|對外的 port|
|-volumes xxx/xxx:/var/www/html |將外部檔案掛載到容器|
|--link mysql:mysql|連結相同網域的容器|

# docker-compose 基本指令
|指令|描述|
|---|---|
|docker-compose up -d| 背景啟動容器並安裝映像檔|
|docker-compose down | 將運行中的容器關閉|