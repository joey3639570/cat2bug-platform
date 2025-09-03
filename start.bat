@echo off
chcp 65001 >nul

echo 🐱 歡迎使用 Cat2Bug-Platform Docker 部署腳本
echo ================================================

REM 檢查 Docker 是否安裝
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker 未安裝，請先安裝 Docker
    pause
    exit /b 1
)

REM 檢查 Docker Compose 是否安裝
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker Compose 未安裝，請先安裝 Docker Compose
    pause
    exit /b 1
)

REM 檢查環境變數檔案
if not exist ".env" (
    echo 📝 建立環境變數檔案...
    copy env.example .env >nul
    echo ✅ 已建立 .env 檔案，請檢查並修改密碼設定
)

echo.
echo 請選擇部署模式：
echo 1) 開發環境 (docker-compose.yml)
echo 2) 生產環境 (docker-compose.prod.yml)
set /p choice="請輸入選項 (1 或 2): "

if "%choice%"=="1" (
    echo 🚀 啟動開發環境...
    docker-compose down
    docker-compose up -d --build
) else if "%choice%"=="2" (
    echo 🚀 啟動生產環境...
    docker-compose -f docker-compose.prod.yml down
    docker-compose -f docker-compose.prod.yml up -d --build
) else (
    echo ❌ 無效選項，請重新執行腳本
    pause
    exit /b 1
)

echo.
echo ⏳ 等待服務啟動...
timeout /t 10 /nobreak >nul

echo.
echo 📊 服務狀態：
if "%choice%"=="1" (
    docker-compose ps
) else (
    docker-compose -f docker-compose.prod.yml ps
)

echo.
echo 🎉 部署完成！
echo.
echo 📱 應用訪問地址：
if "%choice%"=="1" (
    echo    開發環境: http://localhost:8080
) else (
    echo    生產環境: http://localhost (通過 Nginx)
    echo    直接訪問: http://localhost:8080
)
echo.
echo 🔧 管理指令：
if "%choice%"=="1" (
    echo    查看日誌: docker-compose logs -f
    echo    停止服務: docker-compose down
) else (
    echo    查看日誌: docker-compose -f docker-compose.prod.yml logs -f
    echo    停止服務: docker-compose -f docker-compose.prod.yml down
)
echo.
echo 📚 詳細說明請參考 DOCKER_DEPLOYMENT.md
pause
