#!/bin/sh

# 使用环境变量替换配置文件中的变量
envsubst '${SUPABASE_PROJECT_ID} ${SERVER_NAME}' < /etc/nginx/conf.d/nginx.conf.template > /etc/nginx/conf.d/supabase.conf

# 启动 Nginx
nginx -g 'daemon off;'