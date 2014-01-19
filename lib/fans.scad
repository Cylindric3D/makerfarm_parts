use <MCAD/nuts_and_bolts.scad>

j=0.1;

module Fan(size=40, thickness=20)
{
	width=size;
	holes=size-8;
	roundness=3;

	difference()
	{
		hull()
		{
			translate([-width/2+roundness, -width/2+roundness, 0]) cylinder(r=roundness, h=thickness);
			translate([-width/2+roundness,  width/2-roundness, 0]) cylinder(r=roundness, h=thickness);
			translate([ width/2-roundness, -width/2+roundness, 0]) cylinder(r=roundness, h=thickness);	
			translate([ width/2-roundness,  width/2-roundness, 0]) cylinder(r=roundness, h=thickness);
		}

		// screw holes
		translate([-holes/2, -holes/2, -j]) cylinder(r=1.75, h=thickness+j*2);
		translate([-holes/2,  holes/2, -j]) cylinder(r=1.75, h=thickness+j*2);
		translate([ holes/2, -holes/2, -j]) cylinder(r=1.75, h=thickness+j*2);	
		translate([ holes/2,  holes/2, -j]) cylinder(r=1.75, h=thickness+j*2);
	}
}


module FanMountPlateHoles(size=40, thickness=2, traps=false, bighole=true)
{
	width=size;
	holes=size-8;
	roundness=3;
	hole=size-4;

	trap_depth=max(0, 2.4-thickness+1);

	// main hole
	if(bighole)
	{
		translate([0, 0, -j]) cylinder(r=hole/2, h=thickness+j*2);
	}

	// screw holes
	translate([-holes/2, -holes/2, -j]) cylinder(r=1.75, h=thickness+j*2);
	translate([-holes/2,  holes/2, -j]) cylinder(r=1.75, h=thickness+j*2);
	translate([ holes/2, -holes/2, -j]) cylinder(r=1.75, h=thickness+j*2);	
	translate([ holes/2,  holes/2, -j]) cylinder(r=1.75, h=thickness+j*2);

	// nut traps
	if(traps)
	{
		translate([-holes/2, -holes/2, -trap_depth-j]) nutHole(3);
		translate([-holes/2,  holes/2, -trap_depth-j]) nutHole(3);
		translate([ holes/2, -holes/2, -trap_depth-j]) nutHole(3);
		translate([ holes/2,  holes/2, -trap_depth-j]) nutHole(3);
	}
}


module FanMountPlate(size=40, thickness=2, traps=false, roundback=true, bighole=true)
{
	width=size;
	holes=size-8;
	roundness=3;
	hole=size-4;

	difference()
	{
		// main body
		union()
		{
			translate([-width/2+roundness, -width/2, 0]) cube([width-roundness*2, width, thickness]);
			translate([-width/2, -width/2+roundness, 0]) cube([width, width-roundness*2, thickness]);
			if(roundback)
			{
				translate([ width/2-roundness,  width/2-roundness, 0]) cylinder(r=roundness, h=thickness, $fn=30);
				translate([-width/2+roundness,  width/2-roundness, 0]) cylinder(r=roundness, h=thickness, $fn=30);
			} else {
				translate([-width/2, width/2-roundness-j, 0]) cube([width, roundness+j, thickness]);
			}
			translate([-width/2+roundness, -width/2+roundness, 0]) cylinder(r=roundness, h=thickness, $fn=30);
			translate([ width/2-roundness, -width/2+roundness, 0]) cylinder(r=roundness, h=thickness, $fn=30);	
		}

		FanMountPlateHoles(size, thickness, traps, bighole);
	}
}

color("blue") translate([0, 0, 20]) !FanMountPlate(size=40, thickness=1, traps=true, roundback=false, bighole=true);
Fan(40);
