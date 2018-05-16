// Drag chain, best printed together as much as possible
// Common sizes 8x8, 10x10, 10x20
// Copyright (c) R. Linder
// This work is licensed under a Creative Commons Attribution 4.0 International License.

// Internal dimension (min 5)
link_height=10;
// Internal dimension (min 5)
link_width=15;
// Thickness of part body (Typical 1.8 min 1.4)
shell_thickness=1.8;
// Print as many as your bed can fit
number_of_links = 8;
// Add anti stick if your chain is fused solid.
anti_stick = 0.25;		// [0.0:0.01:0.35]
// Select what to print
part_selection = 1;		// [0:Chain only, 1:Male mount, 2:Female mount, 3:Chain with mounts, 4:Female mount wide]

linkHeight = link_height + 2 * shell_thickness;
linkWidth = link_width + 4 * shell_thickness;

linkLength = link_height * 2.8;
pinRad = linkHeight / 6;
pinSpace = ((linkLength / 2) - (linkHeight / 2)) * 2;
tabLen = linkHeight / 2;

ep=0.01;
m3_nut_r = 6.6/2;
m3_slot=3.5;
$fn=140;
//%translate([-50,-20-4,-20-10])cube([100,20,20]);
//plate
offset=47;
screw_spacing=103.5;
bracket_t=4+(.8*5);
m3_nut_r = 6.6/2;
m3_slot=3.5;
tongue=35;
nut_h=4;
module clip()
{
    difference()
    {
        translate([0,0,-bracket_t/2])linear_extrude(bracket_t)minkowski()
        {
            square([m3_nut_r*2*2-2,m3_nut_r*2*2],center=true);
            circle(r=1);
        }
        translate([0,0,(bracket_t/2-bracket_t/8)+ep])rotate([0,0,30])cylinder(r1=m3_nut_r,r2=m3_nut_r,h=bracket_t/4,center=true,$fn=6);
        translate([0,0,0])cylinder(r=m3_slot/2,h=bracket_t*2,center=true);
    }
}
module mount_plate()
{
translate([linkWidth/2+.3+offset-29.5,20+screw_spacing/2,bracket_t/2-linkHeight])clip();
difference()
{
    translate([linkWidth,0,-linkHeight])linear_extrude((linkHeight-link_height)/2+2)minkowski()
    {
        square([offset+linkWidth/2-15,screw_spacing+25]);
        circle(r=2);
    }
    translate([linkWidth/2+.3+offset,20,-10])cylinder(r=2,h=20,center=true);
    translate([linkWidth/2+.3+offset,20+screw_spacing,-10])cylinder(r=2,h=20,center=true);
    translate([linkWidth/2+.3+offset,40,-10])cylinder(r=2,h=20,center=true);
    translate([linkWidth/2+.3+offset,40+15,-10])cylinder(r=2,h=20,center=true);
    translate([0,0,-linkHeight+1+2])hull()
    {
        translate([linkWidth/2+.3+offset,40,])cylinder(r=2,h=2,center=true);
        translate([linkWidth/2+.3+offset,40+15,0])cylinder(r=2,h=2,center=true);
    }
    translate([0,150,0])scale([1,1.5,1])cylinder(r=50,h=50,center=true);
    translate([linkWidth/2+.3+offset-29.5,20+screw_spacing/2,bracket_t/2-linkHeight])cylinder(r=m3_slot/2,h=bracket_t*2,center=true);
}
}
module mirror_mount_plate()
{
    translate([linkWidth/2+.3+offset-29.5-4.8,20+screw_spacing/2,bracket_t/2-linkHeight])clip();
    difference()
    {
        translate([linkWidth,0,-linkHeight])linear_extrude((linkHeight-link_height)/2+2)minkowski()
        {
            square([offset+linkWidth/2-15,screw_spacing+25]);
            circle(r=2);
        }
        translate([linkWidth/2+.3+offset,20,-10])cylinder(r=2,h=20,center=true);
        translate([linkWidth/2+.3+offset,20+screw_spacing,-10])cylinder(r=2,h=20,center=true);
        translate([linkWidth/2+.3+offset,40,-10])cylinder(r=2,h=20,center=true);
        translate([linkWidth/2+.3+offset,40+15,-10])cylinder(r=2,h=20,center=true);
        translate([0,0,-linkHeight+1+2])hull()
        {
            translate([linkWidth/2+.3+offset,40,])cylinder(r=2,h=2,center=true);
            translate([linkWidth/2+.3+offset,40+15,0])cylinder(r=2,h=2,center=true);
        }
        translate([0,150,0])scale([1,1.5,1])cylinder(r=50,h=50,center=true);
        translate([linkWidth/2+.3+offset-29.5-4.8,20+screw_spacing/2,bracket_t/2-linkHeight])cylinder(r=m3_slot/2,h=bracket_t*2,center=true);
    }
}
mirror([1,0,0])mirror_mount_plate();
//mount_plate();
module femaleMount ()
{
	difference ()
	{
		union ()
		{
			difference ()
			{
				translate ([linkHeight/2, 0, 0]) hull ()
				{
					translate ([0, pinSpace/2, 0]) cylinder (h=linkWidth+0.6, r=linkHeight/2);
					translate ([-linkHeight/2,-pinSpace/6, 0]) cube ([linkHeight, 1, linkWidth+0.6]);
					translate ([0,-pinSpace*1.5, 0]) cube ([linkHeight/2, 5, linkWidth+0.6]);
				}
				femaleEnd (mount=1);
			}
		}
		translate ([-shell_thickness,-pinSpace*1.5-0.6, shell_thickness*2]) cube (size=[linkHeight, pinSpace*2.5, linkWidth- (shell_thickness*4)+0.6]);

		// M3 Holes
		if (link_width >= 10)
		{
			for (off = [0:2])
			{
				rotate ([0, 90, 0]) translate ([-linkWidth/2-off- (link_width) /6+0.6,-linkLength/2.5- (linkLength/6), link_height+0.6]) cylinder (h=shell_thickness*2, r=1.6);

				rotate ([0, 90, 0]) translate ([-linkWidth/2+off+ (link_width) /6-1.2,-linkLength/2.5+ (linkLength/6), link_height+0.6]) cylinder (h=shell_thickness*2, r=1.6);

			}
		}
		else
		{
			rotate ([0, 90, 0]) translate ([-linkWidth/2-0.3,-linkLength/2.5, link_height+0.6]) cylinder (h=shell_thickness*2, r=1.6);
		}

	}
}
module wideFemaleMount()
{
    difference ()
	{
		union ()
		{
			difference ()
			{
				translate ([linkHeight/2, 0, 0]) hull ()
				{
					translate ([0, pinSpace/2, 0]) cylinder (h=linkWidth+0.6, r=linkHeight/2);
					translate ([-linkHeight/2,-pinSpace/6, 0]) cube ([linkHeight, 1, linkWidth+0.6]);
					//translate ([0,-pinSpace*1.5, 0]) cube ([linkHeight/2, 5, linkWidth+0.6]);
				}
				femaleEnd (mount=1);
			}
                translate ([linkHeight/2, 0, 0])hull()
                {
                    translate ([-linkHeight/2,-pinSpace/6, 0]) cube ([linkHeight, 1, linkWidth+0.6]);
                    //%translate ([0,-pinSpace*1.5-2, -linkWidth/2]) cube ([linkHeight/2, 12, 2*linkWidth+0.6]);
                    translate ([0,-pinSpace*1.5-2+6, -linkWidth/2+linkWidth+0.3]) rotate([0,90,0])linear_extrude(linkHeight/2)minkowski()
                    {
                        square([2*linkWidth+0.6-4,12-4],center=true);
                        circle(r=2);
                    }
                }
		}
		translate ([-shell_thickness,-pinSpace*2-0.6, shell_thickness*2]) cube (size=[linkHeight, pinSpace*3.5, linkWidth- (shell_thickness*4)+0.6]);

		// M5 Holes
        for (off=[-1:2:1])
        {
            translate([linkHeight,-pinSpace,linkWidth/2+.3+(off*(linkWidth- (shell_thickness*4)+0.6))])rotate([0,180,0])m5_hole();
        }
	}
}
m5_slot=6;
m5_head=10; //diameter of M5 head
m5_wall=5; //thickness of plastic between M5 and extrusion
module m5_hole()
{
    rotate([0,90,0])cylinder(r=m5_slot/2,h=linkHeight*2,center=true);
    rotate([0,90,0])translate([0,0,linkHeight+m5_wall-ep])cylinder(r=m5_head/2,h=linkHeight*2,center=true);
}
module maleMount ()
{
	difference ()
	{
		union ()
		{
			difference ()
			{
				union ()
				{
					translate ([linkHeight/2, 0, 0]) hull ()
					{
						translate ([0, pinSpace, 0]) cube ([linkHeight/2, 5, linkWidth+0.6]);
						translate ([0, -pinSpace/2, 0]) cylinder (h=linkWidth+0.6, r=linkHeight/2);
						translate ([-linkHeight/2,-pinSpace/6, 0]) cube ([linkHeight, 1, linkWidth+0.6]);
					}
					translate ([0,- (linkLength+tabLen) /2, shell_thickness+0.3]) cube (size=[(linkHeight+shell_thickness) /2, tabLen*2, linkWidth-shell_thickness*2+0.2]);
				}
				maleEnd ();
			}
			// Locking pins (0.2mm narrower)
			translate ([linkHeight/2, (-pinSpace/2)-1.5, 0.4]) cylinder (h=linkWidth-0.2, r=pinRad-0.25);


		}
		// Top Champher on stopper
		translate ([linkHeight/2+1,-linkLength/2-sqrt (tabLen*tabLen*2), 0]) rotate ([0, 0, 45]) cube ([tabLen, tabLen, linkWidth]);
		// Front Champher on stopper
		translate ([linkHeight/2-0.6,-linkLength/2-tabLen+0.6, 0]) rotate ([0, 0, 70]) cube (size=[2.5, 5, linkWidth+5]);
		// Hole for wires
		translate ([0-shell_thickness,-pinSpace*1.5, shell_thickness*2]) cube (size=[linkHeight, pinSpace*3.5, linkWidth- (shell_thickness*4)+0.6]);

		/*if (link_width >= 10)
		{
			for (off = [0:2])
			{
				rotate ([0, 90, 0]) translate ([-linkWidth/2-off- (link_width) /6+0.6, linkLength/3+ (linkLength/6), link_height+0.6]) cylinder (h=shell_thickness*2, r=1.6);

				rotate ([0, 90, 0]) translate ([-linkWidth/2+off+ (link_width) /6-1.2, linkLength/3- (linkLength/6), link_height+0.6]) cylinder (h=shell_thickness*2, r=1.6);
			}
		}
		else
		{
			rotate ([0, 90, 0]) translate ([-linkWidth/2-0.3, linkLength/2, link_height+0.6]) cylinder (h=shell_thickness*2, r=1.6);
		}*/
	}
}


