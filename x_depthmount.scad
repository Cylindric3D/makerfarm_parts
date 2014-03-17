use <x_side.scad>
include <lib/DepthGauge.scad>

// Jitter. This should be much less than one layer height.
j=0.05;


// Side panel with the various holes cut out
module XSideDepthMount()
{
	translate([0, 0, PanelThickness()])
	rotate([180, 0, 0])
	difference()
	{
		scale([1, -1, 1])
		XSidePlate();

		translate([45-dg_width+2, 1, -j])
		cube([dg_width+j, 24.2, PanelThickness()+j+j]);
	}
	
	translate([45, -13.1, 0])
	DepthGaugeMountBlock();
}


module DepthGaugeMountBlock()
{
	// Margin around the actual bracket
	m=2;

	// Tolerance for the bracket cutout
	tol=0.2;

	// Size of the slot
	slot_size=0;
	
	difference()
	{
		translate([-dg_length-m, -dg_width/2-m, 0])
		cube([dg_length+m, dg_width+m*2, PanelThickness()]);

		translate([0, 0, dg_thickness]) 
		minkowski()
		{
			DepthGauge_MountBlock(pin=false);
			sphere(r=tol);
		}
	}

	translate([-dg_pin_centre, 0, dg_thickness/2])
	difference()
	{
		union()
		{	
			// Stalk
			translate([0,0,-tol-j]) cylinder(r=dg_pin_radius-tol/2, h=dg_thickness+tol+j, $fn=30);

			// Cap
			translate([0, 0, dg_thickness-j]) 
			sphere(r=dg_pin_radius-tol/2, $fn=30);
		}
	
		if(slot_size > 0)
		{
			translate([-slot_size/2, -dg_pin_radius, 0]) 
			cube([slot_size, dg_pin_radius*2, dg_thickness*2]);
		}
	}

}

XSideDepthMount();
