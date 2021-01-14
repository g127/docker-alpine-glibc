FROM alpine:3.12.3

ENV LANG=C.UTF-8

# Here we install GNU libc (aka glibc) and set C.UTF-8 locale as default.
# Download and install glibc
RUN echo -e ' ===> Runing scripts in alpine' `cat /etc/alpine-release` \
    # install GLIBC 
    &&  { \
            GLIBC_VERSION=2.32-r0 ; \
            wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub ; \
            wget -O glibc.apk     https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk ; \
            wget -O glibc-bin.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk ; \
            wget -O glibc-i18n.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}.apk ; \
            apk add --no-cache glibc.apk glibc-bin.apk glibc-i18n.apk ; \
            /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib  ; \
            /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true ; \
            apk del glibc-i18n ; \
            echo "export LANG=$LANG" > /etc/profile.d/locale.sh ; \
            echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf ; \
            rm -rf glibc.apk glibc-bin.apk glibc-i18n.apk /var/cache/apk/* ; \
        } \
    && echo -e ' ===> Runing scripts finish' \
#
# docker rmi $(docker images | grep "none" | awk '{print $3}')
# docker build -t g127/alpine-glibc:3.12.3 .
# docker push g127/alpine-glibc:3.12.3