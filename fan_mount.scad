use <lib/polyholes.scad>;

// lib/fan_mount.stl is from AeroMonkeyDork's 40mm Supportless, Directed Cooling Fan Duct for MendelMax & Prusa
// http://www.thingiverse.com/thing:63123


module Clamp()
{
	intersection()
	{
		translate([0, 0, 2])
		import("lib/fan_mount.stl");

		cube([25, 18, 25], center=true);
	}
}

translate([0, 0, 3]) Clamp();


hole_centres=30.33;
mount_width=40;
mount_height=10;
mount_thickness=3.3;
r=2;
j=0.1;

difference()
{
	hull()
	{
		translate([-r, mount_width/2-r, 0]) cylinder(r=r, h=mount_thickness, $fn=10);
		translate([-r, -mount_width/2+r, 0]) cylinder(r=r, h=mount_thickness, $fn=10);
		translate([-mount_height+r, mount_width/2-r, 0]) cylinder(r=r, h=mount_thickness, $fn=10);
		translate([-mount_height+r, -mount_width/2+r, 0]) cylinder(r=r, h=mount_thickness, $fn=10);
	}
	translate([-mount_height/2, -hole_centres/2, -j]) polyhole(d=3, h=mount_thickness+j*2);
	translate([-mount_height/2, hole_centres/2, -j]) polyhole(d=3, h=mount_thickness+j*2);
}