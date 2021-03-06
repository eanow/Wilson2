//translate([0,-12,0])import("../stl/pica-mount.stl");
plate_thick=3.5;
plate_l=110;
plate_w=79;
post_h=17.5;
cut_out_r=2.66;
$fa=.5;
$fs=.5;
module base_plate()
{
    translate([plate_l/2,-plate_w/2,plate_thick/2])cube([plate_l,plate_w,plate_thick],center=true);
    translate([plate_l/2-1.25,-64.25,plate_thick/2])cube([plate_l+8.5,18,plate_thick],center=true);
    //ridge
    translate([.8,-64.25,0])cylinder(r=cut_out_r+3,h=plate_thick+.7,$fn=40);
    translate([.8-3.15,-64.25,.5*(plate_thick+.7)])cube([6.3,cut_out_r*2+6,plate_thick+.7],center=true);
    translate([plate_l-(0.15+3.15),-64.25,0])cylinder(r=cut_out_r+3,h=plate_thick+.7,$fn=40);
    translate([plate_l-(0.15),-64.25,.5*(plate_thick+.7)])cube([6.3,cut_out_r*2+6,plate_thick+.7],center=true);
    //fan
    translate([plate_l/2,-3.5,4.25])cube([plate_l,7,8.5],center=true);
    hull()
    {
        translate([plate_l/2,-2.5,4.25])cube([plate_l,5,8.5],center=true);
        translate([plate_l/2,-2.5,15])cube([plate_l-40,5,30],center=true);
    }
}
module screw_cut()
{
    translate([.8,-64.25,-1])cylinder(r=cut_out_r,h=3+plate_thick+.7,$fn=40);
    translate([plate_l-(0.15+3.15),-64.25,-1])cylinder(r=cut_out_r,h=3+plate_thick+.7,$fn=40);
    translate([plate_l-(0.15),-64.25,.5*(plate_thick+.7)-1])cube([6.3+.1,cut_out_r*2,3+plate_thick+.7],center=true);
    translate([.8-3.15,-64.25,.5*(plate_thick+.7)-1])cube([6.3+.1,cut_out_r*2,3+plate_thick+.7],center=true);
    //posts
    rr=3.5/2;
    translate([10-20,7,0])
    {
    translate([25,-22,-1])cylinder(r=rr,h=post_h+2);
    translate([25,-22-49,-1])cylinder(r=rr,h=post_h+2);
    translate([25+58,-22-49,-1])cylinder(r=rr,h=post_h+2);
    translate([25+58,-22,-1])cylinder(r=rr,h=post_h+2);
    }
    translate([25-10,-22-49-10+7,plate_thick/4-.01])translate()cube([rr*2,20,plate_thick/2],center=true);
    translate([25-10+58,-22-49-10+7,plate_thick/4-.01])translate()cube([rr*2,20,plate_thick/2],center=true);
}
module mount_post()
{
    rr1=6;
    rr2=3.5;
    translate([10,0,0])
    {
    translate([25,-22,0])cylinder(r1=rr1,r2=rr2,h=post_h);
    translate([25,-22-49,0])cylinder(r1=rr1,r2=rr2,h=post_h);
    translate([25+58,-22-49,0])cylinder(r1=rr1,r2=rr2,h=post_h);
    translate([25+58,-22,0])cylinder(r1=rr1,r2=rr2,h=post_h);
    }
}
module fan()
{
    translate([54.6,0,54])rotate([90,0,0])cylinder(r=35,h=20,center=true);
    translate([54.6-35.7,0,54-35.6])rotate([90,0,0])cylinder(r=2.3,h=20,center=true);
    translate([54.6+35.8,0,54-35.6])rotate([90,0,0])cylinder(r=2.3,h=20,center=true);
    //hex
    translate([54.6-35.7,-4.5,54-35.6])rotate([90,0,0])rotate([0,0,30])cylinder(r=3.52,h=2,$fn=6,center=true);
    translate([54.6+35.8,-4.5,54-35.6])rotate([90,0,0])rotate([0,0,30])cylinder(r=3.52,h=2,$fn=6,center=true);
}
module tie_cut()
{
    translate([10-20,7,0])
    {
    translate([25,-15,0])cube([8,2,20],center=true);
    translate([83,-15,0])cube([8,2,20],center=true);
    }
}
module final()
{
    difference()
    {
        union()
        {
            base_plate();
            translate([-20,7,0])
            {
            mount_post();
            translate([25,-32.5,plate_thick-.05])scale([.8,1,1])spine();
            translate([25,-81.5,plate_thick-.05])scale([.8,1,1])spine();
            translate([75,-77.5,plate_thick-.05])rotate([0,0,93])scale([.7,1,1])spine();
            }
        }
        screw_cut();
        fan();
        tie_cut();
    }
}
final();
module spine()
{
    translate([10,0,0])
    {
    difference()
    {
        cube([71,20,5]);
        translate([0,-13.5,2-.1])spine_cut();
        translate([0,13.5,2-.1])spine_cut(); 
    }
}
}
module spine_cut()
{
    minkowski()
    {
        cube([100,20,5]);
        sphere(r=2);
    }
}
//spine();