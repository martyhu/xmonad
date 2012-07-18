#!/bin/bash
xrandr --auto --output LVDS1 --mode 1366x768 --left-of VGA1
xrandr --auto --output VGA1 --mode 1920x1080 --right-of LVDS1