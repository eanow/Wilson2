module mimic()
{
    translate([900-20-8+1-.2-.0775,-12-.3+.03,-3.7])import("../stl/y-table-10.stl");
}

extra_lift=2;

rod_gap=170; //center to center of rods
slider_w=19;
bearing_l=30;
bearing_r=19/2;
slider_l=32.5;
slider_gap=103.5; //center to center spacing of sliders
plate_t=2.526+extra_lift;
rib_thick=plate_t+2.4;
slider_t=7.2+extra_lift;
ep=0.001;
$fs=2;
$fa=2;
plate_x=rod_gap+slider_w;
plate_y=slider_gap+slider_l;
m4slot=4.5;
m4nut=7-.2;
module plate()
{
    translate([0,plate_y/2,plate_t/2])cube([plate_x,plate_y,plate_t],center=true);
}
module ribs()
{
    aa=70;
    intersection()
    {
        translate([0,plate_y/2,rib_thick/2])cube([plate_x,plate_y,rib_thick],center=true);
        union()
        {
            translate([0,-30,rib_thick/2])cylinder(r2=aa+4,r1=aa+8,h=rib_thick,center=true);
            translate([0,155,rib_thick/2])cylinder(r2=aa,r1=aa+4,h=rib_thick,center=true);
            translate([-(rod_gap/2+slider_w/2+10),plate_y/2,rib_thick/2])cylinder(r2=39,r1=39+4,h=rib_thick,center=true);
            translate([(rod_gap/2+slider_w/2+10),plate_y/2,rib_thick/2])cylinder(r2=39,r1=39+4,h=rib_thick,center=true);
            translate([35,slider_gap/2+slider_l/2-4,rib_thick/2])cylinder(r2=22,r1=22+4,h=rib_thick,center=true);
            translate([-48,slider_gap/2+slider_l/2-4,rib_thick/2])cylinder(r2=15,r1=15+4,h=rib_thick,center=true);
        }
    }

    translate([0,1.5,rib_thick/2])cube([plate_x,3,rib_thick],center=true);
    translate([0,plate_y-1.5,rib_thick/2])cube([plate_x,3,rib_thick],center=true);
    translate([-40,80,rib_thick/2])rotate([0,0,45])cube([50,3,rib_thick],center=true);
    translate([-40,50,rib_thick/2])rotate([0,0,-45])cube([50,3,rib_thick],center=true);
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
post_x=20;
post_y=31;
post_z=25+extra_lift;
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
    cut_depth=12;
    //main slot
    belt_t=1;
    translate([-10,50,post_z-cut_depth/2])cube([belt_t,100,cut_depth],center=true);
    //teeth
    for (yy=[12:1:29])
    {
        translate([-(8.5+ep),25+yy*2,post_z-cut_depth/2])cube([2,1,cut_depth],center=true);
    }
    //manually placed
    for (yy=[28.5])
    {
        translate([-(8.5+ep),25+yy*2,post_z-cut_depth/2])cube([2,1.1,cut_depth],center=true);
    }
    for (yy=[12.5])
    {
        translate([-(8.5+ep),25+yy*2,post_z-cut_depth/2])cube([2,1.1,cut_depth],center=true);
    }
    //spacer cut
    //translate([-20,(slider_gap/2+slider_l/2-4),plate_t+20-ep])cube([20,7,40],center=true);
    //slanty
    translate([-10,50,post_z])rotate([0,45,0])cube([4,100,4],center=true);
    
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
        translate([0,-post_y/2+(slider_gap/2+slider_l/2-4),0])rotate([0,0,10])translate([0,post_y/2-(slider_gap/2+slider_l/2-4),0])belts();
        translate([0,post_y/2+(slider_gap/2+slider_l/2-4),0])rotate([0,0,10])translate([0,-post_y/2-(slider_gap/2+slider_l/2-4),0])belts();
    }

}
module captive()
{
    screw_x=70;
    for (xx_mult=[-1:2:1])
    {
        translate([xx_mult*screw_x,slider_l/2+.2,0])
        {
            difference()
            {
                translate([0,0,plate_t])rotate([0,0,30])cylinder(r2=m4nut/2+1.2,r1=m4nut/2+3.2,h=rib_thick-plate_t,$fn=6);
                translate([0,0,])rotate([0,0,30])cylinder(r=m4nut/2,h=rib_thick+ep,$fn=6);
            }
        }
        
        translate([xx_mult*screw_x,slider_l/2-.2+slider_gap,0])
        {
            difference()
            {
                translate([0,0,plate_t])rotate([0,0,30])cylinder(r2=m4nut/2+1.2,r1=m4nut/2+3.2,h=rib_thick-plate_t,$fn=6);
                translate([0,0,])rotate([0,0,30])cylinder(r=m4nut/2,h=rib_thick+ep,$fn=6);
            }
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
        cube([post_x+13.4,post_y+5.8,2],center=true);
        cube([post_x+1.2,post_y+1.2,3],center=true);
        translate([post_x/2+3.2,0,0])cylinder(r=m3slot/2,h=3,center=true,$fn=16);
        translate([-(post_x/2+3.2),10,0])cylinder(r=m3slot/2,h=3,center=true,$fn=16);
        translate([-(post_x/2+3.2),-10,0])cylinder(r=m3slot/2,h=3,center=true,$fn=16);
    }
}
//translate([-post_nudge,(slider_gap/2+slider_l/2-4),post_z])
//translate([0,115,1])rotate([0,0,90])holder();
//holder_bracket();
complete();
//post();
//%translate([-70,slider_l/2+.2,0])cylinder(r=m4slot/2,h=20,center=true,$fn=20);
//%translate([-70,slider_l/2+.2,0])rotate([0,0,30])cylinder(r=m4nut/2,h=20,center=true,$fn=6);


//mimic();