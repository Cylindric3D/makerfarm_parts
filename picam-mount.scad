use <lib/pibox.scad>

// Hole radius
r_hole=1;

// Structural thickness
t=1;

// Distance from panel to camera (min is ~13mm)
camera_offset=80;

// Panel thickness
p=6.35;

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
		// Bracket
		translate([-w-p-t, 0, t]) cube([t, h, 11.56+p]);
		translate([-w-t, 0, t]) cube([t, h, 11.56+p]);

		// Angle Support
		translate([-w-p, h-t, t]) cube([p, t, tan(a)*h]);

		// Support
		translate([-w, h-t, t]) cube([25.1+3+w, t, 1]);
		translate([-w, 0, t]) cube([25.1+3+w, t, 1]);

		// Base
		difference()
		{
			union()
			{
				translate([-w-p-t, 0, 0]) cube([25.1+3+w+p+t, h, t]);
				translate([2, 9.3-4, 0]) cylinder(r=r_hole*2, h=t*3, $fn=30);
				translate([2, 21.9-4, 0]) cylinder(r=r_hole*2, h=t*3, $fn=30);
				translate([23.1, 9.3-4, 0]) cylinder(r=r_hole*2, h=t*3, $fn=30);
				translate([23.1, 21.9-4, 0]) cylinder(r=r_hole*2, h=t*3, $fn=30);
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


%translate([0, -4, 5]) PiCam();
PiCamMount();