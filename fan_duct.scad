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

airhead_height=29;

gasket_thickness=0.3;

// Part to show
part="duct"; // all, duct, bracket, gasket

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
	hmain=airhead_height;
	rmajor=23;
	rminor=15;
	holes=20;
	
	union()
	{
		// Top is the fan-mounting plate
		translate([0, -40, 19])
		union()
		{
			// The square block that joins to the fan
			difference()
			{
				FanMountPlate(size=40, thickness=10, traps=true, roundback=false, bighole=false);

				// Make the fan mount holes deeper
				translate([0, 0, 2]) FanMountPlateHoles(size=40, thickness=10, traps=true, bighole=false);
				translate([0, 0, 4]) FanMountPlateHoles(size=40, thickness=10, traps=true, bighole=false);
				translate([0, 0, 6]) FanMountPlateHoles(size=40, thickness=10, traps=true, bighole=false);

				translate([0, 0, t]) cylinder(r=16, h=10+j*2);
				translate([-10, 10, t]) cube([20, 20, 10-t*2]);
			}

			// Bridge support
			translate([-t/2, 16, t]) cube([t, 5, 10-t*2]);
			
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

		difference()
		{
		
			union()
			{
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
				}

				// Bridging supports near holes
				translate([0, 0, 3+t])
				TorusChamfer(rminor+t, rmajor-t);
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

			///*DEBUG*/translate([0, 0, 12]) cylinder(r=1000, h=1000, $fn=detail);
		}

	}
}


// r1 is the inner radius
// r2 is the outer radius
module TorusChamfer(r1, r2)
{
	xsection=(r2-r1);
	centre=r1+xsection;
	
	//#cylinder(r=r1, h=1000);
	//#rotate([180, 0, 0]) cylinder(r=r2, h=1000);
	
	difference()
	{
		cylinder(r=r2, h=xsection);

		cylinder(r=r1, h=xsection*2+j*2, center=true);
		
		translate([0, 0, xsection])
		rotate_extrude(convexity = 10, $fn=detail)
		translate([r2, 0, 0])
		circle(r = xsection, $fn=detail);
	}
}

module Gasket()
{
	color("black") FanMountPlate(size=fan_size, thickness=gasket_thickness);
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
		JHead();
	
		translate([0, -13.5, ZPrime-7]) // 7 is the distance from the bottom of the block to the centre of the holes
		%XCarriage();

	// The complete airhead rig
	translate([0, 0, ZPrime-7])
	union()
	{
		translate([0, -60, 0])
		Bracket();

		translate([0, -40, -gasket_thickness])
		Gasket();

		translate([0, -40, -gasket_thickness-fan_thickness])
		%Fan(fan_size, fan_thickness);
		
		translate([0, -40, -gasket_thickness-fan_thickness-gasket_thickness])
		Gasket();

		translate([0, 0, -gasket_thickness-fan_thickness-gasket_thickness-airhead_height])
		AirHead();
	}
	

}

if(part == "duct")
{
	difference()
	{
		translate([0, 0, 32])
		rotate([180, 0, 0])
		AirHead();

		///*DEBUG Horizontal Slice*/translate([0, 0, 5]) cylinder(r=1000, h=1000, $fn=detail);
		///*DEBUG Vertical Slice*/translate([0, 0, 0]) rotate([0, 90, 0]) cylinder(r=1000, h=1000, $fn=detail);
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

if(part == "gasket")
{
	Gasket();
}