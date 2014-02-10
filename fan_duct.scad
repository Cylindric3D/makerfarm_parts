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

bracket_thickness=3;
bracket_angle=45;

jet_count=16;
jet_size=5;

// Part to show
part="all"; // all, duct, bracket, gasket

// Debugging slices
debug_slice=0;
debug_layer_height=1;


module AirHead()
{
	torus_sides=8;
	torus_facets=6;
	
	color("maroon")
	difference()
	{
		union()
		{
			translate([0, -43.5, 0])
			rotate([bracket_angle, 0, 0]) 
			translate([0, fan_size/2, 0])
			union()
			{
				FanMountPlate(size=fan_size, thickness=t*2, traps=true);
				
				translate([0,0,-15])
				cylinder(r1=fan_size/5, r2=fan_size/2, h=15+t);
			}

			// main ring
			translate([0, 0, 8.5])
			torus2(30, 40, sides=torus_sides, facets=torus_facets);

		}
		
		// hollow out the ball-joint
		intersection()
		{
			translate([0, -43.5, 0])
			rotate([bracket_angle, 0, 0]) 
			translate([0, fan_size/2, -15+t])
			union()
			{
				cylinder(r1=fan_size/5-t, r2=fan_size/2-t, h=15+j);
				translate([0,0,15-j])cylinder(r=fan_size/2-t, h=15);
			}

			translate([0, 0, t])
			cylinder(r=100, h=100, $fn=5);
		}

		// hollow out the torus
		intersection()
		{
			translate([0, 0, 8.9])
			torus2(30+t*2, 40-t*4, sides=torus_sides, facets=torus_facets);

			translate([0, 0, t*4])
			cylinder(r=100, h=100, $fn=5);
		}
		
		// level off the bottom
		rotate([180,0,0])
		cylinder(r=100, h=100, $fn=5);
		
		// Nozzles
		for(i=[0:jet_count])
		{
			rotate([0, 0, (360/jet_count)*i])
			translate([27, 0, t*5]) 
			rotate([180,30,0])
			cylinder(r=jet_size/2, h=30);
		}

		//*DEBUG Horizontal slice*/translate([0,0,15]) cylinder(r=100, h=100);
		//*DEBUG Vertical slice*/translate([0,0,0]) rotate([90,0,0]) cylinder(r=100, h=100);
	}
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
	translate([0, 2, ZPrime-7])
	union()
	{
		translate([0, -17, 0])
		union()
		{
			translate([0, 0, -bracket_thickness/2])
			Bracket(angle=bracket_angle, height=13);

			rotate([bracket_angle, 0, 0])
			translate([0, -fan_size/2-4, gasket_thickness])
			Gasket();

			rotate([bracket_angle, 0, 0])
			translate([0, -fan_size/2-4, gasket_thickness])
			Fan(fan_size, fan_thickness);
		}
	}
	
	translate([0, 1, 21])
	AirHead();
}

if(part == "duct")
{
	difference()
	{
		AirHead();

		//*DEBUG Horizontal Slice*/translate([0, 0, 5]) cylinder(r=1000, h=1000, $fn=detail);
		//*DEBUG Vertical Slice*/translate([0, 0, 0]) rotate([0, 90, 0]) cylinder(r=1000, h=1000, $fn=detail);
	}
}

if(part == "bracket")
{
	translate([0, 0, t])
	rotate([-bracket_angle,0,0])
	Bracket(angle=bracket_angle, height=13);
}

if(part == "gasket")
{
	Gasket();
}