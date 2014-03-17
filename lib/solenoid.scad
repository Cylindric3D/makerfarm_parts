X=0;Y=1;Z=2;

// Draw a solenoid of {size}
// {off} is the extension when not energised
// {on} is the extension when engergised
// {power} is the current power, between 0 and 1.
module Solenoid(size, off, on, power)
{
	thick = 1;
	rad = 0.5;
	gap = 0.2;

	position = -off+power*(off-on);

	translate(-[size[X]/2, size[Y]/2, 0])
	union()
	{
		color("lightgrey")
		union()
		{
			// Top left roundness
			translate([rad, 0, size[Z]-rad])
			rotate([-90, 0, 0])
			cylinder(h=size[Y], r=rad, $fn=20);

			// Top right roundness
			translate([size[X]-rad, 0, size[Z]-rad])
			rotate([-90, 0, 0])
			cylinder(h=size[Y], r=rad, $fn=20);

			// Top
			translate([rad, 0, size[Z]-thick])
			cube([size[X]-thick, size[Y], thick]);
	
			// Left
			cube([thick, size[Y], size[Z]-rad]);

			// Right
			translate([size[X]-thick, 0, 0])
			cube([thick, size[Y], size[Z]-rad]);

			// Bottom
			translate([thick+gap, 0, rad])
			cube([size[X]-thick*2-gap*2, size[Y], thick]);

			// Actuator (top)
			translate([size[X]/2, size[Y]/2, 0])
			cylinder(r=1.5, h=size[Z]+1, $fn=40);

			// Actuator (bottom)
			translate([size[X]/2, size[Y]/2, position])
			cylinder(r=2, h=size[Z], $fn=40);
		}

		// Spring clip
		color("black")
		translate([size[X]/2, size[Y]/2, position+1])
		cylinder(r=3.5, h=0.6, $fn=40);

		// Coil
		color("blue")
		translate([size[X]/2, size[Y]/2, rad+thick+gap])
		cylinder(h=size[Z]-rad-thick*2-gap*2, r=(size[X]-thick*2-gap*2)/2-gap, $fn=40);
	}
}

Solenoid([12, 11.5, 20.5], 8.1, 4.2, 0);


