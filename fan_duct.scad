use <lib/polyholes.scad>
use <lib/fans.scad>
use <lib/jhead.scad>
use <lib/makerfarm_parts.scad>

// Distance from mounting-holes to Z-zero
ZPrime=62;

// radius around the hot-end
r_vent=25;


// Thickness of the structure walls
t=1;

// Minor-radius of the duct arms
rpipe=5;

// Size and thickness of the fan being used
fan_size=40;
fan_thickness=20;

// roundness of the circular parts ($fn)
detail=40;

// Jitter, used to prevent coincident-surface problems. Should be less than layer-thickness.
j=0.05;

// Part to show
part="duct"; // all, duct, bracket

// Debugging slices
debug_slice=0;
debug_layer_height=1;

module FanFixture()
{
	color("DodgerBlue")
	translate([-20, 0, 0]) 
	difference()
	{
		// main body
		cube([40, 40, 2]);

		// main hole
		translate([20, 20, -j]) cylinder(r=18, h=3+j*2, $fn=detail);

		// screw holes
		translate([3, 3, -j]) polyhole(d=3, h=3+j*2);
		translate([40-3, 3, -j]) polyhole(d=3, h=3+j*2);
		translate([3, 40-3, -j]) polyhole(d=3, h=3+j*2);
		translate([40-3, 40-3, -j]) polyhole(d=3, h=3+j*2);
	}
}


module CarriageFixture()
{
	bolt=fan_mount_hole_diameter;
	centres=fan_mount_hole_centres;
	width=centres+bolt*2.5;

	color("DarkTurquoise")
	difference()
	{
		// main body
		translate([-width/2, 0, 0]) cube([width, 2, 12]);

		// holes
		translate([centres/2, -j, 7]) rotate([-90, 0, 0]) polyhole(d=bolt, h=3+j*2);
		translate([-centres/2, -j, 7]) rotate([-90, 0, 0]) polyhole(d=bolt, h=3+j*2);
	}
}


module HoseLink(from, to, radius)
{
	hull()
	{
		translate(from) sphere(r=radius);
		translate(to) sphere(r=radius);
	}
}


module Hose(points, radius, thickness)
{
	num = len(points);
	difference()
	{
		union()
		{
			for(i = [1:num-3])
			{
				HoseLink(points[i], points[i+1], radius, thickness);
			}
		}
		if(thickness>0)
		{
			union()
			{
				HoseLink(points[0], points[1], radius-thickness);
				HoseLink(points[num-2], points[num-1], radius-thickness);
			}
		}
	}
}


module AirHead()
{
	//p = [[0,-10,0], [0,0,0], [0,10,0], [0,20,20], [0,30,40]];
	
	//Hose(p, rpipe, 0.2);
	hmain=29;
	rmajor=20;
	rminor=12;
	holes=14;
	
	
	union()
	{
		// Top is the fan-mounting plate
		translate([0, -40, 22])
		union()
		{
			difference()
			{
				FanMountPlate(size=40, thickness=10, traps=true, roundback=false, bighole=false);
				translate([0, 0, t]) cylinder(r=16, h=10+j*2);
				translate([-10, 10, t]) cube([20, 20, 10-t*2]);
			}

			// Bridge support
			difference()
			{
				cylinder(r=10, h=10);

				translate([0, 0, 10-t])
				rotate_extrude(convexity = 10, $fn=detail)
				translate([15, 0, 0])
				circle(r = 10, $fn=detail);			
			}
		}

