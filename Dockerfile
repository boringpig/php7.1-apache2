FROM ubuntu:16.04
MAINTAINER jeffery <jeffery@program.com.tw>

ENV DEBIAN_FRONTEND noninteractive
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 LANGUAGE=C.UTF-8
WORKDIR /var/www/html

# 更新容器版本
RUN apt-get update && \
    apt-get upgrade -y

# 安裝必要程式
RUN apt-get update && apt-get install -y curl git vim nano wget sudo apt-transport-https

# 安裝 php and mongo apt-repository
RUN apt-get install -qqy software-properties-common && \
    add-apt-repository -y ppa:ondrej/php && \
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5 && \
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list && \
    apt-get update

# 安裝 node & npm
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN apt-get install -y nodejs

# 安裝 yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn

# 安裝 apache2
RUN apt-get install -y apache2
COPY etc/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite
RUN usermod -u 1000 www-data
RUN chown -Rf www-data.www-data /var/www/html/

# 安裝 php
RUN apt-get install -y php7.1 libapache2-mod-php7.1 php7.1-cli php7.1-dev php7.1-pgsql php7.1-sqlite3 php7.1-gd \
    php-apcu php7.1-curl php7.1-mcrypt php7.1-imap php7.1-mysql php7.1-readline php-xdebug php-common \
    php7.1-mbstring php7.1-xml php7.1-zip php7.1-mongodb 

# 安裝 mongodb 的擴充指令
RUN sudo apt-get install -y mongodb-org-shell=3.6.0 mongodb-org-tools=3.6.0

# 安裝 composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    printf "\nPATH=\"~/.composer/vendor/bin:\$PATH\"\n" | tee -a ~/.bashrc
RUN composer global require hirak/prestissimo

# 安裝 supervisord
RUN apt-get install -y supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 清除暫存資料
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80 443
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]