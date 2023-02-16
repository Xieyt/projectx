FROM php:7.3-fpm@sha256:a810876c96407cbbddef949379d2057f4f85d5c1d892dcf2c8d9503239549990
ARG SET_XDEBUG_VERSION
ARG SET_HOST_UID
ARG SET_HOST_GID

ARG BUILDARCH

# Setting uid and gid same as host user
# not running this on arm64
RUN if [ "$BUILDARCH" = "arm64" ]; then usermod --uid "$SET_HOST_UID" www-data ; fi
RUN if [ "$BUILDARCH" = "arm64" ]; then groupmod --gid "$SET_HOST_GID" www-data ; fi

RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		imagemagick \
		less \
		mariadb-client msmtp \
		libc-client-dev \
		libfreetype6-dev \
		libjpeg-dev \
		libjpeg62-turbo-dev \
		libkrb5-dev \
		libmagickwand-dev \
		libgraphicsmagick1-dev \
		libmcrypt-dev \
		libmemcached-dev \
		libxml2-dev \
		libpng-dev \
		libzip-dev \
		libssl-dev \
		libgmp-dev \
		libicu-dev \
		unzip \
		vim \
		zip

# Install mhsendmail on amd64
RUN     curl https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 -o /usr/bin/mhsendmail; \
        chmod 777 /usr/bin/mhsendmail

RUN pecl install imagick; \
	pecl install memcached; \
	pecl install mcrypt; \
	pecl install redis; \
    pecl install apcu; \
    pecl install gmagick-2.0.6RC1; \
    pecl install timezonedb; \
	pecl install xdebug-$SET_XDEBUG_VERSION; \
	docker-php-ext-configure gd --with-freetype-dir=/usr/include/freetype2 --with-png-dir=/usr/include --with-jpeg-dir=/usr/include; \
	docker-php-ext-configure zip; \
	docker-php-ext-install gd; \
	PHP_OPENSSL=yes docker-php-ext-configure imap --with-kerberos --with-imap-ssl; \
	docker-php-ext-install imap; \
	docker-php-ext-install mysqli; \
	docker-php-ext-install pdo_mysql; \
	docker-php-ext-install opcache; \
	docker-php-ext-install soap; \
	docker-php-ext-install intl; \
	docker-php-ext-install zip; \
	docker-php-ext-install exif; \
    docker-php-ext-install calendar; \
    docker-php-ext-install gmp; \
    docker-php-ext-install pcntl; \
    docker-php-ext-install shmop; \
    docker-php-ext-install sockets; \
    docker-php-ext-install sysvsem; \
    docker-php-ext-install sysvshm; \
	docker-php-ext-install bcmath; \
    docker-php-ext-enable xdebug; \
	docker-php-ext-enable imagick mcrypt redis timezonedb apcu; \
	echo "extension=memcached.so" >> /usr/local/etc/php/conf.d/memcached.ini; \
	echo "extension=gmagick.so" >> /usr/local/etc/php/conf.d/gmagick.ini; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*;

# Turn off Xdebug
RUN rm /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=2'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# Donwload and install composer
RUN curl -sSL "https://getcomposer.org/installer" | php \
		&& mv composer.phar /usr/local/bin/composer

# Install nvm, node
RUN export XDG_CONFIG_HOME="/opt" \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash; \
    \. /root/.bashrc; \
    nvm install node \
    && chown -R $SET_HOST_UID:$SET_HOST_GID /opt/nvm

# Setup a config file
RUN mkdir -p /etc/wp-cli
RUN { \
		echo 'path: /var/www/htdocs'; \
		} > /etc/wp-cli/config.yml

RUN mkdir -p /var/www/.wp-cli \
    && chown -R $SET_HOST_UID:$SET_HOST_GID /var/www/.wp-cli


# Setup logs
RUN mkdir -p /var/log/php; \
	chown -R $SET_HOST_UID:$SET_HOST_GID /var/log/php; \
	rm /usr/local/etc/php-fpm.d/*;
COPY php.ini /usr/local/etc/php/php.ini
COPY easyengine.conf /usr/local/etc/php-fpm.d/easyengine.conf

COPY expose_off.ini /usr/local/etc/php/conf.d/expose_off.ini
COPY bashrc /root/.bashrc
COPY bashrc /var/www/.bashrc

WORKDIR /var/www/htdocs
USER www-data

CMD ["php-fpm"]
