<div align="center"><img src="readme/images/logo.png" style="width: 300px;" /></div>
<h1 align="center" style="margin: 30px 0 30px; font-weight: bold;">Cat2Bug-Platform v0.5.1</h1>
<h4 align="center">輕量化智慧BUG管理平台</h4>

## 平台簡介

Cat2Bug-Platform是一套永久免費開源的Bug管理平台，可以完全私有化部署，它利用目前比較流行的AI大資料模型技術作為輔助，快速提升軟體管理的品質，我們將毫無保留給個人及團體免費使用。
它的使用人群鎖定個人或中小型軟體開發團隊，Cat2Bug的理念是免去了專案管理中各種重度管理，讓個人或團隊可以快速上手，把控軟體品質。
平台採用JAVA+VUE前後台分離模式開發，支援在各系統平台部署使用。

## 內建功能

1.  儀表板：統計缺陷、成員、計劃資訊。
2.  團隊管理：管理團隊中的專案、成員。
3.  專案管理：管理專案中的缺陷、成員。
4.  用例管理：管理測試用例
5.  缺陷管理：管理BUG、需求、任務。
6.  交付物管理：維護專案中的可交付物品。
7.  報告管理：顯示團隊、專案、測試用例、缺陷、交付物等的相關資料指標。
8.  API管理：用於管理API介面金鑰
9.  文件管理：留備專案中所用到的各種文件
10.  通知管理：發送系統業務通知到系統內部、電子郵件、釘釘等平台中。

## 最新版本更新說明

當前最新版本是0.5.1

* 新增儀表板;
* 在測試用例中新增按級別查詢功能;
* 在測試計劃中新增取消通過功能;
* 在admin帳戶中新增權限管理;
* 修復系統功能BUG;

## 特色

* 開源私有化AI+BUG系統部署;
* 透過AI技術自動產生測試用例並錄入到系統，解決費時費力錄入用例的痛點;
* 以測試平台為生態中心，衍生多種缺陷監控測試框架，可以一站式解決軟體生產維運中的諸多痛點；
* 自主研發報告範本，可輕鬆、快速、動態的產生專案所需管理及交付文件，較免管理人員編寫文件的時間成本;
* 專注於軟體的缺陷的追蹤管理，簡單直接，即開即用，減少學習成本；

## 線上體驗

- 體驗帳號：demo
- 體驗密碼：123456

演示地址：[https://www.cat2bug.com:8022](https://www.cat2bug.com:8022)

## 關聯產品

| 名稱                                                       | 類型       | 說明                                                                |
|----------------------------------------------------------|----------|:------------------------------------------------------------------|
| [Cat2Bug-JUnit](https://gitee.com/cat2bug/cat2bug-junit) | 單元測試框架   | 自動化單元測試框架，目前可以自動掃描Controller介面，隨機提供參數測試，並將測試報告提交到Cat2Bug-Platform |
| [Cat2Bug-JLog](https://gitee.com/cat2bug/cat2bug-jlog)   | 錯誤日誌採集框架 | 取得專案中的異常日誌，並將日誌報告提交到Cat2Bug-Platform                              |

## 系統架構

![系統架構](readme/images/cat2bug-platform-framework.png)

## 技術選型

1. 系統環境

* Java EE 11
* Servlet 3.0
* Apache Maven 3

2. 主框架

* Spring Boot 2.2.x
* Spring Framework 5.2.x
* Spring Security 5.2.x

3. 持久層

* Apache MyBatis 3.5.x
* Hibernate Validation 6.0.x
* Alibaba Druid 1.2.x

4. 視圖層

* Vue 2.6.x
* Axios 0.21.x
* Element 2.15.x

## 模組

````
--cat2bug-platform
------|----cat2bug-platform-admin       # 主程式模組
------|----cat2bug-platform-ai          # 人工智慧模組
------|----cat2bug-platform-im          # 通訊模組
------|----cat2bug-platform-api         # Open API模組
------|----cat2bug-platform-common      # 通用模組
------|----cat2bug-platform-framework   # 系統框架
------|----cat2bug-platform-generator   # 程式碼產生
------|----cat2bug-platform-quartz      # 定時任務
------|----cat2bug-platform-system      # 業務模組
------|----cat2bug-platform-ui          # 前端VUE工程
------|----sql                          # 資料庫檔案
------|----readme                       # 文件
````

## 部署

### 手動命令列部署

手動部署需要提前安裝Java 11環境，並下載cat2bug-platform發行版程式，執行命令如下：

```shell
nohup java -jar cat2bug-platform-0.5.1.jar>/dev/null 2>&1 &
```

### Docker單容器部署

以下提供的是Docker官網容器化的部署方案，執行命令如下：

```docker
docker run -it -d -p 8022:8022 --name cat2bug-platform qyzw-docker.pkg.coding.net/cat2bug/cat2bug-platform/single:latest
```

部署成功後，開啟瀏覽器造訪[http://127.0.0.1:8022](http://127.0.0.1:8022),在登入頁面自行註冊帳號登入使用即可。

注意：系統管理員帳號：admin    密碼：cat2bug，此帳號用於管理註冊使用者。

此部署方式為單容器最精簡方式部署，資料庫預設採用嵌入式H2，多用於小型或臨時性專案的缺陷管理，如需Mysql或多容器部署方案，請查看[官網文件](https://www.cat2bug.com/download/cat2bug-platform/#%E9%83%A8%E7%BD%B2)。

### Docker Compose 部署

本專案已提供完整的 Docker Compose 部署方案，支援開發和生產環境：

```bash
# 開發環境
docker-compose up -d

# 生產環境
docker-compose -f docker-compose.prod.yml up -d
```

詳細部署說明請參考 [DOCKER_DEPLOYMENT.md](DOCKER_DEPLOYMENT.md)

## 演示圖

<table>
    <tr>
        <td><img src="readme/images/1.png"></td>
        <td><img src="readme/images/2.png"></td>
    </tr>
    <tr>
        <td><img src="readme/images/3.png"></td>
        <td><img src="readme/images/4.png"></td>
    </tr>
    <tr>
        <td><img src="readme/images/5.png"></td>
        <td><img src="readme/images/6.png"></td>
    </tr>
    <tr>
        <td><img src="readme/images/7.png"></td>
        <td><img src="readme/images/8.png"></td>
    </tr>
</table>

## 未來計劃

目前Cat2Bug還在持續成長中，後續我們將在測試工具、自動化、AI幾個方向持續投入，完善平台的功能。2025計劃如下：

* cat2bug-platform: 功能疊加，完善系統統計管理功能；
* cat2bug-app：提供行動端APP；
* cat2bug-cloud：cat2bug雲平台的建設；

## Cat2Bug交流群

| QQ群： [731462000](https://qm.qq.com/cgi-bin/qm/qr?k=G_vJa478flcFo_1ohJxNYD0mRKafQ7I1&jump_from=webapi&authKey=EL0KrLpnjYWqNN9YXTVksNlNFrV9DHYyPMx2RVOhXqLzfnmc+Oz8oQ38aBOGx90t) | 微信群：Cat2Bug                                                                 |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------|
| <img src="./readme/images/qq.png" style="width: 150px; height: 150px;">                                                                                                        | <img src="./readme/images/wechat.png" style="width: 150px; height: 150px;"> |
