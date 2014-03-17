use <x_side.scad>

// Cut hole for a servo - useful for auto-z-levelling
// Specify the dimensions of the servo hole
servo_width=23.5;  // Width of cutout for servo
servo_height=12.5; // Height of cutout for servo
servo_bolt_size=3; // Diameter of bolt shaft

// Jitter. This should be much less than one layer height.
j=0.05;


// Side panel with the various holes cut out
module XSideServoMount()
{
	difference()
	{
		// Main body
		XSidePlate();

		// Servo hole
		translate([22.5, -14.25, PanelThickness()/2]) 
		ServoHoleFormer();
	}
}


module ServoHoleFormer()
{
	cube([servo_width, servo_height, PanelThickness()+j+j], true);

	translate([servo_width/2 + servo_bolt_size/2 +1, 0, 0])
	cylinder(h=PanelThickness()+j+j, r=servo_bolt_size/2, $fn=30, center=true);

	translate([-servo_width/2 - servo_bolt_size/2-1, 0, 0])
	cylinder(h=PanelThickness()+j+j, r=servo_bolt_size/2, $fn=30, center=true);
}



XSideServoMount();
