include <lib/DepthGauge.scad>

 // Which side? Primarily for determining which side to make fancy
side="left";

// Cut hole for a servo - useful for auto-z-levelling
// Also specify the dimensions of the servo hole
servo_hole=false;
servo_width=23.5;  // Width of cutout for servo
servo_height=12.5; // Height of cutout for servo
servo_bolt_size=3; // Diameter of bolt shaft

// Cut the hole for the X end-stop screw
endstop_hole=false;

// Cut holes for a lower accessory
accessory_holes=false;
accessory_bolt_size=2;
accessory_hole_centres=15;

// Depth Gauge Mount
depth_gauge=true;

// Fancy the shape up a bit?
fancy=false;
fancy_border_size=1;
fancy_border_inset=0.75;


// Panel thickness
t=6.35;

// Jitter. This should be much less than one layer height.
j=0.05;



// Side panel with the various holes cut out
module SidePanel()
{
	translate([0, 0, t])
	rotate([180, 0, 0])
	difference()
	{
		SidePanelBody();

		// Main mounting bolt hole
		translate([22.05, -2.9, -j]) 
		cylinder(h=t+j+j, r=2, $fn=30);

		// X Endstop bolt hole
		if(endstop_hole) {
			translate([17.9, 13.3, -j])
			cylinder(h=t+j+j, r=1.5,$fn=30);
		}

		// Servo hole
		if(servo_hole) {
			translate([22.5, 14.25, t/2]) 
			ServoHoleFormer();
		}
		
		// Accessory holes
		if(accessory_holes)
		{
			translate([5, 28.5-accessory_bolt_size/2-fancy_border_size, -j])
			cylinder(h=t+j+j, r=accessory_bolt_size/2, $fn=30);

			translate([5+accessory_hole_centres, 28.5-accessory_bolt_size/2-fancy_border_size, -j])
			cylinder(h=t+j+j, r=accessory_bolt_size/2, $fn=30);
		}

		// Take out the space where the depth-gauge mount will go
		if(depth_gauge)
		{
			translate([45-dg_width+2, 1, -j])
			cube([dg_width+j, 24.2, t+j+j]);
		}
	}
	
	if(depth_gauge)
	{
		color([0.8,0.2,0.2])
		translate([45, -13.1, 0])
		DepthGaugeMountBlock();
	}
}


module DepthGaugeMountBlock()
{
	// Margin around the actual bracket
	m=2;

	// Tolerance for the bracket cutout
	tol=0.2;

	// Size of the slot
	slot_size=0;
	
	difference()
	{
		translate([-dg_length-m, -dg_width/2-m, 0])
		cube([dg_length+m, dg_width+m*2, t]);

		translate([0, 0, dg_thickness]) 
		minkowski()
		{
			DepthGauge_MountBlock(pin=false);
			sphere(r=tol);
		}
	}

	translate([-dg_pin_centre, 0, dg_thickness/2])
	difference()
	{
		union()
		{	
			// Stalk
			translate([0,0,-tol-j]) cylinder(r=dg_pin_radius-tol/2, h=dg_thickness+tol+j, $fn=30);

			// Cap
			translate([0, 0, dg_thickness-j]) 
			sphere(r=dg_pin_radius-tol/2, $fn=30);
		}
	
		if(slot_size > 0)
		{
			translate([-slot_size/2, -dg_pin_radius, 0]) 
			cube([slot_size, dg_pin_radius*2, dg_thickness*2]);
		}
	}

}

module FancyFormer()
{
	b=fancy_border_size;
	d=fancy_border_inset;
	
	difference()
	{
		translate([0, 0, -d])
		linear_extrude(height=2*d) 
		polygon(points=[
			[b, b],              // 0
			[12.2+b, b],         // 1
			[12.2+b, -5.8+b],    // 2
			[31.9-b, -5.8+b],    // 3
			[31.9-b, b],         // 4
			[45-b, b],           // 5
			[45-b, 19-(b*0.5)],  // 6
			[25-(b*0.5), 28.5-b],// 7
			[b, 28.5-b],         // 8
			[b, 22.5-b],         // 9
			[-6+b, 22.5-b],      //10
			[-6+b, 16.5+b],      //11
			[b, 16.5+b]          //12
		]);

		// Mount hole
		translate([22.05, -2.9, 0]) cylinder(h=d*2+j+j, r=2+b, $fn=30, center=true);

		// End-stop hole
		if(endstop_hole)
		{
			translate([17.9, 13.3, 0])
			cylinder(h=d+j+j, r=1.5+b, $fn=30, center=true);
		}
		
		// Servo holes
		if(servo_hole)
		{
			translate([22.5, 14.25, t/2])
			union()
			{
				cube([servo_width+b+b, servo_height+b+b, t+j+j], true);
				translate([servo_width/2 + servo_bolt_size/2 +1, 0, 0])
				cylinder(h=t+j+j, r=servo_bolt_size/2+b, $fn=30, center=true);

				translate([-servo_width/2 - servo_bolt_size/2-1, 0, 0])
				cylinder(h=t+j+j, r=servo_bolt_size/2+b, $fn=30, center=true);
			}
		}
		
		// Accessory holes
		if(accessory_holes)
		{
			translate([5, 28.5-accessory_bolt_size/2-b, -j])
			cylinder(h=t+j+j, r=accessory_bolt_size/2+b, $fn=30);

			translate([5+accessory_hole_centres, 28.5-accessory_bolt_size/2-b, -j])
			cylinder(h=t+j+j, r=accessory_bolt_size/2+b, $fn=30);
		}

	}
}

// Main body of the side panel
module SidePanelBody()
{
	color([0.8,0.2,0.2])
	difference()
	{
		linear_extrude(height=t) 
		polygon(points=[
			[0, 0],       // 0
			[12.2, 0],    // 1
			[12.2, -5.8], // 2
			[31.9, -5.8], // 3
			[31.9, 0],    // 4
			[45, 0],      // 5
			[45, 19],     // 6
			[25, 28.5],   // 7
			[0, 28.5],    // 8
			[0, 22.5],    // 9
			[-6, 22.5],   //10
			[-6, 16.5],   //11
			[0, 16.5]     //12
		]);

		if(fancy)
		{
			union()
			{
				if(side=="left")
				{
					FancyFormer();
				}
				if(side=="right")
				{
					translate([0, 0, t]) FancyFormer();
				}
			}
		}


	}
}


module ServoHoleFormer()
{
	cube([servo_width, servo_height, t+j+j], true);

	translate([servo_width/2 + servo_bolt_size/2 +1, 0, 0])
	cylinder(h=t+j+j, r=servo_bolt_size/2, $fn=30, center=true);

	translate([-servo_width/2 - servo_bolt_size/2-1, 0, 0])
	cylinder(h=t+j+j, r=servo_bolt_size/2, $fn=30, center=true);
}



if(side == "left")
{
	SidePanel();
}
else
{
	translate([0, 0, t]) rotate([180, 0, 0]) SidePanel();
}