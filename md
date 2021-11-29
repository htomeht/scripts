#!/bin/sh
# Script to start and stop raid checks, 
# done by lowering and raising allowed speed.

case "$1" in
    start)
    echo "Starting raid checking..."
    echo '200000' > /proc/sys/dev/raid/speed_limit_max
    ;;
    stop)
    echo "Stopping raid checking..."
    echo '0' > /proc/sys/dev/raid/speed_limit_min
    echo '0' > /proc/sys/dev/raid/speed_limit_max
    ;;
    *)
    echo "Usage: $0 OPTION"
    echo "Start or stop raid checking (basically)"
    echo ""
    echo "Options:"
    echo "  start       Let the raid have full speed for checking."
    echo "  stop        Let the raid have minimum speed for checking."
    ;;
esac
