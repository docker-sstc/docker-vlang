FROM buildpack-deps:buster-curl

ARG VERSION=0.2.2

ENV VLANG_VERSION $VERSION
ENV VLANG_SRC_URL https://github.com/vlang/v/archive/${VERSION}.zip
ENV VLANG_SRC_SHA256 17b6e5391a2e362f18ace0a27092a655826d1c1408c40cd1f7329f9b8f08f379
ENV VLANG_URL https://github.com/vlang/v/releases/download/${VERSION}/v_linux.zip
ENV VLANG_SHA256 d791102173b35f8af1446b7a6207b326dc8d3ddf3f43f433979616550e85d56d

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
	# We need source, otherwise some test cases won't pass (module "compiler" (not found), failed to open file "/opt/vlang/vlib/v/gen/tests/1.vv")
	wget -O src.zip "$VLANG_SRC_URL"; \
	echo "$VLANG_SRC_SHA256 src.zip" | sha256sum -c; \
	unzip src.zip; \
	mv v-${VLANG_VERSION} vlang; \
	rm src.zip; \
	wget -O v.zip "$VLANG_URL"; \
	echo "$VLANG_SHA256 v.zip" | sha256sum -c; \
	unzip -o v.zip -d vlang; \
	rm v.zip; \
	ln -s /opt/vlang/v /usr/local/bin/v; \
	v test-self

WORKDIR /root
CMD ["bash"]
