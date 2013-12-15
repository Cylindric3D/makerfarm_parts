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
fancy=true;
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
			translate([29.4+j, 1, -j])
			cube([15.8, 24.2, t+j+j]);
		}
	}
	
	if(depth_gauge)
	{
		color([0.8,0.2,0.2])
		translate([38.8, -13.1, 0])
		DepthGaugeMountBlock();
	}
}


module DepthGaugePinFormer(r_major)
{
	union()
	{
		cylinder(r=r_major, h=t, $fn=30);
		
		linear_extrude(height=t) 
		polygon(points=[
			[0, -r_major], // 0
			[4.2, -r_major], // 1
			[6.2, -11.1], // 2
			[10.2, -11.1], // 2a
			[10.2, 11.1], // 3a
			[6.2, 11.1], // 3
			[2.2, r_major], // 4
			[0, r_major] // 5
		]);
	}
}

module DepthGaugeMountBlock()
{
	r_major=8.6;
	
	difference()
	{
		difference()
		{
			if(fancy)
			{
				translate([-r_major-1, -12.1, 0])
				union()
				{
					cube([r_major+1+6.2, 24.2, t-fancy_border_inset]);
					translate([fancy_border_size/2, 0, t-fancy_border_inset-j]) cube([r_major+1+6.2-fancy_border_size/2, fancy_border_size, fancy_border_inset+j]);
				}
			}
			else
			{
				translate([-r_major-1, -12.1, 0])
				cube([r_major+1+6.2, 24.2, t]);
			}
		}
		
		// Pin Former
		translate([0, 0, 2])
		DepthGaugePinFormer(r_major);
	}
	
	// Pin
	shaft_size=3;
	shaft_length=5*1.2;
	head_size=3.3;
	slot_size=1.5;

	translate([0, 0, 2-j])
	difference()
	{
		union()
		{	
			// Stalk
			translate([0,0,-j]) cylinder(r1=shaft_size, r2=head_size, h=shaft_length+j, $fn=30);

			// Cap
			translate([0, 0, shaft_length]) 
			intersection()
			{
				sphere(r=head_size, $fn=30);
				translate([0, 0, head_size/2]) cube([head_size*2, head_size*2, head_size], center=true);
			}
		}
		translate([-slot_size/2, -head_size-j, 0]) cube([slot_size, head_size*2+j+j, shaft_length+head_size+j]);
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
	//DepthGaugeMountBlock();
	SidePanel();
}
else
{
	translate([0, 0, t]) rotate([180, 0, 0]) SidePanel();
}