FROM        buildpack-deps:stretch
MAINTAINER  Jonathan Schmeling via Jiang Jia
ENV         LANG C.UTF-8
ENV         GUILE_VERSION 2.2.3
ENV         ARTANIS_VERSION 0.2.5
ENV         GUILE_DBI_VERSION 2.1.7
ENV         GUILE_DBD_MYSQL_VERSION 2.1.6
RUN     echo "deb http://mirrors.ustc.edu.cn/debian jessie main contrib non-free" >> /etc/apt/sources.list \
        && echo "deb-src http://mirrors.ustc.edu.cn/debian jessie main contrib non-free" >> /etc/apt/sources.list
RUN         apt-get update && apt-get build-dep -y --no-install-recommends \
                              guile-2.0 \
                          && rm -rf /var/lib/apt/lists/*

RUN set -ex \
        && wget -c ftp://ftp.gnu.org/gnu/guile/guile-$GUILE_VERSION.tar.gz \
        && tar xvzf guile-$GUILE_VERSION.tar.gz \
        && rm -f guile-$GUILE_VERSION.tar.gz \
        && cd guile-$GUILE_VERSION && ./configure && make \
        && make install && ldconfig \
        && curl -O -L -J https://github.com/opencog/guile-dbi/archive/guile-dbi-2.1.7.tar.gz \
        && tar xvzf guile-dbi-guile-dbi-$GUILE_DBI_VERSION.tar.gz \
        && rm -f guile-dbi-guile-dbi-$GUILE_DBI_VERSION.tar.gz \
        && cd guile-dbi-guile-dbi-$GUILE_DBI_VERSION/guile-dbi && ./autogen.sh && make \
        && make install && ldconfig \
        \
        && cd ../guile-dbd-mysql && ./autogen.sh && make \
        && make install && ldconfig \
        \
        && wget -c http://ftp.gnu.org/gnu/artanis/artanis-$ARTANIS_VERSION.tar.bz2 \
        && tar xvjf artanis-$ARTANIS_VERSION.tar.bz2 \
        && rm -f artanis-$ARTANIS_VERSION.tar.bz2 \
        && cd artanis-$ARTANIS_VERSION && ./configure && make \
        && make install && ldconfig

RUN mkdir /myapp
WORKDIR /myapp
COPY . /myapp