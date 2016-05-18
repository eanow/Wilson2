module mimic()
{
    translate([900-20-8+1-.2-.0775,-12-.3+.03,-3.7])import("../stl/y-table-10.stl");
}

rod_gap=170; //center to center of rods
slider_w=19;
bearing_l=30;
bearing_r=19/2;
slider_l=32.5;
slider_gap=103.5; //center to center spacing of sliders
plate_t=2.526;
slider_t=7.2;
ep=0.001;
$fs=2;
$fa=2;
plate_x=rod_gap+slider_w;
plate_y=slider_gap+slider_l;
m4slot=4.5;
m4nut=7;
module plate()
{
    translate([0,plate_y/2,plate_t/2])cube([plate_x,plate_y,plate_t],center=true);
}
module ribs()
{
    aa=70;
    intersection()
    {
        translate([0,-30,0])cylinder(r=aa+4,h=20,center=true);
        translate([0,plate_y/2,plate_t])cube([plate_x,plate_y,plate_t*2],center=true);
    }
    intersection()
    {
        translate([0,155,0])cylinder(r=aa,h=20,center=true);
        translate([0,plate_y/2,plate_t])cube([plate_x,plate_y,plate_t*2],center=true);
    }
    intersection()
    {
        translate([-(rod_gap/2+slider_w/2+10),plate_y/2,0])cylinder(r=39,h=20,center=true);
        translate([0,plate_y/2,plate_t])cube([plate_x,plate_y,plate_t*2],center=true);
    }
    intersection()
    {
        translate([(rod_gap/2+slider_w/2+10),plate_y/2,0])cylinder(r=39,h=20,center=true);
        translate([0,plate_y/2,plate_t])cube([plate_x,plate_y,plate_t*2],center=true);
    }
    intersection()
    {
        translate([35,slider_gap/2+slider_l/2-4,0])cylinder(r=22,h=20,center=true);
        translate([0,plate_y/2,plate_t])cube([plate_x,plate_y,plate_t*2],center=true);
    }
    intersection()
    {
        translate([-48,slider_gap/2+slider_l/2-4,0])cylinder(r=15,h=20,center=true);
        translate([0,plate_y/2,plate_t])cube([plate_x,plate_y,plate_t*2],center=true);
    }
    translate([0,1.5,plate_t+ep])cube([plate_x,3,plate_t*2],center=true);
    translate([0,plate_y-1.5,plate_t+ep])cube([plate_x,3,plate_t*2],center=true);
    translate([-40,80,plate_t+ep])rotate([0,0,45])cube([50,3,plate_t*2],center=true);
    translate([-40,50,plate_t+ep])rotate([0,0,-45])cube([50,3,plate_t*2],center=true);
}
module speedholes()
{
    //gaps to lighten/reduce material
    //front
    aa=70;
    translate([0,-30,0])cylinder(r=aa,h=20,center=true);
    //back
    translate([0,155,0])cylinder(r=aa-4,h=20,center=true);
    //left
    translate([-(rod_gap/2+slider_w/2+10),plate_y/2,0])cylinder(r=35,h=20,center=true);
    //right
    translate([(rod_gap/2+slider_w/2+10),plate_y/2,0])cylinder(r=35,h=20,center=true);
    //mid holes
    translate([35,slider_gap/2+slider_l/2-4,0])cylinder(r=18,h=20,center=true);
    translate([-48,slider_gap/2+slider_l/2-4,0])cylinder(r=11,h=20,center=true);
}
module slider()
{
    translate([rod_gap/2,slider_l/2,slider_t/2])cube([slider_w,slider_l,slider_t],center=true);
    translate([rod_gap/2,slider_l/2+slider_gap,slider_t/2])cube([slider_w,slider_l,slider_t],center=true);
    translate([-rod_gap/2,slider_l/2+slider_gap,slider_t/2])cube([slider_w,slider_l,slider_t],center=true);
    translate([-rod_gap/2,slider_l/2,slider_t/2])cube([slider_w,slider_l,slider_t],center=true);
}
module bearingsub()
{
     //bearing
    rotate([90,0,0])cylinder(r=bearing_r,h=bearing_l,center=true);
    //looser fit off center
    translate([(-5),0,-2.1])rotate([0,31,0])cube([5,bearing_l,10],center=true);
    translate([(5),0,-2.1])rotate([0,-31,0])cube([5,bearing_l,10],center=true);
    //clearance for rods
    translate([0,0,bearing_r+3])rotate([90,0,0])cylinder(r=bearing_r*2,h=bearing_l+10,center=true);
    //zip tie guides
    translate([0,-10,-bearing_r-1])cube([12.5,4,2.0],center=true);
    translate([6,-10,-bearing_r-1.1])rotate([0,-31,0])translate([6,0,0])cube([12.5,4,1.8],center=true);
    translate([-6,-10,-bearing_r-1.1])rotate([0,180+31,0])translate([6,0,0])cube([12.5,4,1.8],center=true);
    translate([0,10,-bearing_r-1])cube([12.5,4,2.0],center=true);
    translate([6,10,-bearing_r-1.1])rotate([0,-31,0])translate([6,0,0])cube([12.5,4,1.8],center=true);
    translate([-6,10,-bearing_r-1.1])rotate([0,180+31,0])translate([6,0,0])cube([12.5,4,1.8],center=true);
}
module bearing()
{
    //bearing cylinders
    //looser fit around edges
    //extra clearance for rods
    translate([rod_gap/2,slider_l/2,bearing_r+plate_t])
    {
       bearingsub();
    }
    translate([-(rod_gap/2),slider_l/2,bearing_r+plate_t])
    {
        bearingsub();
    }
    translate([-(rod_gap/2),slider_gap+(slider_l/2),bearing_r+plate_t])
    {
        bearingsub();
    }
    translate([rod_gap/2,slider_gap+(slider_l/2),bearing_r+plate_t])
    {
        bearingsub();
    }
}
post_x=19;
post_y=33;
post_z=25;
post_nudge=12;
module post()
{
    
