FROM php:5.6-fpm
ARG SET_XDEBUG_VERSION
ARG SET_HOST_UID
ARG SET_HOST_GID
ARG BUILDARCH

# Setting uid and gid same as host user
# not running this on arm64
RUN if [ "$BUILDARCH" != "arm64" ]; then usermod --uid "$SET_HOST_UID" www-data ; fi
RUN if [ "$BUILDARCH" != "arm64" ]; then groupmod --gid "$SET_HOST_GID" www-data ; fi

RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		imagemagick \
		less \
		libc-client-dev \
		libfreetype6-dev \
		libjpeg-dev \
		libjpeg62-turbo-dev \
		libkrb5-dev \
		libmagickwand-dev \
		libmcrypt-dev \
		libmemcached-dev \
		libxml2-dev \
		libpng-dev \
		libzip-dev \
		mysql-client \
		ssmtp \
		unzip \
		vim \
		zip

# Install mhsendmail on amd64
RUN     curl https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 -o /usr/bin/mhsendmail; \
        chmod 777 /usr/bin/mhsendmail

RUN pecl install imagick memcached-2.2.0; \
	printf "\n" | pecl install mcrypt-1.0.1; \
	printf "\n" | pecl install redis; \
	printf "\n" | pecl install xdebug-$SET_XDEBUG_VERSION; \
	docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
	docker-php-ext-configure zip --with-libzip; \
	docker-php-ext-configure --with-php-config=/usr/local/bin/php-config; \
	docker-php-ext-configure imap --with-kerberos --with-imap-ssl; \
	docker-php-ext-install gd imap mysqli opcache soap zip; \
    docker-php-ext-enable xdebug; \
	docker-php-ext-enable imagick mcrypt redis; \
	echo "extension=memcached.so" >> /usr/local/etc/php/conf.d/memcached.ini; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    apt-get clean; \
	rm -rf /var/lib/apt/lists/*;

# Turn off Xdebug
RUN rm /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# RUN	mkdir -p /usr/src/php/ext; \
# 	cd /usr/src/php/ext/; \
# 	curl -sSL -o php7.zip https://github.com/websupport-sk/pecl-memcache/archive/NON_BLOCKING_IO_php7.zip; \
# 	unzip php7.zip; \
# 	mv pecl-memcache-NON_BLOCKING_IO_php7 memcache; \
# 	rm -rf /tmp/pecl-memcache-php7 /usr/src/php/ext/php7.zip; \
# 	docker-php-ext-configure memcache --with-php-config=/usr/local/bin/php-config; \
#   docker-php-ext-install memcache;

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

# Install wp-cli
RUN curl -O "https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar" \
		&& chmod +x wp-cli.phar \
		&& mv wp-cli.phar /usr/local/bin/wp

# Install nvm, node

RUN export XDG_CONFIG_HOME="/opt" \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash; \
    \. /root/.bashrc; \
    nvm install node \
    && if [ "$BUILDARCH" != "arm64" ]; then chown -R $SET_HOST_UID:$SET_HOST_GID /opt/nvm ; else chown -R www-data:www-data /opt/nvm ; fi

# Setup a config file
RUN mkdir -p /etc/wp-cli
RUN { \
		echo 'path: /var/www/htdocs'; \
		} > /etc/wp-cli/config.yml

RUN mkdir -p /var/www/.wp-cli \
    && if [ "$BUILDARCH" != "arm64" ]; then chown -R $SET_HOST_UID:$SET_HOST_GID /var/www/.wp-cli ; else chown -R www-data:www-data /var/www/.wp-cli ; fi


# Setup logs
RUN mkdir -p /var/log/php; \
    if [ "$BUILDARCH" != "arm64" ]; then chown -R $SET_HOST_UID:$SET_HOST_GID /var/log/php ; else chown -R www-data:www-data /var/log/php ; fi ;\
	rm /usr/local/etc/php-fpm.d/*;
COPY php.ini /usr/local/etc/php/php.ini
COPY easyengine.conf /usr/local/etc/php-fpm.d/easyengine.conf

COPY expose_off.ini /usr/local/etc/php/conf.d/expose_off.ini
COPY bashrc /root/.bashrc
COPY bashrc /var/www/.bashrc

WORKDIR /var/www/htdocs
USER www-data

CMD ["php-fpm"]

