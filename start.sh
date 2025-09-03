#!/bin/bash

# Cat2Bug-Platform 啟動腳本

set -e

echo "🐱 歡迎使用 Cat2Bug-Platform Docker 部署腳本"
echo "================================================"

# 檢查 Docker 是否安裝
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安裝，請先安裝 Docker"
    exit 1
fi

# 檢查 Docker Compose 是否安裝
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose 未安裝，請先安裝 Docker Compose"
    exit 1
fi

# 檢查環境變數檔案
if [ ! -f ".env" ]; then
    echo "📝 建立環境變數檔案..."
    cp env.example .env
    echo "✅ 已建立 .env 檔案，請檢查並修改密碼設定"
fi

# 選擇部署模式
echo ""
echo "請選擇部署模式："
echo "1) 開發環境 (docker-compose.yml)"
echo "2) 生產環境 (docker-compose.prod.yml)"
read -p "請輸入選項 (1 或 2): " choice

case $choice in
    1)
        echo "🚀 啟動開發環境..."
        docker-compose down
        docker-compose up -d --build
        ;;
    2)
        echo "🚀 啟動生產環境..."
        docker-compose -f docker-compose.prod.yml down
        docker-compose -f docker-compose.prod.yml up -d --build
        ;;
    *)
        echo "❌ 無效選項，請重新執行腳本"
        exit 1
        ;;
esac

echo ""
echo "⏳ 等待服務啟動..."
sleep 10

# 檢查服務狀態
echo ""
echo "📊 服務狀態："
if [ "$choice" = "1" ]; then
    docker-compose ps
else
    docker-compose -f docker-compose.prod.yml ps
fi

echo ""
echo "🎉 部署完成！"
echo ""
echo "📱 應用訪問地址："
if [ "$choice" = "1" ]; then
    echo "   開發環境: http://localhost:8080"
else
    echo "   生產環境: http://localhost (通過 Nginx)"
    echo "   直接訪問: http://localhost:8080"
fi
echo ""
echo "🔧 管理指令："
if [ "$choice" = "1" ]; then
    echo "   查看日誌: docker-compose logs -f"
    echo "   停止服務: docker-compose down"
else
    echo "   查看日誌: docker-compose -f docker-compose.prod.yml logs -f"
    echo "   停止服務: docker-compose -f docker-compose.prod.yml down"
fi
echo ""
echo "📚 詳細說明請參考 DOCKER_DEPLOYMENT.md"
