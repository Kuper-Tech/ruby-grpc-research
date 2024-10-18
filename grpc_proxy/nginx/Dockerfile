FROM nginx:1.27.2

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    apt-get -y update && \
    apt-get install -y  \
        openssh-client \
        git \
        wget \
        libxml2 \
        libxslt1-dev \
        libpcre3 \
        libpcre3-dev \
        zlib1g \
        zlib1g-dev \
        openssl \
        libssl-dev \
        libtool \
        automake \
        gcc \
        make

WORKDIR /app

RUN wget "http://nginx.org/download/nginx-1.27.2.tar.gz" && \
    tar -xzvf nginx-1.27.2.tar.gz && \
    rm nginx-1.27.2.tar.gz

RUN git clone --single-branch --branch main --depth=1 https://github.com/RekGRpth/ngx_http_upstream_queue_module.git

WORKDIR /app/nginx-1.27.2
RUN ./configure --with-compat --add-dynamic-module=../ngx_http_upstream_queue_module && \
    make modules
RUN cp objs/ngx_http_upstream_queue_module.so /etc/nginx/modules/

WORKDIR /app
