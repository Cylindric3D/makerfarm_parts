@ECHO OFF
SET PAGES_PATH=..\gh-pages\makerfarm_parts

ECHO Generating images
openscad.exe -o img\part-x-side.png -D "side=""right""" --render x-side.scad
openscad.exe -o img\picam-mount.png --render picam-mount.scad

ECHO Generating STL files
openscad.exe -o stl\part-x-side.stl -D "side=""right""" --render x-side.scad
openscad.exe -o stl\picam-mount.stl --render picam-mount.scad

ECHO Updating Pages
COPY img\*.png %PAGES_PATH%\images\
COPY stl\*.stl %PAGES_PATH%\stl\