module link ()
{
	difference ()
	{
		union ()
		{
			difference ()
			{
				union ()
				{
					translate ([linkHeight/2, 0, 0]) hull ()
					{
						translate ([0, pinSpace/2, 0]) cylinder (h=linkWidth+0.6, r=linkHeight/2);
						translate ([0,-pinSpace/2, 0]) cylinder (h=linkWidth+0.6, r=linkHeight/2);
					}
					translate ([0,- (linkLength+tabLen) /2, shell_thickness+anti_stick/2]) cube (size=[(linkHeight+shell_thickness) /2, tabLen*2, linkWidth-shell_thickness*2+0.2]);
				}

				maleEnd ();
				femaleEnd ();
			}

			// Locking pins (0.2mm narrower)
			translate ([linkHeight/2, (-pinSpace/2)-1.5, 0.4]) cylinder (h=linkWidth-0.2, r=pinRad-0.25);
		}
		// Top Champher on stopper
		translate ([linkHeight/2+1,-linkLength/2-sqrt (tabLen*tabLen*2), 0]) rotate ([0, 0, 45]) cube ([tabLen, tabLen, linkWidth]);

		// Front Champher on stopper
		translate ([linkHeight/2-0.6,-linkLength/2-tabLen+0.6, 0]) rotate ([0, 0, 70]) cube (size=[2.5, 5, linkWidth+5]);

		// Hole for cables
		translate ([0+shell_thickness+0.2,-linkLength/2-tabLen, shell_thickness*2]) cube (size=[linkHeight-shell_thickness*2, linkLength+tabLen+1, linkWidth- (shell_thickness*4)+0.6]);

		// trim top brace
		translate ([0,-pinSpace-pinRad*2, shell_thickness*2]) cube (size=[linkHeight+3, linkLength/2, linkWidth- (shell_thickness*4)+0.6]);
	}
}

