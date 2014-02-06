// rmajor is the total radius of the torus
// rminor is the radius of the hole
module torus(rmajor, rminor, thickness=0, sides=20, facets=20)
{
	xsection=(rmajor-rminor)/2;
	
	difference()
	{
		rotate_extrude(convexity = 10, $fn = sides)
		translate([(rminor/2)+(xsection/2), 0, 0])
		circle(r = xsection/2, $fn = facets);

		if(thickness>0)
		{			
			torus(rmajor-thickness*2, rminor+thickness*2, 0, sides, facets);
		}
	}
}

// rminor is the radius of the hole
// dminor is the crossectional diameter of the torus
module torus2(rminor, dminor, thickness=0, sides=20, facets=20)
{
	torus(rminor+dminor, rminor, thickness, sides, facets);
}



difference()
{
	union()
	{
		// Torus
		union()
		{
			torus(15, 2);
			%cylinder(h=10, r=2/2, $fn=30); //hole
			%rotate([180,0,0]) cylinder(h=10, r=15/2, $fn=30);
		}
		translate([0, 18, 0]) 
		union()
		{
			torus(15, 2, 1);
			%cylinder(h=10, r=2/2, $fn=30); //hole
			%rotate([180,0,0]) cylinder(h=10, r=15/2, $fn=30);
		}

		// Torus2
		translate([20, 0, 0]) 
		union()
		{
			torus2(10, 3);
			%cylinder(h=10, r=10/2, $fn=30); //hole
			%rotate([180,0,0]) cylinder(h=10, r=(10+2)/2, $fn=30);
		}

		translate([20, 13, 0]) 
		union()
		{
			torus2(rminor=10, dminor=7, thickness=1);
			%cylinder(h=10, r=10/2, $fn=30); //hole
			%rotate([180,0,0]) cylinder(h=10, r=(10+2)/2, $fn=30);
		}
	}
	
	cylinder(r=100, h=10);
}

