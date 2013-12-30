j=0.1;

module Fan(size=40)
{
	width=size;
	thickness=size/2;
	holes=32;

	difference()
	{
		hull()
		{
			translate([-width/2+3, -width/2+3, 0]) cylinder(r=3, h=thickness);
			translate([-width/2+3, width/2-3, 0]) cylinder(r=3, h=thickness);
			translate([width/2-3, -width/2+3, 0]) cylinder(r=3, h=thickness);	
			translate([width/2-3, width/2-3, 0]) cylinder(r=3, h=thickness);
		}

		translate([-holes/2+6, -holes/2+6, -j]) cylinder(r=1.75, h=thickness+j*2);
		translate([-holes/2+6, holes/2-6, -j]) cylinder(r=1.75, h=thickness+j*2);
		translate([holes/2-6, -holes/2+6, -j]) cylinder(r=1.75, h=thickness+j*2);	
		translate([holes/2-6, holes/2-6, -j]) cylinder(r=1.75, h=thickness+j*2);
	}
}

Fan(40);