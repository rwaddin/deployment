#!/bin/bash
cd -P -- "$(dirname -- "$0")"
MYPWD="$(pwd -P)"

MYUSER="dev"      # nama user
MYGROUP="dev"     # nama group
GITBRANCH="devel"   # branch git yang akan dideploy
MASTER="$MYPWD/master"                  # temporary dir untuk compare lama & baru
OVERRIDE="$MYPWD/override"              # override file
SOURCE="/root/deploy/source/"           # source git yang ada di folder deploy
DEST="/home/dev/web/namaDomain.id/public_html/" # directory website nya

cd $MYPWD # masuk ke current directory deployment

rm -rf $MASTER/ # hapus file di folder master
mkdir -p $MASTER/ # buat sub folder master
rsync -arvz --delete --exclude-from=$MYPWD/ignore.list $SOURCE/ $MASTER/ # bandingkan & abaikan yang ada di source & master


# override
/bin/cp -rvf $OVERRIDE/* $MASTER/
/bin/cp -rvf $OVERRIDE/. $MASTER/

chown -R $MYUSER:$MYGROUP $MASTER/. # ambil sub folder master
chown $MYUSER:$MYGROUP $MASTER # ambil alih folder master
find $MASTER/ -type f -exec chmod 644 {} \;
find $MASTER/ -type d -exec chmod 751 {} \;
chmod 751 $MASTER

chown $MYUSER:$MYGROUP $DEST
chmod 751 $DEST

#rsync folder master to tujuan akhir
rsync -arvz --delete --exclude-from=$MYPWD/ignore.list $MASTER/. $DEST/.
