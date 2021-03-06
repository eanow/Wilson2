

$fs=.5;
$fa=1;
ep=0.001;
shaft_l=32;
//shaft_h=12; //original rice design size
shaft_h=20;
shaft_w=9;
yoke_w=16;
yoke_r=2.5;
yoke_l=19.75;
inside_w=10;
m4slot=4.5;
m3slot=3.5;
m3screw_l=18.5;
belt_r=12.75;
belt_x=13.75;
f_ring_r=4.8;
m3nut_r=6.6/2;
m3nut_t=3;
//shaft
module shaft()
{
    translate([shaft_l/2,0,0])cube([shaft_l,shaft_w,shaft_h],center=true);
}
//yoke
module round()
{
    translate([0,0,-shaft_h/2])linear_extrude(height=shaft_h)intersection()
    {
        minkowski()
        {
            translate([shaft_l+(yoke_l-yoke_r)-ep,0])square([2*(yoke_l-yoke_r*2),(yoke_w-yoke_r*2)],center=true);
            circle(r=yoke_r);
        }
        translate([shaft_l+yoke_l/2-ep,0])square([yoke_l+ep,yoke_w+ep],center=true);
    }
}
module yoke()
{
    difference()
    {
        round();
        xbump=(yoke_w-inside_w)/2;
        translate([yoke_l/2+shaft_l+xbump,0,0])cube([yoke_l,inside_w,shaft_h*2],center=true);
    }
}
//yoke();
//shaft();
module shaftyoke()
{
    difference()
    {
        union()
        {
            yoke();
            shaft();
        }
        translate([shaft_l+belt_x,0,0])rotate(90,[1,0,0])cylinder(r=belt_r,h=inside_w,center=true);
        translate([shaft_l+belt_x,0,0])rotate(90,[1,0,0])cylinder(r=m3slot/2,h=inside_w*2,center=true);
    }
    //friction rings
    difference()
    {
        translate([shaft_l+belt_x,0,0])rotate(90,[1,0,0])cylinder(r=f_ring_r,h=inside_w+1,center=true);
        translate([shaft_l+belt_x,0,0])rotate(90,[1,0,0])cylinder(r=f_ring_r-.5,h=inside_w*2,center=true);
        translate([yoke_l/2+shaft_l,0,0])cube([yoke_l,inside_w-1,shaft_h*2],center=true);
    }
}
module complete()
{
    difference()
    {
        shaftyoke();
        //captive nuts
        slot_d=(5/2)*sqrt(3); 
        //fudge=slot_d-(5*sqrt(3)/2); //take this out later
        //+fudge
        translate([3.5,0,shaft_h/2-1.5-slot_d/2])
        {
            rotate([90,0,90])cylinder(r=m3nut_r,h=m3nut_t,$fn=6,center=true);
            translate([0,shaft_w/2,0])cube([m3nut_t,shaft_w,sqrt(3)*6.6/2],center=true);
            
        }
        translate([m3screw_l/2-ep,0,shaft_h/2-1.5-slot_d/2])rotate([90,0,90])cylinder(r=m3slot/2,h=m3screw_l+3,center=true);
        translate([3.5,0,-(shaft_h/2-1.5-slot_d/2)])
        {
            rotate([90,0,90])cylinder(r=m3nut_r,h=m3nut_t,$fn=6,center=true);
            translate([0,shaft_w/2,0])cube([m3nut_t,shaft_w,sqrt(3)*6.6/2],center=true);
        }
        translate([m3screw_l/2-ep,0,-(shaft_h/2-1.5-slot_d/2)])rotate([90,0,90])cylinder(r=m3slot/2,h=m3screw_l+3,center=true);
        translate([30,5+shaft_w/2-ep,-39])rotate(45,[0,1,0])cube([50,10,50],center=true);
        translate([30,5+shaft_w/2-ep,39])rotate(45,[0,1,0])cube([50,10,50],center=true);
        translate([30,-(5+shaft_w/2-ep),-39])rotate(45,[0,1,0])cube([50,10,50],center=true);
        translate([30,-(5+shaft_w/2-ep),39])rotate(45,[0,1,0])cube([50,10,50],center=true);
    }
    
}
complete();
    
