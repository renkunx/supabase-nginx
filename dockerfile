# 使用官方 Nginx 镜像作为基础镜像
FROM nginx:latest

# 安装 envsubst 工具
RUN apt-get update && apt-get install -y gettext-base && rm -rf /var/lib/apt/lists/*

# 删除默认的 Nginx 配置
RUN rm /etc/nginx/conf.d/default.conf

# 将配置模板复制到镜像中
COPY nginx.conf.template /etc/nginx/conf.d/

# 创建启动脚本
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

# 设置默认的 Supabase 项目 ID
ENV SUPABASE_PROJECT_ID=eerrrudelimaalmqyzhj

# 设置默认的服务器名称
ENV SERVER_NAME=localhost

# 暴露 80 端口
EXPOSE 80

# 使用启动脚本替换环境变量并启动 Nginx
ENTRYPOINT ["/docker-entrypoint.sh"]