FROM php:8.0-fpm@sha256:3ba0dec3b6c73f9948c0d3215da03e9341526356789ad75debe4848c485cf3cd

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
		libicu-dev \
		libmemcached-dev \
		libxml2-dev \
		libpng-dev \
		libzip-dev \
		libssl-dev \
		libgmp-dev \
		unzip \
		vim \
		zip

# Install mhsendmail on amd64
RUN	apt-get install -y --no-install-recommends \
        wget; \
        wget https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 -O /usr/bin/mhsendmail; \
        chmod 777 /usr/bin/mhsendmail

RUN pecl install imagick; \
	pecl install memcached; \
	pecl install redis; \
	pecl install apcu; \
	pecl install mcrypt; \
	pecl install gmagick-2.0.6RC1; \
	pecl install timezonedb; \
	pecl install xedebug-3.2.0; \
	docker-php-ext-configure gd --with-freetype --with-jpeg; \
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
	docker-php-ext-enable imagick mcrypt redis timezonedb apcu; \
	echo "extension=memcached.so" >> /usr/local/etc/php/conf.d/memcached.ini; \
	echo "extension=gmagick.so" >> /usr/local/etc/php/conf.d/gmagick.ini; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*;

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

# Setup a config file
RUN mkdir -p /etc/wp-cli
RUN { \
		echo 'path: /var/www/htdocs'; \
		} > /etc/wp-cli/config.yml


# Setup logs
RUN mkdir -p /var/log/php; \
	chown -R www-data: /var/log/php; \
	rm /usr/local/etc/php-fpm.d/*;
COPY php.ini /usr/local/etc/php/php.ini
COPY easyengine.conf /usr/local/etc/php-fpm.d/easyengine.conf

COPY expose_off.ini /usr/local/etc/php/conf.d/expose_off.ini
COPY bashrc /root/.bashrc
COPY bashrc /var/www/.bashrc

WORKDIR /var/www/htdocs
USER www-data

CMD ["php-fpm"]
