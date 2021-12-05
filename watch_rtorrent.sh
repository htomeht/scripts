#! /bin/sh

# PID file
PIDFILE="/tmp/rdw.pid"

# Paths
WATCHDIR="/home/gabriel/download"
TORRENTS="/home/gabriel/download/torrents"

# Programs
INOTIFY="/usr/bin/inotifywait"
MV="/bin/mv"
NAUGHTY="/usr/bin/libnotify-notify-send"

function clean {
  # Restore system
  rm $PIDFILE
  exit
}

trap clean SIGHUP SIGINT SIGTERM

if [ "$#" -gt 0 ]; then
  case $1 in
    start)
      if [ -e $PIDFILE ]; then # A process is running?
        exit
      fi
      echo $$ > $PIDFILE
      $INOTIFY -m $WATCHDIR -e create -e moved_to | 
        while read path action file; do
          if [[ "$file" == *".torrent" ]]; then 
            $NAUGHTY "RDW is Moving '$file' to '$TORRENTS'"
            $MV "$path/$file" $TORRENTS
          fi
        done
      ;;
    stop)
      if [ -e $PIDFILE ]; then # A process is running?
        kill -1 `cat $PIDFILE`
        clean
      fi
      ;;
  esac
fi


#PATH="/home/gabriel/download"
#TORRENTS="/home/gabriel/download/torrents"
#
## Programs
#MV="/bin/mv"
#NAUGHTY="/usr/bin/libnotify-notify-send"
#INOTIFY="/usr/bin/inotifywait"
#
#$INOTIFY -m $PATH -e create -e moved_to | 
#  while read path action file; do
#    echo "Rtorrent found '$file' at '$path' via '$action'"
#    $NAUGHTY "Moooving '$file' to '$TORRENTS'"
#    if [[ "$file" == *".torrent" ]]; then 
#      $NAUGHTY "Moving '$file' to '$TORRENTS'"
#      $MV "$path/$file" $TORRENTS
#    fi
#  done
    
