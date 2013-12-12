use <lib/pibox.scad>

// Hole radius
r_hole=1;

// Structural thickness
t=1;

// Distance from panel to camera (min is ~13mm)
camera_offset=80;

// Fixing bolt radius
fix_bolt=1.5;

// Panel thickness
p=6.5;

// Panel angle
a=21.8;

// Jitter
j=0.1;


/* [Hidden] */
w=max(8, camera_offset-13);
h=23.95-2;


module PiCamMount()
{
	union()
	{
		difference()
		{
			// Brackets
			union()
			{
				translate([-w-p-t*2, 0, t]) cube([t*2, h, 11.56+p]);
				translate([-w-t*2, 0, t]) cube([t*2, h, 11.56+p]);
			}

			// Fixing holes
			translate([-w-p-t*2-j, t*5, t*5]) rotate([0, 90, 0]) cylinder(r=fix_bolt, h=p+t*2+j*2, $fn=30);
		}

		// Angle Support
		translate([-w-p, h-t, t]) cube([p, t, tan(a)*h]);

		// Supports
		translate([-w, h-t, t]) cube([25.1+3+w, t, 1]); // top
		translate([-w-p-t*2, 0, t]) cube([25.1+3+w+p+t*2, t, 1]); //bottom
		translate([25.1+3-t, 0, t]) cube([t, h, 1]); //right

		// Reinforce the big hole
		if(w > 10)
		{
			hull()
			{
				translate([-w+t*3, t*3, 0]) cube([t*2, t*2, t]); // diagonal
				translate([-t*4, h-t*4, 0]) cube([t*2, t*2, t]); // diagonal
			}
			hull()
			{
				translate([-w+t*3, h-t*4, 0]) cube([t*2, t*2, t]); // diagonal 2
				translate([-t*4, t*3, 0]) cube([t*2, t*2, t]); // diagonal 2
			}
		}

		difference()
		{
			union()
			{
				// Base plate
				translate([-w-p-t*2, 0, 0]) cube([25.1+3+w+p+t*2, h, t]);

				// Hole reinforcers and pi-spacer
				translate([2, 9.3-4, 0]) cylinder(r=r_hole*3, h=t*4, $fn=30);
				translate([2, 21.9-4, 0]) cylinder(r=r_hole*3, h=t*4, $fn=30);
				translate([23.1, 9.3-4, 0]) cylinder(r=r_hole*3, h=t*4, $fn=30);
				translate([23.1, 21.9-4, 0]) cylinder(r=r_hole*3, h=t*4, $fn=30);
			}

			// Thin out the base
			if(w > 10)
			{
				translate([-w+t*3, t*3, -j]) cube([w-t*6, h-t*6, t+j*2]);
			}
			translate([2+r_hole+t*3, t*3, -j]) cube([23.1-2-r_hole*2-t*6, h-t*6, t+j*2]);

			// PiCam Holes
			union()
			{
				translate([2, 9.3-4, -10]) cylinder(r=r_hole, h=20, $fn=30);
				translate([2, 21.9-4, -10]) cylinder(r=r_hole, h=20, $fn=30);
				translate([23.1, 9.3-4, -10]) cylinder(r=r_hole, h=20, $fn=30);
				translate([23.1, 21.9-4, -10]) cylinder(r=r_hole, h=20, $fn=30);
			}
		}
	}
}


//%translate([0, -4, 5]) PiCam();
PiCamMount();