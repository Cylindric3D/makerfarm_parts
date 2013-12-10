j=1;
$fn=30;

hinge_bolt=3; // Bolt diameter
hinge_slack=0.2;

module PiCam(ribbon=true, extend_holes=true)
{
	// PCB
	color([0.2,0.5,0])
	difference()
	{
		cube([25.1, 23.9, 2]);
		translate([2, 9.3, -j])cylinder(r=1, h=3+j+j);
		translate([2, 21.9, -j])cylinder(r=1, h=3+j+j);
		translate([23.1, 9.3, -j])cylinder(r=1, h=3+j+j);
		translate([23.1, 21.9, -j])cylinder(r=1, h=3+j+j);
	}
	if(extend_holes)
	{
		translate([2, 9.3, -10])cylinder(r=1, h=20);
		translate([2, 21.9, -10])cylinder(r=1, h=20);
		translate([23.1, 9.3, -10])cylinder(r=1, h=20);
		translate([23.1, 21.9, -10])cylinder(r=1, h=20);
	}
	
	// Camera
	color([0.3, 0.3, 0.3]) translate([8.6, 5.8, 2]) cube([8, 8, 3.5]);
	color([0.2, 0.2, 0.2]) translate([12.6, 9.8, 2]) cylinder(r=5.5/2, h=5.4);

	// Ribbon connector
	color([0.5, 0.5, 0]) translate([(25.1-20.8)/2, 0, -2.8]) cube([20.8, 5.8, 2.8]);
	
	// Ribbon
	if(ribbon)
	{
		translate([(25.1-16)/2, -100, -1]) cube([16, 100, 0.15]);
	}
	
}



!PiCam();

module Claw()
{
	translate([hinge_bolt*1.5, 0, 0])
	difference()
	{
		union()
		{
			cylinder(r=hinge_bolt, h=hinge_bolt-hinge_slack, center=true);
			translate([-hinge_bolt*0.75, 0, 0]) cube([hinge_bolt*1.5, hinge_bolt*2, hinge_bolt-hinge_slack], center=true);
		}
		cylinder(r=hinge_bolt/2, h=hinge_bolt-hinge_slack+j+j, center=true);
	}
}

module ClawFemale()
{
	color([0.3, 0.5, 0])
	{
		translate([-6, 0, 0]) rotate([0, 270, 0]) Claw();
		rotate([0, 270, 0]) Claw();
		translate([6, 0, 0]) rotate([0, 270, 0]) Claw();
	}
}

module ClawMale()
{
	color([0.4, 0.7, 0])
	{
		translate([-3, 0, 0]) rotate([0, 270, 0]) Claw();
		translate([3, 0, 0]) rotate([0, 270, 0]) Claw();
	}
}

module Stand()
{
	translate([-10, -hinge_bolt, 0]) cube([20, hinge_bolt*2, 100]);
	translate([0, 0, 100]) ClawFemale();
}

module Top()
{
	translate([-15, 0, -hinge_bolt]) cube([30, 30, 10]);
	rotate([90, 0, 0]) ClawMale();
}

translate([0, -100-hinge_bolt*1.5, 0])
rotate([-90, 0, 0]) Stand();

translate([0, hinge_bolt*1.5, 0])
Top();