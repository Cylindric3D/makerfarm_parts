use <nuts_and_bolts.scad>

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

function FanToBracketRotation(fan_size, angle) = [angle,0,0];
function FanToBracketTranslation(fan_size, angle) = [0,-fan_size/2-bracket_thickness, bracket_thickness/2];

bracket_thickness=3;


module Bracket(fan_size=40, angle=0)
{
	l=6;
	roundness=2;
	h1=13; // vertical height of the carriage-bracket

	color("SteelBlue")
	union()
	{

		// the bit the fan attaches to
		rotate([angle, 0, 0])
		translate([0, -fan_size/2-bracket_thickness, -bracket_thickness/2])
		union()
		{
			translate([-fan_size/2, fan_size/2-j, 0]) cube([fan_size, bracket_thickness+j, bracket_thickness]);
			FanMountPlate(size=fan_size, thickness=bracket_thickness, roundback=false);
		}

		// the hinge
		rotate([0, 90, 0])
		cylinder(h=fan_size, r=bracket_thickness/2, center=true);
		
		// the bit that attaches to the X-carriage
		translate([-fan_size/2, -bracket_thickness/2, 0])
		difference()
		{
			hull()
			{
				cube([fan_size, bracket_thickness, j]);
				translate([roundness, 0, h1-roundness]) rotate([270, 0, 0]) cylinder(r=roundness, h=bracket_thickness);
				translate([fan_size-roundness, 0, h1-roundness]) rotate([270, 0, 0]) cylinder(r=roundness, h=bracket_thickness);
			}

			// Backplate holes
			translate([fan_size/2-16, -j, h1-4]) rotate([270, 0, 0]) cylinder(r=1.5, h=bracket_thickness+j*2);
			translate([fan_size/2+16, -j, h1-4]) rotate([270, 0, 0]) cylinder(r=1.5, h=bracket_thickness+j*2);
		}
	}
}


//color("blue") translate([0, 0, 20]) !FanMountPlate(size=40, thickness=1, traps=true, roundback=false, bighole=true);
//Fan(40);


//translate([-90, 0, 0]) union(){ Bracket(fan_size=40, angle=90, $fn=40); rotate(FanToBracketRotation(40, 90)) Fan(fan_size=40);}
//translate([-45, 0, 0]) Bracket(fan_size=40, angle=67.5, $fn=40);

n=4;
for(i=[0:n])
{
	translate([-45*n/2+(45*i), 0, 0]) 
	union()
	{ 
		Bracket(fan_size=40, angle=90-(90/n)*i, $fn=40); 
	
		rotate(FanToBracketRotation(fan_size=40, angle=90-(90/n)*i)) 
		translate(FanToBracketTranslation(fan_size=40, angle=90-(90/n)*i)) 
		%Fan(fan_size=40);
	}
}

//translate([ 45, 0, 0]) Bracket(fan_size=40, angle=22.5, $fn=40);
//translate([ 90, 0, 0]) Bracket(fan_size=40, angle=0, $fn=40);
