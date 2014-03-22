@ECHO OFF
SET PAGES_PATH=..\gh-pages\makerfarm_parts

ECHO Generating images
openscad -o img\part-x_side.png --render x_side.scad
openscad -o img\x_servomount.png --render x_servomount.scad
openscad -o img\x_depthmount.png --render x_depthmount.scad
openscad -o img\x_solenoidmount.png --render x_solenoidmount.scad
openscad -o img\picam_mount.png --render picam_mount.scad

openscad -o img\fan_duct-duct.png -D part=\"duct\" --render fan_duct.scad
openscad -o img\fan_duct-bracket.png -D part=\"bracket\" --render fan_duct.scad
openscad -o img\fan_duct-gasket.png -D part=\"gasket\" --render fan_duct.scad

ECHO Generating STL files
openscad -o stl\part-x_side.stl x_side.scad
openscad -o stl\x_servomount.stl x_servomount.scad
openscad -o stl\x_depthmount.stl x_depthmount.scad
openscad -o stl\x_solenoidmount.stl x_solenoidmount.scad
openscad -o stl\picam_mount.stl picam_mount.scad

openscad -o stl\fan_duct-duct.stl -D part=\"duct\" fan_duct.scad
openscad -o stl\fan_duct-bracket.stl -D part=\"bracket\" fan_duct.scad
openscad -o stl\fan_duct-gasket.stl -D part=\"gasket\" fan_duct.scad

ECHO Updating Pages
COPY img\*.png %PAGES_PATH%\images\
COPY stl\*.stl %PAGES_PATH%\stl\

:END