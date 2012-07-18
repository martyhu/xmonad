#!/bin/bash
# Goes in the path - hack for dual monitors.
EXTERNAL_OUTPUT='VGA'
CONNECTED=$(xrandr | grep $EXTERNAL_OUTPUT | grep " connected ")
if [ "$CONNECTED" ]
then
    # Set up the big screen.
    xrandr --output VGA1 --mode 1920x1080
    xrandr --output LVDS1 --off
fi
