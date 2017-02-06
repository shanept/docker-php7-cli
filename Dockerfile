FROM centos:7
LABEL maintainer="shanept@iinet.net.au"

ENV TERM xterm

# Install extra repos
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

# Import webtatic keys
RUN curl -LO https://mirror.webtatic.com/yum/RPM-GPG-KEY-webtatic-el7
RUN rpm --import RPM-GPG-KEY-webtatic-el7; rm RPM-GPG-KEY-webtatic-el7

RUN yum update -y

# Install packages
RUN yum install -y unzip git gcc make openssl ca-certificates php70w php70w-xml php70w-gd php70w-mbstring \
                   php70w-mysqli php70w-devel php70w-phpdbg libssh2-devel

# Install SSH2
RUN curl -LO https://github.com/Sean-Der/pecl-networking-ssh2/archive/php7.zip
RUN unzip php7.zip && rm php7.zip && cd pecl-networking-ssh2-php7/ && \
    phpize && ./configure && make && make install
RUN rm -Rf /pecl-networking-ssh2
RUN echo -e "; Enable ssh2 extension module\nextension=ssh2.so" > /etc/php.d/ssh2.ini

# Install Composer
RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer

# Run entrypoint
CMD ["/sbin/init"]
