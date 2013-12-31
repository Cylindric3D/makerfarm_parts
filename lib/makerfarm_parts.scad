// Jitter, used to prevent coincident-surface problems. Should be less than layer-thickness.
j=0.05;

module XCarriage()
{
	c=32;
	d=3;

	color("Khaki")
	difference()
	{
		translate([0, 15, 10]) cube([60, 30, 20], center=true);
		translate([c/2, -j, 7]) rotate([-90, 0, 0]) cylinder(r=d/2, h=20);
		translate([-c/2, -j, 7]) rotate([-90, 0, 0]) cylinder(r=d/2, h=20);
	}
}


XCarriage();
