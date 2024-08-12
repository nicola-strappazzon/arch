#!/usr/bin/env bash

killall -q polybar
polybar --config=$HOME/.config/polybar/config.ini
