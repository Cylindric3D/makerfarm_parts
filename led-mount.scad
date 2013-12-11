use <x-side.scad>;

accessory_bolt_size=2;
accessory_hole_centres=15;

// Panel thickness
t=6.35;

// Jitter
j=1;




%translate([30, 25, 29]) rotate([270, 0, 270]) SidePanel();


union()
{
	translate([-30, 0, 0])
	difference()
	{
		// Main body
		union()
		{
			translate([55, 0, 0]) cube([5, 25, t]); // nearest clamp
			translate([50, 5, 0]) cube([5+j, 20, t]);
			translate([55, 5, 0]) cylinder(r=5, h=t, $fn=30); // front rounding
			translate([5, 20, 0]) cube([45+j, 5, t]); // back
			
			difference()
			{
				translate([45, 15, 0]) cube([5+j, 5+j, t]); 
				translate([45, 15, -j]) cylinder(r=5, h=t+j+j, $fn=30);
			}

		}
		
		// Accessory mount holes
		#translate([52, 20, 2.5])
		rotate([0, 90, 0])
		cylinder(h=10, r=accessory_bolt_size/2, $fn=30);
		
		#translate([52, 20-accessory_hole_centres, 2.5])
		rotate([0, 90, 0])
		cylinder(h=10, r=accessory_bolt_size/2, $fn=30);
	}
	
	%translate([-12, 12, 0]) rotate([-30, -30, 0]) LED();
	%translate([0, 15, 0]) rotate([-30, 0, 0]) LED();
	%translate([12, 12, 0]) rotate([-30, 30, 0]) LED();
	%translate([15, 0, 0]) rotate([0, 30, 0]) LED();
}

module LED()
{
	color([0.8, 0.8, 0.8])
	union()
	{
		cylinder(r=2.5, h=10, $fn=30);
		sphere(r=2.5, $fn=30);
	}
}