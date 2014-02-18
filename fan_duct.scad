use <lib/shapes.scad>
use <lib/polyholes.scad>
use <lib/fans.scad>
use <lib/jhead.scad>
use <lib/makerfarm_parts.scad>

// Distance from mounting-holes to Z-zero
ZPrime=62;

// radius around the hot-end
r_vent=25;


// Thickness of the structure walls
t=2;

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

bracket_thickness=3;
bracket_angle=45;

// Part to show
part="bracket"; // all, duct, bracket, gasket

// Debugging slices
debug_slice=0;
debug_layer_height=1;


module AirHead()
{
	distance_from_head=10;
	distance_from_ground=2;
	nozzle_width=20;
	nozzle_height=10;
	corners=2;
	
	w1=nozzle_width;
	h1=nozzle_height;
	w2=nozzle_width-t*2;
	h2=nozzle_height-t*2;
	
	color("maroon")
	translate([0, -20, 0])
	difference()
	{
		union()
		{
			// bracket-end
			translate([0, -9, 13])
			rotate([bracket_angle, 0, 0])
			FanMountPlate(size=fan_size, thickness=bracket_thickness, traps=true);
			
			hull()
			{
				// Conic part
				translate([0, -9, 13])
				rotate([bracket_angle, 0, 0])
				cylinder(r=fan_size/2, h=j, $fn=detail);

				// Nozzle
				translate([0, 8-distance_from_head, -10+nozzle_height/2+distance_from_ground])
				rotate([55, 0, 0])
				hull()
				{
					translate([-w1/2+corners, h1/2-corners, 0]) sphere(r=corners, h=5, $fn=detail);
					translate([ w1/2-corners, h1/2-corners, 0]) sphere(r=corners, h=5, $fn=detail);
					translate([w1/2-corners, -h1/2+corners, 0]) sphere(r=corners, h=5, $fn=detail);
					translate([-w1/2+corners, -h1/2+corners, 0]) sphere(r=corners, h=5, $fn=detail);
				}
			}

		}

		// Remove the conic part
		hull()
		{
			translate([0, -9, 13])
			rotate([bracket_angle, 0, 0])
			cylinder(r=fan_size/2-t, h=j*2);
		
			// Nozzle
			translate([0, 8-distance_from_head, -10+nozzle_height/2+distance_from_ground])
			rotate([55, 0, 0])
			hull()
			{
				translate([-w2/2+corners, h2/2-corners, 0]) cylinder(r=corners+j, h=5/2, center=false, $fn=detail);
				translate([ w2/2-corners, h2/2-corners, 0]) cylinder(r=corners+j, h=5/2, center=false, $fn=detail);
				translate([w2/2-corners, -h2/2+corners, 0]) cylinder(r=corners+j, h=5/2, center=false, $fn=detail);
				translate([-w2/2+corners, -h2/2+corners, 0]) cylinder(r=corners+j, h=5/2, center=false, $fn=detail);
			}
		}

		translate([0, 8-distance_from_head, -10+nozzle_height/2+distance_from_ground])
		rotate([55+180, 0, 0])
		hull()
		{
			translate([-w2/2+corners, h2/2-corners, -j]) cylinder(r=corners+j, h=5, $fn=detail);
			translate([ w2/2-corners, h2/2-corners, -j]) cylinder(r=corners+j, h=5, $fn=detail);
			translate([w2/2-corners, -h2/2+corners, -j]) cylinder(r=corners+j, h=5, $fn=detail);
			translate([-w2/2+corners, -h2/2+corners, -j]) cylinder(r=corners+j, h=5, $fn=detail);
		}
		

		//*DEBUG Slice across X*/translate([0,0,0]) rotate([90,0,0]) cylinder(r=100, h=100);
		//*DEBUG Slice across Y*/translate([0,0,0]) rotate([0,90,0]) cylinder(r=100, h=100);
		//*DEBUG Slice across Z*/translate([0,0,15]) cylinder(r=100, h=100);
	}
}


module FanBracket()
{
	Bracket(angle=bracket_angle, height=23);
}

module Gasket()
{
	color("black") FanMountPlate(size=fan_size, thickness=gasket_thickness);
}



if(part == "all")
{
	JHead();

	translate([0, -13.5, ZPrime-7]) // 7 is the distance from the bottom of the block to the centre of the holes
	%XCarriage();

	// The complete airhead rig
	translate([0, 2, ZPrime-7-10])
	union()
	{
		translate([0, -17, 0])
		union()
		{
			translate([0, 0, -bracket_thickness/2])
			FanBracket();

			rotate([bracket_angle, 0, 0])
			translate([0, -fan_size/2-4, gasket_thickness])
			Gasket();

			rotate([bracket_angle, 0, 0])
			translate([0, -fan_size/2-4, gasket_thickness])
			Fan(fan_size, fan_thickness);
		}
	}
	
	translate([0, 1, 11])
	AirHead();
}

if(part == "duct")
{
	difference()
	{
		translate([0, 0, 33])
		rotate([bracket_angle+90, 0, 0])
		AirHead();

		//*DEBUG Horizontal Slice*/translate([0, 0, 5]) cylinder(r=1000, h=1000, $fn=detail);
		//*DEBUG Vertical Slice*/translate([0, 0, 0]) rotate([0, 90, 0]) cylinder(r=1000, h=1000, $fn=detail);
	}
}

if(part == "bracket")
{
	translate([0, 0, t])
	rotate([-bracket_angle,0,0])
	FanBracket();
}

if(part == "gasket")
{
	Gasket();
}