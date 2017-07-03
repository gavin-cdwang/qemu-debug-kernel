#!/bin/sh

WORK_DIR=$(pwd)
KERNEL_DIR=$WORK_DIR/lts4.9.33

sudo qemu-system-arm -M vexpress-a9 -smp 2 -m 1024M \
-kernel $KERNEL_DIR/arch/arm/boot/zImage -initrd  $WORK_DIR/ramdisk.img  \
-append "root=/dev/ram0 rw rootfstype=ext4 init=/linuxrc console=ttyAMA0 \
ip=192.168.199.140:192.168.199.136:192.168.199.1:255.255.255.0 loglevel=8" \
-dtb $KERNEL_DIR/arch/arm/boot/dts/vexpress-v2p-ca9.dtb  -nographic \
-net nic,vlan=0 -net tap,vlan=0,ifname=tap0,script=./qemu-ifup,downscript=qemu-ifdown
