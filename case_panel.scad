use <MCAD/nuts_and_bolts.scad>

PanelHeight=50;
PanelWidth=100;
PanelThickness=1;

MountingHoleDiameter=3;

CaseThickness=20;
CaseHeight=100;

j=0.01;
t=PanelThickness;



difference()
{
	// Main Panel Body
	translate([-PanelWidth/2, 0, 0])
	cube([PanelWidth, PanelHeight, t]);
	
	// Main mounting holes
	translate([-PanelWidth/2+MountingHoleDiameter*1.5, MountingHoleDiameter*1.5, -j]) polyhole(d=MountingHoleDiameter, h=t+j*2);
	translate([-PanelWidth/2+MountingHoleDiameter*1.5, PanelHeight-MountingHoleDiameter*1.5, -j]) polyhole(d=MountingHoleDiameter, h=t+j*2);
	translate([PanelWidth/2-MountingHoleDiameter*1.5, MountingHoleDiameter*1.5, -j]) polyhole(d=MountingHoleDiameter, h=t+j*2);
	translate([PanelWidth/2-MountingHoleDiameter*1.5, PanelHeight-MountingHoleDiameter*1.5, -j]) polyhole(d=MountingHoleDiameter, h=t+j*2);
	
	// USB connection
	translate([-20, 25, 0]) USB_Socket();

	// Power connection
	translate([25, 25, 0]) C14_Socket("front");
}

%translate([-250, -(CaseHeight-PanelHeight)/2, -CaseThickness]) cube([500, CaseHeight, CaseThickness]);



// http://www.kenable.co.uk/product_info.php?products_id=4324
module USB_Socket()
{
	centres=30;
	hole_diameter=3;
	cutout_width=12.6;
	cutout_height=11.39;
	
	translate([-centres/2, 0, 0])
	union()
	{
		translate([0, 0, -j]) polyhole(d=hole_diameter, h=t+j*2);
		translate([centres/2-cutout_width/2, -cutout_height/2, -j]) cube([cutout_width, cutout_height, t+j*2]);
		translate([centres, 0, -j]) polyhole(d=hole_diameter, h=t+j*2);
	}
}


// http://www.kenable.co.uk/product_info.php?products_id=3522
module C14_Socket(mounting="front")
{
	centres=40;
	hole_diameter=3.5;
	front_cutout_width=27.4;
	front_cutout_height=19.8;
	front_corner_radius=5;

	rear_cutout_width=30.2;
	rear_cutout_height=22.7;
	rear_corner_radius=5.9;

	translate([-centres/2, 0, 0])
	union()
	{
		translate([0, 0, -j])
		polyhole(d=hole_diameter, h=t+j*2);
		
		if(mounting=="front")
		{
			translate([centres/2-front_cutout_width/2, -front_cutout_height/2, 0])
			hull()
			{
				translate([front_corner_radius/2, front_corner_radius/2, -j]) polyhole(d=front_corner_radius, h=t+j*2);
				translate([front_cutout_width-front_corner_radius/2, front_corner_radius/2, -j]) polyhole(d=front_corner_radius, h=t+j*2);
				translate([front_corner_radius/2, front_cutout_height-front_corner_radius/2, -j]) polyhole(d=front_corner_radius, h=t+j*2);
				translate([front_cutout_width-front_corner_radius/2, front_cutout_height-front_corner_radius/2, -j]) polyhole(d=front_corner_radius, h=t+j*2);
			}
		}
		if(mounting=="rear")
		{
			translate([centres/2-rear_cutout_width/2, -rear_cutout_height/2, 0])
			hull()
			{
				translate([rear_corner_radius/2, rear_corner_radius/2, -j]) polyhole(d=rear_corner_radius, h=t+j*2);
				translate([rear_cutout_width-rear_corner_radius/2, rear_corner_radius/2, -j]) polyhole(d=rear_corner_radius, h=t+j*2);
				translate([rear_corner_radius/2, rear_cutout_height-rear_corner_radius/2, -j]) polyhole(d=rear_corner_radius, h=t+j*2);	
				translate([rear_cutout_width-rear_corner_radius/2, rear_cutout_height-rear_corner_radius/2, -j]) polyhole(d=rear_corner_radius, h=t+j*2);
			}
		}
		
		translate([centres, 0, -j]) polyhole(d=hole_diameter, h=t+j*2);
	}
}


// By nophead
module polyhole( d, h )
{
	n = max( round( 2 * d ), 3 );
	rotate( [0, 0, 180] ) cylinder( h = h, r = ( d / 2 ) / cos( 180 / n ), $fn = n );
}