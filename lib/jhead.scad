module JHead()
{
	d=14; // diameter
	
	color("Gold")
	union()
	{
		// main body
		translate([0, 0, 2]) cylinder(r=d/2, h=61);
		
		// square heater-block
		translate([0, 0, 4+2])
		cube([d, d, 8], center=true);
		
		// nozzle
		translate([0, 0, 0]) cylinder(r1=0, r2=d/2, h=2);
	}

	// heater
	color("Silver")
	union()
	{
		translate([-3, -2, 6]) 
		rotate([90, 0, 0]) 
		cylinder(r=2.5, h=d*1.5, center=true);
	}
}

