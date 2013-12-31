use <lib/polyholes.scad>

j=0.1;

fan_mount_hole_centres=32;
fan_mount_hole_diameter=3;

jhead_diameter=14;

part="duct"; // all, duct


module JHead()
{
	color("Gold")
	union()
	{
		translate([0, 0, 2]) cylinder(r=jhead_diameter/2, h=61);
		translate([0, 0, 4+2]) cube([jhead_diameter, jhead_diameter, 8], center=true);
		translate([0, 0, 0]) cylinder(r1=0, r2=jhead_diameter/2, h=2);
	}
}

module XCarriage()
{
	c=fan_mount_hole_centres;
	d=fan_mount_hole_diameter;

	color("Khaki")
	translate([0, -13.5, 63]) 
	difference()
	{
		translate([0, 15, 10]) cube([60, 30, 20], center=true);
		translate([c/2, -j, 7]) rotate([-90, 0, 0]) polyhole(d=d, h=35);
		translate([-c/2, -j, 7]) rotate([-90, 0, 0]) polyhole(d=d, h=35);
	}
}


module FanFixture()
{
	color("DodgerBlue")
	translate([-20, 0, 0]) 
	difference()
	{
		// main body
		cube([40, 40, 2]);

		// main hole
		translate([20, 20, -j]) cylinder(r=18, h=3+j*2);

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

y1=10; // end cap centre
y2=-10; // near-end of nozzle
y3=-30; // near-end of Y-split
y4=-60; // near-end of vertical part

t=1;
rpipe=5;



// The duct is 30mm high
module DuctVertical()
{
	union()
	{
		difference()
		{
			hull()
			{
				translate([-10, 0, 30]) cube([20, 20, 10]);
				translate([-7.5, 0, 0]) cube([15, 15, 1]);
			}

			hull()
			{
				translate([-10+t, t, 30])  cube([20-t*2, 20-t*2, 10+j]);
				translate([-7.5+t, t, -j]) cube([15-t*2, 15-t*2, 1]);
			}
		}

		// Overhang support
		hull()
		{
			translate([0, t/2, 30]) cube([t, 20-t, 10]);
			translate([0, t/2, 0]) cube([t, 15-t, t]);
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
		translate([t, 7.5, 7.5]) rotate([0, 90, 0]) cylinder(r=7.5-t, h=15-t*2);
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
			sphere(r=rpipe, $fn=20);
		}

		hull()
		{
			translate([-7.5+t, y4-y3+15-j, -5+t])
			cube([15-t*2, j, 10-t*2]);
				
			translate([0, 0, 0]) scale([1.5, 1.5, 1]) 
			sphere(r=rpipe-t, $fn=20);
		}

		rotate([90, 0, 0]) scale([1.5, 1, 1]) cylinder(r=5-t, h=25, center=true);
	}
}


module DuctV()
{
	difference()
	{
		hull()
		{
			translate([0, 0, 0]) scale([1.5, 1.5, 1]) sphere(r=rpipe, $fn=20);
			translate([-20, y2-y3, 0]) scale([1.5, 1.5, 1]) sphere(r=rpipe, $fn=20);
		}
		hull()
		{
			translate([0, 0, 0]) scale([1.5, 1.5, 1]) sphere(r=rpipe-t, $fn=20);
			translate([-20, y2-y3, 0]) scale([1.5, 1.5, 1]) sphere(r=rpipe-t, $fn=20);
		}
		
		rotate([90, 0, 0]) scale([1.5, 1, 1]) cylinder(r=5-t, h=rpipe*4);
		translate([-20, y2-y3, 0]) rotate([-90, 0, 0]) scale([1.5, 1, 1]) cylinder(r=5-t, h=rpipe*4);
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
		rotate([90, 0, -135]) scale([1.5, 1, 1]) cylinder(r=5-t, h=rpipe*4);
		rotate([90, 0, 135]) scale([1.5, 1, 1]) cylinder(r=5-t, h=rpipe*4);

		// translate([-100, -100, 0]) cube([200, 200, 200]);
	}
}


module Vent()
{
	difference()
	{
		hull()
		{
			scale([1.5, 1.5, 1]) sphere(r=rpipe, $fn=20);
			translate([0, y1-y2, 0]) scale([1.5, 1.5, 1]) sphere(r=rpipe, $fn=20);
		}
		hull()
		{
			scale([1.5, 1.5, 1]) sphere(r=rpipe-t, $fn=20);
			translate([0, y1-y2, 0]) scale([1.5, 1.5, 1]) sphere(r=rpipe-t, $fn=20);
		}
		rotate([90, 0, 45]) scale([1.5, 1, 1]) cylinder(r=5-t, h=rpipe*4);

		// vent
		rotate([0, 40, 0]) translate([0, 4, -t]) cube([rpipe*1.6, y1-y2-7, t*2]);

		//translate([-100, -100, 0]) cube([200, 200, 200]);
	}
}



module FanDuct()
{
	difference()
	{
		hull()
		{
			translate([0, 19, 12]) cylinder(r=19, h=t);
			translate([-10, 0, 0]) cube([20, 20, t]);
		}

		hull()
		{
			translate([0, 19, 12+t/2]) cylinder(r=19-t, h=t);
			translate([-10+t, t, -j]) cube([20-t*2, 20-t*2, t]);
		}
	}
}


module AirHead()
{
	tpipe=1;
	pronggap=40;

	angle=0;
	res=20;


	color("SteelBlue")
	translate([0, 0, rpipe+2])
	difference() // this diff is just to pop the top off the pipework by uncommenting the big cubes at the end
	{
		union()
		{
			translate([0, y4, 56])
			FanFixture();

			// Fan mount
			translate([0, y4, 45])
			FanDuct();
			/*
			hull()
			{
				translate([0, -36, 55])
				cylinder(r=19, h=1);

				translate([0, -52.5, 45-j])
				cube([20, 20, j], center=true);
			}
			*/

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

		// These will open the pipes for inspection
		//translate([-100, -100, 0]) cube([200, 200, 200]);
		//translate([-200, -100, 0]) cube([200, 200, 200]);

	}
}


if(part == "all")
{
	%JHead();
	%XCarriage();
	AirHead();

	translate([0, -13.5-2, 63])
	union()
	{
		//CarriageFixture();
	}
}

if(part == "duct")
{
	translate([0, 0, 60])
	rotate([90, 0, 0])
	AirHead();
}