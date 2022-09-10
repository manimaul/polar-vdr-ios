#!/usr/bin/env python3

import os.path
import subprocess

s_dir = os.path.dirname(os.path.realpath(__file__))

sizes = [20, 29, 40, 60, 58, 76, 80, 87, 120, 152, 167, 180, 1024]

if __name__ == "__main__":
    svg = os.path.abspath(os.path.join(s_dir, "icons/icon.svg"))
    for s in sizes:
        icon = "icons/icon_{}.png".format(s)
        png = os.path.abspath(os.path.join(s_dir, icon))
        cmd = "inkscape --without-gui --export-png={} --export-width={} --export-height={} --export-background-opacity=0 {}".format(png, s, s, svg)
        subprocess.check_output(cmd.split(" "))

# files=( "icon" )
#
# for i in ${files[@]}; do
#     echo item: $i.svg
#     inkscape --without-gui --export-png=../../res/drawable-ldpi/$i.png --export-dpi=120 --export-background-opacity=0 $i.svg
#     inkscape --without-gui --export-png=../../res/drawable-mdpi/$i.png --export-dpi=160 --export-background-opacity=0 $i.svg
#     inkscape --without-gui --export-png=../../res/drawable-hdpi/$i.png --export-dpi=240 --export-background-opacity=0 $i.svg
#     inkscape --without-gui --export-png=../../res/drawable-xhdpi/$i.png --export-dpi=320 --export-background-opacity=0 $i.svg
#     inkscape --without-gui --export-png=../../res/drawable-xxhdpi/$i.png --export-dpi=480 --export-background-opacity=0 $i.svg
# done
