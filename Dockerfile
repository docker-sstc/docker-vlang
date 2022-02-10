FROM buildpack-deps:buster-curl

ARG VERSION=0.2.4

ENV VLANG_VERSION $VERSION
ENV VLANG_SRC_URL https://github.com/vlang/v/archive/${VERSION}.zip
ENV VLANG_URL https://github.com/vlang/v/releases/download/${VERSION}/v_linux.zip

RUN set -ex; \
	apt-get update; \
	DEBIAN_FRONTEND=noninteractive \
	apt-get install -y --no-install-recommends \
	gcc clang make git \
	unzip \
	libssl-dev libx11-dev libglfw3-dev libsqlite3-dev libfreetype6-dev \
	; \
	rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN set -ex; \
	wget -O v.zip "$VLANG_URL"; \
	unzip -o v.zip -d vlang; \
	rm v.zip; \
	ln -s /opt/vlang/v/v /usr/local/bin/v; \
	v test-self

WORKDIR /root
CMD ["bash"]
