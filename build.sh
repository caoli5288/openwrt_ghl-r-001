#!/bin/bash -x

git submodule add https://github.com/openwrt/openwrt.git \
  && git submodule add https://github.com/coolsnowwolf/lede.git \
  && cp .config openwrt/ \
  && rm -rf openwrt/tools/ \
  && cp -a lede/tools/ openwrt/ \
  && cp -a lede/package/lean/ openwrt/package/ \
  && sudo apt update && sudo apt install -y build-essential libncurses-dev \
  && cd openwrt \
  && ./scripts/feeds update -a \
  && ./scripts/feeds install -a \
  && make defconfig \
  && make toolchain/compile -j`nproc` \
  && make package/luci/compile -j`nproc` \
  && make -j`nproc`
