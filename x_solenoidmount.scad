use <x_side.scad>
use <lib/solenoid.scad>


show_solenoid=1;

t=2;

solenoid_size=[12, 11.5, 20.5];

// Jitter. This should be much less than one layer height.
j=0.05;
X=0;Y=1;Z=2;


// Side panel with the various holes cut out
module XSideSolenoidMount()
{
	difference()
	{
		union()
		{
			// Main body
			scale([-1, 1, 1])
			XSidePlate();

			// Support for the Solenoid
			translate([-29, -41, 0])
			cube([16, 20, solenoid_size[Y]+PanelThickness()/2+t]);
		}
	
		// Support for the Solenoid
		translate([-29+t, -41+t, PanelThickness()/2])
		cube([solenoid_size[X], solenoid_size[Z], solenoid_size[Y]+t+j]);

		// Hole for the actuator
		translate([-29+t+solenoid_size[X]/2-2.5, -41-j, PanelThickness()/2+t])
		cube([5, t+j*2, 15]);
		
	}
	if(show_solenoid)
	{
		translate([-21, -39, solenoid_size[Y]/2+PanelThickness()-PanelThickness()/2])
		rotate([-90, 0, 0]) 
		%Solenoid(solenoid_size, 8.1, 4.2, 0);
	}
}


XSideSolenoidMount();

