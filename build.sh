#!/bin/bash -x

git submodule add https://github.com/openwrt/openwrt.git \
  && git submodule add https://github.com/coolsnowwolf/lede.git \
  && cp .config openwrt/ \
  && rm -rf openwrt/tools/ \
  && cp -a lede/tools/ openwrt/ \
  && cp -a lede/package/lean/ openwrt/package/ \
  && sudo apt update && sudo apt install -y build-essential libncurses-dev \
  && cd openwrt \
  && git apply ../01-fix-flash.patch \
  && rm target/linux/ramips/patches-4.14/304-spi-nor-enable-4B-opcodes-for-mx25l25635f.patch \
  && cp ../999-fix-m25p-shutdown.patch  target/linux/ramips/patches-4.14/ \
  && ./scripts/feeds update -a \
  && ./scripts/feeds install -a \
  && make defconfig \
  && make toolchain/compile -j`nproc` \
  && make package/luci/compile -j`nproc` \
  && make -j`nproc`
