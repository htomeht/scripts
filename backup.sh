#!/bin/sh

LIST="etc var/www home/gabriel home/share/code home/share/graphics home/share/text home/share/audio usr/local/bin" 

for d in $LIST; do
  rsync -ax /$d /home/bkup
done