    translate([-post_nudge,(slider_gap/2+slider_l/2-4),post_z/2])cube([post_x,post_y,post_z],center=true);
    //skirt
    hull()
    {
        translate([-post_nudge,(slider_gap/2+slider_l/2-4),8])cube([post_x,post_y,1],center=true);
        translate([-post_nudge,(slider_gap/2+slider_l/2-4),0.5])cube([post_x+15,post_y+10,1],center=true);
    }
    
}
module belts()
{
    //main slot
    belt_t=1;
    translate([-10,50,18])cube([belt_t,100,20],center=true);
    //second slot
    translate([-15.5,50,18])cube([belt_t,100,20],center=true);
    //teeth
    for (yy=[0:1:30])
    {
        translate([-(8.5+ep),25+yy*2,18])cube([2,1,20],center=true);
        translate([-(17-ep),25+yy*2,18])cube([2,1,20],center=true);
    }
    //spacer cut
    translate([-20,(slider_gap/2+slider_l/2-4),plate_t+20-ep])cube([20,7,40],center=true);
    //slanty
    translate([-10,50,25])rotate([0,45,0])cube([4,100,4],center=true);
    difference()
    {
        translate([-15.5,50,25])rotate([0,45,0])cube([4,90,4],center=true);
        translate([-11.5,50,25])cube([8,100,15],center=true);
    }
}
module complete()
{
    difference()
    {
        union()
        {
            plate();
            slider();
            translate([0,0,-ep])ribs();
            captive();
        }
        speedholes();
        bearing();
        screws();
    }
    difference()
    {
        post();
        belts();
    }

}
module captive()
{
    screw_x=70;
    translate([-screw_x,slider_l/2+.2,0])
    {
        difference()
        {
            translate([0,0,plate_t])rotate([0,0,30])cylinder(r=m4nut/2+1,h=plate_t*2,center=true,$fn=6);
            translate([0,0,plate_t+ep])rotate([0,0,30])cylinder(r=m4nut/2,h=plate_t*2,center=true,$fn=6);
        }
    }
    translate([screw_x,slider_l/2+.2,0])
    {
        difference()
        {
            translate([0,0,plate_t])rotate([0,0,30])cylinder(r=m4nut/2+1,h=plate_t*2,center=true,$fn=6);
            translate([0,0,plate_t+ep])rotate([0,0,30])cylinder(r=m4nut/2,h=plate_t*2,center=true,$fn=6);
        }
    }
    translate([-screw_x,slider_l/2-.2+slider_gap,0])
    {
        difference()
        {
            translate([0,0,plate_t])rotate([0,0,30])cylinder(r=m4nut/2+1,h=plate_t*2,center=true,$fn=6);
            translate([0,0,plate_t+ep])rotate([0,0,30])cylinder(r=m4nut/2,h=plate_t*2,center=true,$fn=6);
        }
    }
    translate([screw_x,slider_l/2-.2+slider_gap,0])
    {
        difference()
        {
            translate([0,0,plate_t])rotate([0,0,30])cylinder(r=m4nut/2+1,h=plate_t*2,center=true,$fn=6);
            translate([0,0,plate_t+ep])rotate([0,0,30])cylinder(r=m4nut/2,h=plate_t*2,center=true,$fn=6);
        }
    }
}
module screws()
{
    screw_x=70;
    translate([-screw_x,slider_l/2+.2,0])
    {
        cylinder(r=m4slot/2,h=20,center=true,$fn=20);
    }
    translate([screw_x,slider_l/2+.2,0])
    {
        cylinder(r=m4slot/2,h=20,center=true,$fn=20);
    }
    translate([-screw_x,slider_l/2-.2+slider_gap,0])
    {
        cylinder(r=m4slot/2,h=20,center=true,$fn=20);
    }
    translate([screw_x,slider_l/2-.2+slider_gap,0])
    {
        cylinder(r=m4slot/2,h=20,center=true,$fn=20);
    }
}



