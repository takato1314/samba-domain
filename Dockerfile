FROM ubuntu:18.04

LABEL originalauthor="Fmstrat <fmstrat@NOSPAM.NO>"
LABEL maintainer="Tina Burschka <tina@ideaplexus.com>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get upgrade -y \
    # Install all required packages \
    && apt-get install -y pkg-config attr acl samba smbclient ldap-utils winbind libnss-winbind libpam-winbind krb5-user krb5-kdc supervisor \
    # line below is for multi-site config (ping is for testing later) \
    && apt-get install -y openvpn inetutils-ping \
    # line below is for ntp support
    && apt-get install -y ntp \
    # openssl is to make sure recent version of openssl that supports subject alt names command line option is available (openssl 1.1.1)
    && apt-get install -y openssl \
    # nano ist for "samba-tool user edit", vi is default but --editor=nano works
    && apt-get install -y nano \
    # Set up script \
    && chmod 755 /init.sh \
    # cleanup \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    && rm -fr /tmp/* /var/tmp/*

COPY init.sh /init.sh

ENTRYPOINT [ "/init.sh" ]

CMD [ "setup" ]

EXPOSE 53 53/udp 88 88/udp 135 137-138/udp 139 389 389/udp 445 464 464/udp 636 1024-1044 3268-3269 49152-65535