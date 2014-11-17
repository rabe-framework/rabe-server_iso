#!/bin/bash

# mount ISO
mkdir -v -p temp/mntiso/
mount -v -o loop "$ISOSRC" temp/mntiso/

# extract ISO
mkdir -v -p temp/newiso/
cp -v -r temp/mntiso/* temp/newiso/
cp -v -r temp/mntiso/.disk/ temp/newiso/

# unmount ISO
umount -v temp/mntiso/

# copy boot menu file
cp -v configs/txt.cfg temp/newiso/isolinux/

# copy kickstart file
cp -v configs/ks-rabe-server.cfg temp/newiso/preseed/

# copy, rename and append preseed file
cp -v temp/newiso/preseed/ubuntu-server.seed temp/newiso/preseed/rabe-server.seed
echo "# Confirm partitioning." >> temp/newiso/preseed/rabe-server.seed
echo "d-i	partman-partitioning/confirm_write_new_label boolean true" >> temp/newiso/preseed/rabe-server.seed
echo "d-i	partman/choose_partition select finish" >> temp/newiso/preseed/rabe-server.seed
echo "d-i	partman/confirm boolean true" >> temp/newiso/preseed/rabe-server.seed
echo "d-i	partman/confirm_nooverwrite boolean true" >> temp/newiso/preseed/rabe-server.seed
echo "# Add extra packages." >> temp/newiso/preseed/rabe-server.seed
echo "d-i	pkgsel/include string open-iscsi openvpn easy-rsa iscsitarget" >> temp/newiso/preseed/rabe-server.seed

# download extra packages (offline install)
mkdir -v -p temp/newiso/pool/extras/
apt-get -d -o Dir::Cache::archives="temp/newiso/pool/extras/" -y install open-iscsi openvpn easy-rsa iscsitarget

# copy rabe files
#mkdir -v -p temp/newiso/rabe/

# update MD5 checksums
md5sum `find ! -name "md5sum.txt" ! -path "newiso/isolinux/*" -follow -type f` > newiso/md5sum.txt

# create new ISO
mkisofs -J -l -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -z -iso-level 4 -c isolinux/isolinux.cat -o images/rabe-server-amd64_$(date +%Y%m%d%H%M).iso -joliet-long temp/newiso/

# clean garbage
rm -v -r temp