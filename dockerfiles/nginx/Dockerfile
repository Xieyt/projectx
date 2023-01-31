FROM openresty/openresty:1.21.4.1-4-buster@sha256:9be444a283344aec2d499682c7ab9d342d06245632c8e71a0c1c37d19d11b436

# Copy EasyEngine nginx configuration files
RUN mkdir -p /var/log/nginx; \
    mkdir -p /usr/local/openresty/nginx/conf/conf.d

COPY conf /usr/local/openresty/nginx/conf
# EXPOSE 80

CMD ["/usr/bin/openresty","-g","daemon off;"]