//ring to hold top
m3nut_r=6.6/2;
m3nut_t=3;
m3slot=3.5;
slot_d=m3nut_r*sqrt(3); 
module holder_bracket()
{
    translate([-post_nudge,(slider_gap/2+slider_l/2-4),post_z])
    {
        difference()
        {
            union()
            {
                translate([post_x/2+3.2,0,-post_z/2-1.8])cube([8,11,post_z-4],center=true);
                translate([-(post_x/2+3.1),10,-post_z/2-1.8])cube([8,11,post_z-4],center=true);
                translate([-(post_x/2+3.1),-10,-post_z/2-1.8])cube([8,11,post_z-4],center=true);
            }
            //shafts
            translate([post_x/2+3.2,0,0])cylinder(r=m3slot/2,h=50,center=true,$fn=16);
            translate([-(post_x/2+3.2),10,0])cylinder(r=m3slot/2,h=50,center=true,$fn=16);
            translate([-(post_x/2+3.2),-10,0])cylinder(r=m3slot/2,h=50,center=true,$fn=16);
            //nuts
            translate([post_x/2+3.2,0,-(post_z-13)])cylinder(r=m3nut_r,h=m3nut_t+1,center=true,$fn=6);
            translate([-(post_x/2+3.2),10,-(post_z-13)])cylinder(r=m3nut_r,h=m3nut_t+1,center=true,$fn=6);
            translate([-(post_x/2+3.2),-10,-(post_z-13)])cylinder(r=m3nut_r,h=m3nut_t+1,center=true,$fn=6);
            //slots
            translate([ep+2+post_x/2+3.2,0,-(post_z-13)])cube([4,slot_d,m3nut_t+1],center=true);
            translate([-(ep+2+post_x/2+3.2),10,-(post_z-13)])cube([4,slot_d,m3nut_t+1],center=true);
            translate([-(ep+2+post_x/2+3.2),-10,-(post_z-13)])cube([4,slot_d,m3nut_t+1],center=true);
        }
    }
}
module holder()
{
    difference()
    {
        cube([post_x+12.4,post_y+4.8,2],center=true);
        cube([post_x+1.2,post_y+1.2,3],center=true);
        translate([post_x/2+3.2,0,0])cylinder(r=m3slot/2,h=3,center=true,$fn=16);
        translate([-(post_x/2+3.2),10,0])cylinder(r=m3slot/2,h=3,center=true,$fn=16);
        translate([-(post_x/2+3.2),-10,0])cylinder(r=m3slot/2,h=3,center=true,$fn=16);
    }
}
//translate([-post_nudge,(slider_gap/2+slider_l/2-4),post_z])
translate([0,115,0])rotate([0,0,90])holder();
holder_bracket();
complete();
//post();
//%translate([-70,slider_l/2+.2,0])cylinder(r=m4slot/2,h=20,center=true,$fn=20);
//%translate([-70,slider_l/2+.2,0])rotate([0,0,30])cylinder(r=m4nut/2,h=20,center=true,$fn=6);


//mimic();