// Distance from the back-plate to the far outer point of the mounting bracket
dg_length=18.8;

// Width of the mounting bracket at the widest point, including flange
dg_width=22;

// Thickness of the mounting bracket
dg_thickness=5;

// Distance from the back-plate to the near-edge of the mounting hole
dg_pin_centre=10.62;

// Diameter of the mounting hole
dg_pin_radius=3.29;


// Jitter. This should be much less than one layer height.
j=0.05;



module DepthGauge_MountBlock(pin=true)
{
	// Width of the mounting bracket at the flange
	unflanged_width=16.42;

	difference()
	{
		// Main body of the bracket
		union()
		{

			// Rounded end of main body of the bracket
			translate([-dg_pin_centre, 0, 0])
			cylinder(r=unflanged_width/2, h=dg_thickness, center=true, $fn=30);

			// Square end of main body of the bracket
			translate([0, 0, -dg_thickness/2])
			linear_extrude(height=dg_thickness) 
			polygon(points=[
				[0, -dg_width/2], // bottom-right, by flange
				[0, dg_width/2], // top-right, by flange
				[-3, unflanged_width/2], // top-right, by straight off flange
				[-dg_pin_centre, unflanged_width/2], // top middle, by hole
				[-dg_pin_centre, -unflanged_width/2], // bottom middle, by hole
				[-3, -unflanged_width/2] // bottom-right, by straight off flange
			]);
		}

		if(pin==true)
		{
			// Hole
			translate([-dg_pin_centre, 0, 0])
			cylinder(r=dg_pin_radius, h=dg_thickness+j*2, center=true, $fn=30);
		}
	}
}

//DepthGauge_MountBlock(false);