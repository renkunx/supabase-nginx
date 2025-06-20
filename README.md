# Supabase Nginx 代理服务器

这是一个用于代理 Supabase 请求的 Nginx 服务器配置。它提供了以下功能：

## 主要功能

### 1. 静态资源缓存
- 支持缓存 jpg、jpeg、png、gif、ico、css、js 等静态文件
- 缓存配置：
  - 缓存路径：`/tmp/nginx_cache`
  - 缓存大小：10GB
  - 缓存时间：60分钟
  - 缓存键：基于请求方案、方法、主机和URI

### 2. 请求头转发
- 转发认证相关的请求头：
  - apikey
  - Authorization
  - content-type
  - Accept
- 转发安全相关的请求头：
  - Origin
  - Referer
  - Sec-Fetch-Site
  - Sec-Fetch-Mode
  - Sec-Fetch-Dest

### 3. SSL/TLS 配置
- 支持 TLSv1.2 和 TLSv1.3 协议
- 启用 SNI（服务器名称指示）
- 支持自定义 SSL 证书配置

### 4. WebSocket 支持
- 支持 Supabase Realtime 功能
- 自动升级 HTTP 连接到 WebSocket

### 5. 超时设置
- 连接超时：60秒
- 发送超时：60秒
- 读取超时：60秒

### 6. 禁用代理缓冲
- 通过设置 `proxy_buffering off`，禁用了代理缓冲，以优化对大文件的处理，并减少潜在的 502 错误。

## 使用方法

### Docker 镜像版本控制

为了更好地管理和追踪镜像的变更，我们建议使用版本号来构建和标记 Docker 镜像。这有助于在部署时选择特定版本的镜像，并方便回滚到之前的稳定版本。

**构建带版本号的镜像**

在构建镜像时，您可以使用 `-t` 参数指定镜像名称和版本标签，格式为 `repository:tag`。例如，构建 `1.0.0` 版本的镜像：

```bash
docker build -t supabase-nginx:1.0.0 .
```

您可以根据需要更改版本号，例如 `supabase-nginx:1.0.1`、`supabase-nginx:latest` 等。


1. 构建 Docker 镜像：
```bash
docker build -t supabase-nginx .
```

2. 运行容器：
```bash
# 使用默认的 Supabase 项目 ID
docker run -p 80:80 supabase-nginx

# 或者指定自己的 Supabase 项目 ID
docker run -p 80:80 \
  -e SUPABASE_PROJECT_ID=your_project_id \
  -e SERVER_NAME=your_domain.com \
  supabase-nginx:1.0.0
```

## 项目结构

```
├── README.md           # 项目说明文档
├── dockerfile          # Docker 构建文件
├── nginx.conf.template # Nginx 配置模板
├── docker-entrypoint.sh # Docker 启动脚本
└── supabase.conf      # 生成的最终配置文件
```

## 配置说明

### 环境变量
- `SUPABASE_PROJECT_ID`：您的 Supabase 项目的唯一 ID。默认值为 `eerrrudelimaalmqyzhj`。
- `SERVER_NAME`：Nginx 监听的服务器域名。默认值为 `localhost`。您可以将其设置为您的实际域名，例如 `example.com`。

### 配置文件
项目使用模板化配置管理：
1. `nginx.conf.template`: 
   - 配置模板文件
   - 使用 `${SUPABASE_PROJECT_ID}` 变量
   - 包含所有 Nginx 代理配置

2. `docker-entrypoint.sh`:
   - 容器启动脚本
   - 负责替换配置模板中的环境变量
   - 生成最终的 `supabase.conf`
   - 启动 Nginx 服务

3. `supabase.conf`:
   - 由模板生成的最终配置文件
   - 包含：
     - 静态资源缓存规则
     - 代理转发规则
     - SSL/TLS 配置
     - WebSocket 支持
     - 超时设置

## 注意事项

1. 请确保替换配置中的 Supabase 项目 URL
2. 如需启用 HTTPS，请配置相应的 SSL 证书
3. 可以根据需要调整缓存大小和超时时间