// The Male end with cutouts

module maleEnd ()
{
	//Cutouts for opposite side
	translate ([-0.6,-linkLength/2, (linkWidth+0.4)-shell_thickness])  cube (size=[linkHeight+1, pinRad*6-shell_thickness, shell_thickness+0.7]);

	translate ([-0.6,-linkLength/2, -0.6]) cube (size=[linkHeight+1, pinRad*6-shell_thickness, shell_thickness+0.8]);
	// Cut out on rounds to fit on base
	translate ([-0.6, (- (linkLength+tabLen) /2)-0.6, 0]) cube (size=[shell_thickness+1.2+anti_stick, pinRad*2.5+tabLen+0.6, linkWidth+0.6]);

}

module femaleEnd (mount=0)
{
	translate ([linkHeight/2, (pinSpace/2)+1.5,-1]) cylinder (h=linkWidth+3, r=pinRad);
	// Bottom brace
	translate ([-0.6, pinRad*2.5, shell_thickness-anti_stick]) cube (size=[linkHeight+2, pinRad*3+1.2, linkWidth- (shell_thickness*2)+0.6+ (2*anti_stick)]);
	// Top brace
	translate ([linkHeight-shell_thickness-0.6, pinRad*2, shell_thickness-anti_stick]) cube (size=[shell_thickness*2, pinRad*4, linkWidth- (shell_thickness*2)+0.6+anti_stick*2]);
	if (mount)
	{
		translate ([0, 0, shell_thickness]) cube (size=[linkHeight- (shell_thickness), (linkLength/2), linkWidth- (shell_thickness*2)+0.6]);
	}
	else
	{
		translate ([shell_thickness+0.2, -0.6, shell_thickness-anti_stick]) cube (size=[linkHeight- (shell_thickness*2), (linkLength/2)+0.6, linkWidth- (shell_thickness*2)+0.6+ (2*anti_stick)]);
	}
}


/*
rotate ([0, 90, 0])
{
	if (part_selection == 1)
	{
		maleMount ();
	}
	else if (part_selection == 2)
	{
		femaleMount ();
	}
	else if (part_selection <= 3)
	{
		if (part_selection == 3)
		{
			femaleMount ();
			translate ([0, (number_of_links+1) *(pinSpace+3), 0]) maleMount ();
		}

		for (cnt = [0:number_of_links-1])
		{
			translate ([0, (cnt+1) *(pinSpace+3), 0]) link ();
		}
	}
    else if (part_selection == 4)
    {
        wideFemaleMount();
    }
	else
	{
		echo ("Invalid Part Selection");
	}
}*/