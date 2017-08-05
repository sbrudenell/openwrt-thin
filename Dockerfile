FROM openwrt-15.05.1-x86-64-initial

RUN mkdir /var/lock
RUN mkdir /var/run

RUN /etc/init.d/odhcpd disable
RUN /etc/init.d/dropbear disable
RUN /etc/init.d/telnet disable
RUN /etc/init.d/dnsmasq disable
RUN /etc/init.d/sysntpd disable

ADD network /etc/config/network
ADD firewall /etc/config/firewall
# Workaround for https://github.com/moby/moby/issues/34337
ADD 50_load_iptables /lib/preinit/50_load_iptables

RUN /bin/opkg remove \
              dropbear \
              odhcpd odhcp6c \
              dnsmasq \
              kmod-r8169 r8169-firmware kmod-e1000e kmod-e1000 kmod-mii \
              ppp-mod-pppoe ppp kmod-pppoe kmod-pppox kmod-ppp \
              mtd \
              luci \
              luci-mod-admin-full \
              luci-app-firewall \
              luci-base \
              luci-lib-nixio \
              luci-lib-ip \
              luci-theme-bootstrap \
              luci-proto-ppp \
              luci-proto-ipv6 \
              uhttpd-mod-ubus uhttpd \
              lua \
              libuci-lua \
              libubus-lua \
              libiwinfo-lua libiwinfo \
              liblua \
              kmod-ptp kmod-pps \
              kmod-slhc kmod-lib-crc-ccitt

RUN rm -rf /etc/dnsmasq.conf \
           /etc/config/dhcp \
           /etc/config/uhttpd \
           /etc/ppp \
           /www \
           /etc/dropbear \
           /etc/config/dropbear \
           /usr/lib/lua \
           /usr/lib/pppd \
           /lib/firmware \
           /lib/modules \
           /usr/share/libiwinfo
