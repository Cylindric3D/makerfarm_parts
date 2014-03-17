include <lib/DepthGauge.scad>

// Panel thickness
//t=6.35;

// Jitter. This should be much less than one layer height.
j=0.03;

function PanelThickness()=6.35;

// Side panel with the various holes cut out
module XSidePlate(endstop_hole=false)
{
	translate([0, 0, PanelThickness()])
	rotate([180, 0, 0])
	difference()
	{
		linear_extrude(height=PanelThickness()) 
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

		// X Endstop bolt hole
		if(endstop_hole) {
			translate([17.9, 13.3, -j])
			cylinder(h=PanelThickness()+j+j, r=1.5,$fn=30);
		}

		// Main mounting bolt hole
		translate([22.05, -2.9, -j]) 
		cylinder(h=PanelThickness()+j+j, r=2, $fn=30);
	}
}


XSidePlate();
