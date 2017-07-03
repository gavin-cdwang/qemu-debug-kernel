#!/bin/bash


WORK_DIR=$(pwd)
BUSYBOX_DIR=$WORK_DIR/busybox-1.24.0
CROSS_COMPILE=/opt/toolchains/arm-2014.05


sudo rm -rf $WORK_DIR/rootfs
sudo rm -rf $WORK_DIR/tmp
sudo rm -rf $WORK_DIR/ramdisk*

sudo mkdir $WORK_DIR/rootfs

ROOTFS_DIR=$WORK_DIR/rootfs

sudo cp -rfa $BUSYBOX_DIR/_install/*  $ROOTFS_DIR 
sudo cp -rfa $WORK_DIR/etc/ $ROOTFS_DIR

sudo mkdir -p $ROOTFS_DIR/proc/
sudo mkdir -p $ROOTFS_DIR/sys/
sudo mkdir -p $ROOTFS_DIR/tmp/
sudo mkdir -p $ROOTFS_DIR/var/
sudo mkdir -p $ROOTFS_DIR/mnt/


sudo cp -arf $CROSS_COMPILE/arm-none-linux-gnueabi/libc/lib $ROOTFS_DIR

sudo $CROSS_COMPILE/bin/arm-none-linux-gnueabi-strip $ROOTFS_DIR/lib/* 2>/dev/null

sudo mkdir -p $ROOTFS_DIR/dev/
sudo mknod $ROOTFS_DIR/dev/tty1 c 4 1
sudo mknod $ROOTFS_DIR/dev/tty2 c 4 2
sudo mknod $ROOTFS_DIR/dev/tty3 c 4 3
sudo mknod $ROOTFS_DIR/dev/tty4 c 4 4
sudo mknod $ROOTFS_DIR/dev/console c 5 1
sudo mknod $ROOTFS_DIR/dev/null c 1 3
echo 
echo "@@@@@ make the ramdisk and format to ext4 @@@@@"
sudo dd if=/dev/zero of=ramdisk bs=1M count=8
sudo mkfs.ext4 -F ramdisk

sudo mkdir -p tmp
sudo mount -t ext4 ramdisk  tmp/
sudo cp -raf $ROOTFS_DIR/*  tmp/
sudo umount tmp

gzip -9 ramdisk

echo "@@@@@make the ramdisk to fit uboot format @@@@@"
sudo mkimage -A arm -O linux -T ramdisk -C gzip -n "ramdisk" -d ramdisk.gz ramdisk.img

