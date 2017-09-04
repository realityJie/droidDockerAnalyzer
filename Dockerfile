FROM python:2.7.13-stretch
ENV LANG=en_US.UTF-8
# java8 start
RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV JAVA_VERSION 8u141
ENV JAVA_DEBIAN_VERSION 8u141-b15-1~deb9u1
ENV CA_CERTIFICATES_JAVA_VERSION 20170531+nmu1

RUN set -x \
	&& apt-get update \
	&& apt-get install -y \
		openjdk-8-jdk-headless="$JAVA_DEBIAN_VERSION" \
		ca-certificates-java="$CA_CERTIFICATES_JAVA_VERSION" \
	&& rm -rf /var/lib/apt/lists/* \
	&& [ "$JAVA_HOME" = "$(docker-java-home)" ]

# java8 end
# android start
ENV ANDROID_TOOLS_VERSION 3859397
ENV ANDROID_SDK_HOME /opt/android-sdk
ENV ANDROID_SDK_BUILD_TOOLS_VERSION 26.0.1
ENV ANDROID_SDK_PLATFORM_VERSION 26

RUN set -ex \
	&& apt-get update && apt-get install -y --no-install-recommends \
		bzip2 \
		unzip \
		xz-utils \
	&& rm -rf /var/lib/apt/lists/* \
    && wget -O android-tools.zip "https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_TOOLS_VERSION}.zip" \
	&& unzip -qq android-tools.zip -d ${ANDROID_SDK_HOME}/ \
	&& rm android-tools.zip \
	&& yes | ${ANDROID_SDK_HOME}/tools/bin/sdkmanager --licenses \
	&& ${ANDROID_SDK_HOME}/tools/bin/sdkmanager "build-tools;${ANDROID_SDK_BUILD_TOOLS_VERSION}" "platforms;android-${ANDROID_SDK_PLATFORM_VERSION}" "platform-tools"

ENV PATH $PATH:${ANDROID_SDK_HOME}/platform-tools:${ANDROID_SDK_HOME}/build-tools/${ANDROID_SDK_BUILD_TOOLS_VERSION}
# android end
# apktool start
ENV ANDROID_APKTOOL_VERSION 2.2.5-3883e9-SNAPSHOT
ENV ANDROID_APKTOOL_PATH /opt/android-tools/apktool.jar
COPY apktool.jar $ANDROID_APKTOOL_PATH
# apktool end

CMD ["/bin/bash"]
