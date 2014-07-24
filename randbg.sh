#!/bin/bash

function log {
    echo "[randbg]  $1"
}

RES="2560x1600"
SEARCH="$1"
DIR=$HOME
EXTENSION="jpg"
NAME_TEMP="wallpaper-temp.$EXTENSION"
NAME_CURRENT="wallpaper-current.$EXTENSION"

mkdir -p $DIR

while true; do
    log "Fetching random images from wallbase.cc..."
    IMAGE_ID=$(curl -s http://wallbase.cc/search\?q\=$SEARCH\&section\=wallpapers\&res_opt\=eqeq\&res\=$RES\&order_mode\=desc\&order\=random\&thpp\=5 | grep -G "<a href=\"http://wallbase.cc/wallpaper/" | grep -o "[0-9]\+" | shuf -n 1)

    log "Attempting to load random image..."
    rm -f $DIR/$NAME_TEMP
    wget --quiet -O $DIR/$NAME_TEMP http://wallpapers.wallbase.cc/rozne/wallpaper-$IMAGE_ID.$EXTENSION
    if [ $? -eq 0 ]; then
        xloadimage -quiet -onroot -fullscreen $NAME_TEMP
        if [ $? -eq 0 ]; then
            log "==> New background image: #$IMAGE_ID."
            rm -f $DIR/$NAME_CURRENT
            mv $DIR/$NAME_TEMP $DIR/$NAME_CURRENT
        else
            log "Unable to set image as the new background. Will try again."
        fi
        break
    else
        log "Unable to load image. Will try again."
    fi
done
