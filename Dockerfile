FROM buildpack-deps:buster-curl

ARG VERSION=0.1.24

ENV VLANG_VERSION $VERSION
ENV VLANG_SRC_URL https://github.com/vlang/v/archive/${VERSION}.zip
ENV VLANG_SRC_SHA256 5a67cae09aa9433d58a8f2a0668495d522196a66254a3fa0a29c17905c605cf0
ENV VLANG_URL https://github.com/vlang/v/releases/download/${VERSION}/v_linux.zip
ENV VLANG_SHA256 b8dff67f872562ec6ffd9031e3f540e1c06b3e63acd1e1f1032e3dbac94323dd

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      gcc clang make git \
      unzip \
      libssl-dev libx11-dev libglfw3-dev libsqlite3-dev libfreetype6-dev \
    && apt-get clean && rm -rf /var/cache/apt/archives/* \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN wget -O src.zip "$VLANG_SRC_URL" \
    && echo "$VLANG_SRC_SHA256 src.zip" | sha256sum -c \
    && unzip src.zip \
    && rm src.zip \
    && mv v-${VLANG_VERSION} vlang \
    && wget -O v.zip "$VLANG_URL" \
    && echo "$VLANG_SHA256 v.zip" | sha256sum -c \
    && unzip -o v.zip -d vlang \
    && rm v.zip \
    && ln -s /opt/vlang/v /usr/local/bin/v \
    # The v0.1.24 vlib/net/http/http_test.v is broken (invalid URL in redirect, hang with no error)
    && mv /opt/vlang/vlib/net/http/http_test.v /opt/vlang/vlib/net/http/http_test.v.broken \
    && v test-compiler

WORKDIR /opt/vlang
CMD [ "bash" ]
