#!/bin/bash

CRTDIR=$(pwd)

base=$1
profile=$2
if [ ! -e "$base" ]; then
	echo "Please enter base folder"
	exit 1
else
	if [ ! -d $base ]; then 
		echo "Openwrt base folder not exist"
		exit 1
	fi
fi

if [ ! -n "$profile" ]; then
	profile=glinet_ax1800
fi

echo "Start..."
#clone source
git clone -b next https://github.com/Telecominfraproject/wlan-ap.git $base/wlan-ap
cd $base/wlan-ap
git am $CRTDIR/patches/*.patch

# cp some files
cd $CRTDIR
ln -s $CRTDIR/custom $base/wlan-ap/feeds/custom
cp -rf *.yml $base/wlan-ap/profiles/

# copy path
cp -r patches/openwrt/*.patch $base/wlan-ap/patches/

# setup
cd $base/wlan-ap
$base/wlan-ap/setup.py --setup

#gen config
cd $base/wlan-ap/openwrt

#gen config
./scripts/gen_config.py $profile

# feed update
./scripts/feeds update -a && ./scripts/feeds install -a

make defconfig

