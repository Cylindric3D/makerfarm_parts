// Panel thickness
t=6.35;

// Jitter
j=1;

hole_diameter=10;
ring_diameter=9;
ring_offset=80;

printer_top_width=48.5;

mode="demo"; //[demo | print]


if(mode=="demo")
{
	// sample 3mm filament
	%color([1, 0, 0]) translate([0, -80, 0]) cylinder(r=1.5, h=100, $fn=30, center=true);

	// top of printer
	%translate([-100, 0, -t])
	union()
	{
		color([150/255, 121/255, 32/255]) translate([0, t, 0]) cube([200, printer_top_width-t, t]);
		color([181/255, 148/255, 51/255]) translate([0, 0, -49.6+t]) cube([200, t, 49.5]);
	}

	mount();
}

if(mode=="print")
{
	translate([0, 0, t]) rotate([0, 180, 0]) mount();
	translate([hole_diameter+ring_diameter, 0, 0]) rotate([0, 180, 0]) SemiGuide();
}

module mount()
{
	// Top Support
	translate([-5, -ring_offset+(hole_diameter/2)+(ring_diameter/2), 0]) cube([10, printer_top_width+ring_offset-((hole_diameter/2)+(ring_diameter/2))+4, 4]);

	// Front Support
	translate([-5, -4, -20]) cube([10, 4, 20+j]);

	// Front Arch
	arch_length=ring_offset-((hole_diameter/2)+(ring_diameter/2));
	arch_height=20;

	translate([-2, -ring_offset+((hole_diameter/2)+(ring_diameter/2))+j-4, -20+j]) 
	difference()
	{
		cube([4, arch_length, arch_height]);
		scale([1, arch_length/arch_height, 1]) translate([-j, 0, 0]) rotate([0, 90, 0]) cylinder(r=arch_height, h=j+4+j);
	}

	// Back Support
	translate([-5,  printer_top_width, -10]) cube([10, 4, 10+j]);

	// Guide
	translate([0, -ring_offset, 4]) SemiGuide();

	if(mode=="demo")
	{
		translate([0, -ring_offset, 4]) 
		rotate([0, 180, (360/21)*0.5]) 
		SemiGuide();
	}
}


module SemiGuide()
{
	intersection()
	{
		rotate_extrude(convexity = 10, $fn=21)
		translate([hole_diameter/2+ring_diameter/2, 0, 0])
		circle(r = ring_diameter/2, $fn=23);
		
		translate([0,0,-ring_diameter/4-j]) 
		cube([hole_diameter+2*ring_diameter+j+j, hole_diameter+2*ring_diameter+j+j, ring_diameter/2+j+j], center=true);
	}
}