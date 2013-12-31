module JHead()
{
	d=14; // diameter
	
	color("Gold")
	union()
	{
		translate([0, 0, 2]) cylinder(r=d/2, h=61);
		translate([0, 0, 4+2]) cube([d, d, 8], center=true);
		translate([0, 0, 0]) cylinder(r1=0, r2=d/2, h=2);
	}
}

