#!/bin/sh

# Because we start with a fat layer and strip down to a thin one, more than
# half of the space in the image is wasted. We "compress" the stripped image by
# creating an intermediary container, exporting the filesystem and re-importing
# to create the final image.

docker import https://downloads.openwrt.org/chaos_calmer/15.05.1/x86/64/openwrt-15.05.1-x86-64-rootfs.tar.gz openwrt-15.05.1-x86-64-initial || exit 1
docker build -t openwrt-thin-temp . || exit 1
docker rmi openwrt-15.05.1-x86-64-initial || exit 1
docker create --name openwrt-thin-temp openwrt-thin-temp /bin/sh || exit 1
docker export openwrt-thin-temp | gzip > openwrt-thin.tar.gz || exit 1
docker rm openwrt-thin-temp || exit 1
docker rmi openwrt-thin-temp || exit 1
docker import -c 'CMD ["/sbin/init"]' openwrt-thin.tar.gz openwrt-thin:15.05.1-x86-64 || exit 1
rm openwrt-thin.tar.gz || exit 1
