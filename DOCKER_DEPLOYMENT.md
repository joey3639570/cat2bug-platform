# Cat2Bug-Platform Docker 部署指南

## 📋 概述

本指南將協助您使用 Docker 和 Docker Compose 部署 Cat2Bug-Platform 專案。

## 🚀 快速開始

### 1. 環境需求

- Docker 20.10+
- Docker Compose 2.0+
- 至少 4GB RAM
- 至少 10GB 可用磁碟空間

### 2. 開發環境部署

```bash
# 1. 複製環境變數檔案
cp env.example .env

# 2. 啟動所有服務
docker-compose up -d

# 3. 查看服務狀態
docker-compose ps

# 4. 查看應用日誌
docker-compose logs -f cat2bug-app
```

### 3. 生產環境部署

```bash
# 1. 複製並編輯環境變數檔案
cp env.example .env
# 編輯 .env 檔案，設定強密碼

# 2. 啟動生產環境
docker-compose -f docker-compose.prod.yml up -d

# 3. 查看服務狀態
docker-compose -f docker-compose.prod.yml ps
```

## 🔧 配置說明

### 環境變數

| 變數名 | 說明 | 預設值 |
|--------|------|--------|
| MYSQL_ROOT_PASSWORD | MySQL root 密碼 | Cat2Bug@2025! |
| MYSQL_PASSWORD | MySQL 使用者密碼 | Cat2Bug@2025! |
| MYSQL_PORT | MySQL 端口 | 3306 |
| REDIS_PASSWORD | Redis 密碼 | Cat2Bug@2025! |
| REDIS_PORT | Redis 端口 | 6379 |
| APP_PORT | 應用端口 | 8080 |
| NGINX_PORT | Nginx 端口 | 80 |
| NGINX_SSL_PORT | Nginx SSL 端口 | 443 |

### 服務端口

| 服務 | 端口 | 說明 |
|------|------|------|
| Cat2Bug 應用 | 8080 | 主要應用服務 |
| MySQL | 3306 | 資料庫服務 |
| Redis | 6379 | 快取服務 |
| Nginx | 80/443 | 反向代理（生產環境） |

## 📁 目錄結構

```
cat2bug-platform/
├── Dockerfile                 # 應用 Docker 檔案
├── docker-compose.yml         # 開發環境配置
├── docker-compose.prod.yml    # 生產環境配置
├── .dockerignore             # Docker 忽略檔案
├── env.example               # 環境變數範例
├── nginx/                    # Nginx 配置
│   ├── nginx.conf
│   └── conf.d/
│       └── cat2bug.conf
├── mysql/                    # MySQL 配置
│   └── my.cnf
└── redis/                    # Redis 配置
    └── redis.conf
```

## 🛠️ 常用指令

### 開發環境

```bash
# 啟動服務
docker-compose up -d

# 停止服務
docker-compose down

# 重新構建並啟動
docker-compose up -d --build

# 查看日誌
docker-compose logs -f [service_name]

# 進入容器
docker-compose exec cat2bug-app sh
```

### 生產環境

```bash
# 啟動服務
docker-compose -f docker-compose.prod.yml up -d

# 停止服務
docker-compose -f docker-compose.prod.yml down

# 重新構建並啟動
docker-compose -f docker-compose.prod.yml up -d --build

# 查看日誌
docker-compose -f docker-compose.prod.yml logs -f [service_name]
```

## 🔍 故障排除

### 1. 應用無法啟動

```bash
# 檢查容器狀態
docker-compose ps

# 查看應用日誌
docker-compose logs cat2bug-app

# 檢查資料庫連接
docker-compose exec cat2bug-app curl http://localhost:8080/actuator/health
```

### 2. 資料庫連接問題

```bash
# 檢查 MySQL 容器
docker-compose exec mysql mysql -u root -p

# 檢查資料庫是否已初始化
docker-compose exec mysql mysql -u cat2bug -p cat2bug_platform -e "SHOW TABLES;"
```

### 3. 記憶體不足

```bash
# 調整 JVM 參數
# 編輯 docker-compose.yml 中的 JAVA_OPTS
JAVA_OPTS: "-Xms256m -Xmx512m"
```

## 📊 監控和維護

### 健康檢查

```bash
# 檢查應用健康狀態
curl http://localhost:8080/actuator/health

# 檢查 Nginx 健康狀態
curl http://localhost/health
```

### 備份

```bash
# 備份資料庫
docker-compose exec mysql mysqldump -u root -p cat2bug_platform > backup.sql

# 備份上傳檔案
docker cp cat2bug-app:/app/uploadPath ./backup-uploads
```

### 更新

```bash
# 拉取最新程式碼
git pull

# 重新構建並部署
docker-compose -f docker-compose.prod.yml up -d --build
```

## 🔒 安全建議

1. **修改預設密碼**：務必修改 `.env` 檔案中的預設密碼
2. **使用 HTTPS**：生產環境建議配置 SSL 憑證
3. **防火牆設定**：只開放必要端口
4. **定期更新**：保持 Docker 映像和依賴套件更新
5. **備份策略**：建立定期備份機制

## 📞 支援

如有問題，請參考：
- [Cat2Bug 官方文檔](https://www.cat2bug.com)
- [GitHub Issues](https://github.com/joey3639570/cat2bug-platform/issues)

---

**注意**：首次啟動可能需要幾分鐘時間來下載映像和初始化資料庫。