		translate([0, 0, 3]) 
		difference()
		{
			union()
			{
				cylinder(r=rmajor, h=hmain, $fn=detail);
				translate([-20, -20, hmain-10]) cube([40, 20, 10]);
			}
			translate([0, 0, -j]) cylinder(r=rminor, h=hmain+j*2, $fn=detail);

			// Hollow out the main cylinder
			difference()
			{
				translate([0, 0, t*4]) cylinder(r=rmajor-t, h=hmain-t*5, $fn=detail);
				translate([0, 0, -j]) cylinder(r=rminor+t, h=hmain+j*2, $fn=detail);
			}

			// Top hole for main air inlet
			difference()
			{
				translate([-10, -30, hmain-10+t]) cube([20, 20, 10-t*2]);
				translate([0, 0, -j]) cylinder(r=rminor+t, h=hmain+j*2, $fn=detail);
			}

			// Drill the holes in the bottom
			for(h = [0:holes-1])
			{
				rotate([0, 0, h*(360/holes)])
				translate([rmajor-(rmajor-rminor)/2+1, 0, t*3])
				union()
				{
					rotate([0, -180+35, 0])
					cylinder(r=2, h=20, $fn=detail);
					translate([0, 0, 0]) sphere(r=2, $fn=detail);
				}
			}

			///*DEBUG*/translate([0, 0, 9]) cylinder(r=1000, h=1000, $fn=detail);
		}

		translate([0, 0, 3+t*3])
		//rotate([0, 0, 0.5*(360/holes)])
		for(h = [0:holes-1])
		{
			rotate([0, 0, h*(360/holes)])
			difference()
			{
				translate([rminor+t/2, -t/2, 1]) cube([(rmajor-rminor-t)/3, t, 4]);
				translate([rmajor-(rmajor-rminor)/2, 0, t*5]) rotate([90, 0, 0]) cylinder(r=(rmajor-rminor)/2-t/2, h=t*2, center=true, $fn=detail);
			}
		}
	}
}


module Bracket()
{
	l=6;
	t=3;
	roundness=2;

	color("SteelBlue")
	union()
	{

		translate([0, fan_size/2, 0])
		FanMountPlate(size=fan_size, thickness=2);

		difference()
		{
			translate([-fan_size/2, fan_size-10, 0]) 
			cube([fan_size, 10+l, t]);
	
			translate([0, fan_size/2, 0])
			FanMountPlateHoles(size=fan_size, thickness=t);
		}

		translate([-fan_size/2, fan_size+l-t, 0])
		difference()
		{
			hull()
			{
				cube([fan_size, t, j]);
				translate([roundness, 0, 13-roundness]) rotate([270, 0, 0]) cylinder(r=roundness, h=t, $fn=detail);
				translate([fan_size-roundness, 0, 13-roundness]) rotate([270, 0, 0]) cylinder(r=roundness, h=t, $fn=detail);
			}

			// Backplate holes
			translate([fan_size/2-16, -j, 8]) rotate([270, 0, 0]) cylinder(r=1.5, h=t+j*2, $fn=detail);
			translate([fan_size/2+16, -j, 8]) rotate([270, 0, 0]) cylinder(r=1.5, h=t+j*2, $fn=detail);
		}

		// Reinforcement
		translate([0, fan_size-2, t])
		difference()
		{
			translate([-fan_size/4, 0, 0])
			cube([fan_size/2, l, 8]);

			translate([0, -j, (l-1)*1.5])
			rotate([0, 90, 0])
			cylinder(r=l-1, h=fan_size+j*2, center=true, $fn=3);
		}
	}
}


if(part == "all")
{
	translate([0, 0, -2])
	union()
	{
		%JHead();
	
		translate([0, -13.5, ZPrime-7]) // 7 is the distance from the bottom of the block to the centre of the holes
		%XCarriage();

		translate([0, -60, 32+fan_thickness+2])
		Bracket();

		translate([0, -40, 34])
		%Fan(fan_size, fan_thickness);
	}
	

	translate([0, 0, 0])
	AirHead();

}

if(part == "duct")
{
	difference()
	{
		translate([0, 0, 32])
		rotate([180, 0, 0])
		AirHead();

		///*DEBUG*/translate([0, 0, 1]) cylinder(r=1000, h=1000, $fn=detail);
		if(debug_slice>0)
		{
			translate([0, 0, debug_slice*debug_layer_height]) cylinder(r=1000, h=1000, $fn=detail);
		}
	}
}

if(part == "bracket")
{
	translate([0, -fan_size/2, 0])
	Bracket();
}