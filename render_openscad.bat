@ECHO OFF
SET PAGES_PATH=..\gh-pages\makerfarm_parts

ECHO Generating images
openscad.exe -o img\part-x_side.png -D "side=""right""" --render x_side.scad
openscad.exe -o img\picam_mount.png --render picam_mount.scad

ECHO Generating STL files
openscad.exe -o stl\part-x_side.stl -D "side=""right""" --render x_side.scad
openscad.exe -o stl\picam_mount.stl --render picam_mount.scad

ECHO Updating Pages
COPY img\*.png %PAGES_PATH%\images\
COPY stl\*.stl %PAGES_PATH%\stl\
