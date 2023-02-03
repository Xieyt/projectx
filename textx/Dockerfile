FROM php:8.1-fpm@sha256:bdac671e3ca663c0e9dc7008f28b3ee8dc2cc5b2d11fcde83d2142ab0369f457

ARG SET_PHP_VERSION
RUN echo ${SET_PHP_VERSION} > /tmp/lol

#RUN set -ex; \
#   apt-get update; \
	#apt-get install -y --no-install-recommends \
  #
RUN groupmod --gid "1000" www-data
RUN usermod --uid "1000" www-data

RUN export XDG_CONFIG_HOME="/opt" \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash; \
    \. /root/.bashrc; \
    nvm install node \
    && chown -R www-data:www-data /opt/nvm




COPY bashrc /root/.bashrc
COPY bashrc /var/www/.bashrc


WORKDIR /var/www/htdocs
USER www-data

CMD ["php-fpm"]
