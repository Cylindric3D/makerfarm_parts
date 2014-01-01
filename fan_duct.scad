use <lib/polyholes.scad>
use <lib/fans.scad>
use <lib/jhead.scad>
use <lib/makerfarm_parts.scad>

// Distance from mounting-holes to Z-zero
ZPrime=62;

// Various tuning parameters for the distances between components
y1=10; // end cap centre
y2=-10; // near-end of nozzle
y3=-30; // near-end of Y-split
y4=-60; // near-end of vertical part

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
part="all"; // all, duct, bracket


/*

"duct"
  \___AirHead();
        \___FanDuct();
        |___DuctVertical();
        |     \___FanMountPlate();
        |___Elbow();
        |___DuctY();
        |___Vent();
        |___Vent();

"bracket"
  \___FanMountPlate();
  |___FanMountPlateHoles();
*/


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

module DuctVertical()
{
	ductheight=42;

	d1=ductheight-fan_thickness-4;
	d2=d1/2;

	if(d1>0)
	{
		union()
		{
			// lower, narrow part
			difference()
			{
				hull()
				{
					translate([-10, 0, d2-j]) cube([20, 20, j]);
					translate([-7.5, 0, 0]) cube([15, 15, j]);
				}	

				hull()
				{
					translate([-10+t, t, d2+j])  cube([20-t*2, 20-t*2, j]);
					translate([-7.5+t, t, -j]) cube([15-t*2, 15-t*2, j]);
				}
			}

			// upper, round part
			difference()
			{
				hull()
				{
					translate([0, fan_size/2, d1]) cylinder(r=fan_size/2.2, h=j, $fn=detail);
					translate([-10, 0, d2-j]) cube([20, 20, j]);
				}

				hull()
				{
					translate([0, fan_size/2, d1+j]) cylinder(r=fan_size/2.2-t, h=j, $fn=detail);
					translate([-10+t, t, d2-j*2]) cube([20-t*2, 20-t*2, j]);
				}				
			}

			// Overhang support
			hull()
			{
				translate([0, t/2, d2-j]) cube([t, 20-t, j]);
				translate([0, t/2, -j]) cube([t, 15-t, j]);
			}

			// Fan bracket
			translate([0, 20, d1])
			FanMountPlate(size=fan_size, thickness=4, traps=true);

		}
	}
}


module Elbow()
{
	translate([-7.5, 0, -rpipe])
	difference()
	{
		cube([15, 15, 10]);
		translate([t, t, 5]) cube([15-t*2, 15-t*2, 10]);
		translate([t, 7.5, t]) cube([15-t*2, 15, 10-t*2]);
		translate([t, 7.5, 7.5]) rotate([0, 90, 0]) cylinder(r=7.5-t, h=15-t*2, $fn=detail);
	}
}


module DuctRoot()
{
	difference()
	{
		hull()
		{
			translate([-7.5, y4-y3+15, -5])
			cube([15, j, 10]);
				
			translate([0, 0, 0]) scale([1.5, 1.5, 1]) 
			sphere(r=rpipe, $fn=detail);
		}

		hull()
		{
			translate([-7.5+t, y4-y3+15-j, -5+t])
			cube([15-t*2, j, 10-t*2]);
				
			translate([0, 0, 0]) scale([1.5, 1.5, 1]) 
			sphere(r=rpipe-t, $fn=detail);
		}

		rotate([90, 0, 0]) scale([1.5, 1, 1]) cylinder(r=5-t, h=25, center=true, $fn=detail);
	}
}


module DuctV()
{
	difference()
	{
		hull()
		{
			translate([0, 0, 0]) scale([1.5, 1.5, 1]) sphere(r=rpipe, $fn=detail);
			translate([-20, y2-y3, 0]) scale([1.5, 1.5, 1]) sphere(r=rpipe, $fn=detail);
		}
		hull()
		{
			translate([0, 0, 0]) scale([1.5, 1.5, 1]) sphere(r=rpipe-t, $fn=detail);
			translate([-20, y2-y3, 0]) scale([1.5, 1.5, 1]) sphere(r=rpipe-t, $fn=detail);
		}

		// Vent
		rotate([0, 40, 45]) translate([0, 8, -t]) cube([rpipe*1.6, y1-y2-5, t*2]);

		// Hole to join to next parts
		rotate([90, 0, 0]) scale([1.5, 1, 1]) cylinder(r=5-t, h=rpipe*4, $fn=detail);
		translate([-20, y2-y3, 0]) rotate([-90, 0, 0]) scale([1.5, 1, 1]) cylinder(r=5-t, h=rpipe*4, $fn=detail);
	}
}


module DuctY()
{
	difference()
	{
		union()
		{
			DuctRoot();
			DuctV();
			scale([-1, 1, 1]) DuctV();
		}

		// Hole to join to next part
		rotate([90, 0, -135]) scale([1.5, 1, 1]) cylinder(r=5-t, h=rpipe*4);
		rotate([90, 0, 135]) scale([1.5, 1, 1]) cylinder(r=5-t, h=rpipe*4);

		// Remove top for debugging
		// translate([-100, -100, 0]) cube([200, 200, 200]);
	}
}


module Vent()
{
	difference()
	{
		// Outer surface
		hull()
		{
			scale([1.5, 1.5, 1]) sphere(r=rpipe, $fn=detail);
			translate([0, y1-y2, 0]) scale([1.5, 1, 1]) sphere(r=rpipe, $fn=detail);
		}

		// Inner surface
		hull()
		{
			scale([1.5, 1.5, 1]) sphere(r=rpipe-t, $fn=detail);
			translate([0, y1-y2, 0]) scale([1.5, 1, 1]) sphere(r=rpipe-t, $fn=detail);
		}

		// Hole to join to next part
		rotate([90, 0, 45]) scale([1.5, 1, 1]) cylinder(r=5-t, h=rpipe*4, $fn=detail);

		// Vent
		rotate([0, 40, 0]) translate([0, 4, -t]) cube([rpipe*1.6, y1-y2-7, t*2]);

		// Remove top for debugging
		//translate([-100, -100, 0]) cube([200, 200, 200]);
	}
}


module AirHead()
{
	color("SteelBlue")
	translate([0, 0, rpipe])
	union()
	{
		// Vertical Stem
		translate([0, y4, 5]) DuctVertical();

		// Elbow
		translate([0, y4, 0]) Elbow();
			
		// Arms of the Y
		translate([0, y3, 0]) DuctY();

		// Vents
		translate([-20, y2, 0]) Vent();
		translate([20, y2, 0]) scale([-1, 1, 1]) Vent();
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
	%JHead();
	
	translate([0, -13.5, ZPrime-7]) // 7 is the distance from the bottom of the block to the centre of the holes
	%XCarriage();
	
	translate([0, y4, 32+fan_thickness+2])
	Bracket();

	translate([0, -40, 34])
	%Fan(fan_size, fan_thickness);

	translate([0, 0, 2])
	AirHead();
}

if(part == "duct")
{
	translate([0, 0, 60])
	rotate([90, 0, 0])
	AirHead();
}

if(part == "bracket")
{
	translate([0, -fan_size/2, 0])
	Bracket();
}