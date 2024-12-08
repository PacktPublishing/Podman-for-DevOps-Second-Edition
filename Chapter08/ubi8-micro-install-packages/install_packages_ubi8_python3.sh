#!/bin/bash


set -euo pipefail


if [ $UID -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi


container=$(buildah from registry.access.redhat.com/ubi8/ubi-micro)
mount=$(buildah mount $container)


yum install -y \
  --installroot $mount \
  --setopt install_weak_deps=false \
  --nodocs \
  --noplugins \
  --releasever 8 \
  python3

yum clean all --installroot $mount


buildah umount $container
buildah commit $container micro_httpds