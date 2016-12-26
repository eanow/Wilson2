//%rotate([0,0,-90])translate([65.6,44.5,0])import("../stl/z-pinion.stl");
use<rack_and_pinion.scad>;
ep=0.01;
m3_slot=3.5;
//translate([-1+.15+12,11,0])import("../stl/z-rack-short.stl");
pinion_t=9.8;
mount_t=16.2;

module axle()
{
    pinion(4,8,pinion_t,0);
}


module down_stop()
{
    pin_off=12;
    pin_l=13.5;
    pin_yy=4.5;
    pin_w=1.2;
    //pin
    translate([-pin_off,pin_yy/2])square([pin_w,pin_l-pin_yy],center=true);
    //arm
    
    translate([-pin_off/2,0])square([pin_off,pin_l-pin_yy*2],center=true);
    //fillet at corner
    fillet_r=1;
    translate([-ep,-ep])difference()
    {
        translate([-pin_off+pin_w/2+fillet_r,.5*(pin_l-pin_yy*2)+fillet_r])square([fillet_r*2,fillet_r*2],center=true);
        translate([-pin_off+pin_w/2+fillet_r,.5*(pin_l-pin_yy*2)+fillet_r])circle(r=fillet_r+ep,center=true,$fn=50);
        translate([-pin_off+pin_w/2+fillet_r+fillet_r,.5*(pin_l-pin_yy*2)+fillet_r])square([fillet_r*2+ep,fillet_r*2+ep],center=true);
        translate([-pin_off+pin_w/2+fillet_r,fillet_r+.5*(pin_l-pin_yy*2)+fillet_r])square([fillet_r*2+ep,fillet_r*2+ep],center=true);
    }
    //manually placed, strengthing bit
    translate([-3.7,2.1])square([2,4],center=true);
    translate([ep,-ep])translate([-3.7-2,2.1+1.1])difference()
    {
        translate([0,0])square([fillet_r*2,fillet_r*2],center=true);
        translate([0,0])circle(r=fillet_r+ep,center=true,$fn=50);
        translate([-fillet_r,0])square([fillet_r*2+ep,fillet_r*2+ep],center=true);
        translate([0,fillet_r])square([fillet_r*2+ep,fillet_r*2+ep],center=true);
    }
}
module up_stop()
{
    mirror([1,-1,0])down_stop();
}

module switch_block()
{
    block_w=6;
    xx_nudge=-1;
    yy_nudge=6.6;
    arm_l=26-yy_nudge;
    round=.5;
    minkowski()
    {
        translate([xx_nudge,-arm_l/2-yy_nudge])square([block_w-round*2,arm_l-round*2],center=true);
        circle(r=round,$fn=30);
    }
    //mounting ridge
    translate([-3.8,-17])square([1.6,1.6],center=true);
}
module holes()
{
    yy_zip=-20.2;
    //rotation axle
    cylinder(r=m3_slot/2,h=mount_t*3,center=true,$fn=30);
    //zip ties
    translate([0,yy_zip,4.25])rotate([0,90,0])cylinder(r=2.5/2,h=10,center=true,$fn=20);
    translate([0,yy_zip,4.25+10])rotate([0,90,0])cylinder(r=2.5/2,h=10,center=true,$fn=20);
    //groove
    /*hull()
    {
        translate([1.9,yy_zip,4.25])rotate([0,90,0])cylinder(r=2.5/2,h=3,center=true,$fn=20);
        translate([1.9,yy_zip,4.25+10])rotate([0,90,0])cylinder(r=2.5/2,h=3,center=true,$fn=20);
    }*/
    translate([1.9,yy_zip,4.25])rotate([0,90,0])cylinder(r=4.5/2,h=3,center=true,$fn=6);
    translate([1.9,yy_zip,4.25+10])rotate([0,90,0])cylinder(r=4.5/2,h=3,center=true,$fn=6);
    //spring pull
    translate([-1,-11,0])cylinder(r=m3_slot/2,h=mount_t*3,center=true,$fn=30);
}
module inside_corner()
{
    //triangle
    linear_extrude(pinion_t)hull()
    {
        translate([-5,0])square([10,ep],center=true);
        translate([0,-5])square([ep,10],center=true);
    }
    //annulus
    translate([-4,-7,0])linear_extrude(pinion_t/2)difference()
    {
        circle(r=4.6,$fn=60);
        circle(r=3,$fn=60);
    }
}
module final()
{

    difference()
    {
        union()
        {
            axle();
            linear_extrude(pinion_t)down_stop();
            linear_extrude(pinion_t)up_stop();
            linear_extrude(mount_t)switch_block();
            inside_corner();
        }
        holes();
        
    }
}
final();