# 多階段構建 Dockerfile for Cat2Bug-Platform
# 第一階段：構建前端 Vue.js 應用
FROM node:16-alpine AS frontend-builder

# 設定工作目錄
WORKDIR /app/frontend

# 複製前端 package.json 和 package-lock.json
COPY cat2bug-platform-ui/package*.json ./

# 安裝前端依賴
RUN npm install

# 複製前端原始碼
COPY cat2bug-platform-ui/ ./

# 構建前端應用
RUN npm run build:prod

# 第二階段：構建後端 Spring Boot 應用
FROM maven:3.8.6-openjdk-8-slim AS backend-builder

# 設定工作目錄
WORKDIR /app/backend

# 複製 Maven 設定檔
COPY pom.xml ./
COPY cat2bug-platform-admin/pom.xml ./cat2bug-platform-admin/
COPY cat2bug-platform-api/pom.xml ./cat2bug-platform-api/
COPY cat2bug-platform-common/pom.xml ./cat2bug-platform-common/
COPY cat2bug-platform-framework/pom.xml ./cat2bug-platform-framework/
COPY cat2bug-platform-generator/pom.xml ./cat2bug-platform-generator/
COPY cat2bug-platform-im/pom.xml ./cat2bug-platform-im/
COPY cat2bug-platform-quartz/pom.xml ./cat2bug-platform-quartz/
COPY cat2bug-platform-system/pom.xml ./cat2bug-platform-system/
COPY cat2bug-platform-ai/pom.xml ./cat2bug-platform-ai/

# 複製所有原始碼
COPY . .

# 構建後端應用
RUN mvn clean package -DskipTests -pl cat2bug-platform-admin -am

# 第三階段：運行階段
FROM openjdk:8-jre-alpine

# 安裝必要的工具
RUN apk add --no-cache \
    curl \
    tzdata \
    && rm -rf /var/cache/apk/*

# 設定時區
ENV TZ=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 建立應用目錄
WORKDIR /app

# 建立非 root 使用者
RUN addgroup -g 1000 appgroup && \
    adduser -u 1000 -G appgroup -s /bin/sh -D appuser

# 從構建階段複製 JAR 檔案（注意 backend 工作目錄為 /app/backend）
COPY --from=backend-builder /app/backend/cat2bug-platform-admin/target/cat2bug-admin.jar app.jar

# 從前端構建階段複製靜態檔案到後端資源目錄
# 注意：前端構建輸出目錄由 vue.config.js 設為 ../cat2bug-platform-admin/src/main/resources/static
COPY --from=frontend-builder /app/cat2bug-platform-admin/src/main/resources/static ./src/main/resources/static/

# 建立上傳目錄
RUN mkdir -p uploadPath uploadTemp logs && \
    chown -R appuser:appgroup /app

# 切換到非 root 使用者
USER appuser

# 暴露端口
EXPOSE 8080

# 健康檢查
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/actuator/health || exit 1

# 設定 JVM 參數
ENV JAVA_OPTS="-Xms512m -Xmx1024m -Djava.security.egd=file:/dev/./urandom"

# 啟動應用
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
