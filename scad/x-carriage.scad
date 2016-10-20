
//translate([300,300,-192.5])import("../stl/x-carriage.stl");



carriage_w=59;
plate_t=6;
plate_h=73;
m4_hole=4.6/2;
mount_gap=23;
mount_nudge=3;
bearing_wall=2.3;
bearing_diameter = 19;   // 19=LM10UU 15=LM8UU
bearing_cut_extra = 0.4; // extra cut for linear bearings so they are not too tight.
bearing_h=29;
rod_gap=50;
bearing_inset=4.8;
center_w=19.8-plate_t;
belt_gap_w=8.9;
$fa=1;
$fs=1;
s_r=bearing_cut_extra+bearing_diameter/2+bearing_wall;
module bearing_sleeve()
{
    translate([plate_h/2-rod_gap/2,-s_r+bearing_inset,0])difference()
    {
        cylinder(r=s_r,h=carriage_w);
        bearing_cut();
    }
    translate([plate_h/2+rod_gap/2,-s_r+bearing_inset,0])difference()
    {
        cylinder(r=s_r,h=carriage_w);
        bearing_cut();
    }
    translate([0,-center_w/2,0])cube([plate_h,center_w/2+.05,carriage_w]);
    translate([10,-center_w-.05,0])cube([plate_h-20,center_w,carriage_w]);
}
module bearing_cut()
{
    b_r=bearing_cut_extra+bearing_diameter/2;
    translate([0,0,(carriage_w-bearing_h*2)/2])cylinder(r=b_r,h=bearing_h*2);
    translate([0,0,bearing_h])cylinder(r=bearing_diameter/2,h=bearing_h*4,center=true);
}
module strain_cut()
{
    translate([plate_h/2-rod_gap/2,-5-bearing_diameter/2,carriage_w/2])rotate([0,0,20])cube([8,15,carriage_w+6],center=true);
    translate([plate_h/2-rod_gap/2,-5-bearing_diameter/2,carriage_w/2])rotate([0,0,-20])cube([8,15,carriage_w+6],center=true);
    translate([plate_h/2+rod_gap/2,-5-bearing_diameter/2,carriage_w/2])rotate([0,0,-20])cube([8,15,carriage_w+6],center=true);
    translate([plate_h/2+rod_gap/2,-5-bearing_diameter/2,carriage_w/2])rotate([0,0,20])cube([8,15,carriage_w+6],center=true);
}
module base_plate()
{
    cube([plate_h,plate_t,carriage_w]);
}
module mount_holes()
{
    translate([plate_h/2-mount_gap/2,0,carriage_w/2-mount_gap/2-mount_nudge])rotate([90,0,0])cylinder(r=m4_hole,h=60,center=true,$fn=30);
    translate([plate_h/2+mount_gap/2,0,carriage_w/2-mount_gap/2-mount_nudge])rotate([90,0,0])cylinder(r=m4_hole,h=60,center=true,$fn=30);
    translate([plate_h/2+mount_gap/2,0,carriage_w/2+mount_gap/2-mount_nudge])rotate([90,0,0])cylinder(r=m4_hole,h=60,center=true,$fn=30);
    translate([plate_h/2-mount_gap/2,0,carriage_w/2+mount_gap/2-mount_nudge])rotate([90,0,0])cylinder(r=m4_hole,h=60,center=true,$fn=30);
}
module solids()
{
    base_plate();
    bearing_sleeve();
}
module belt_slot()
{
    bg_w=center_w-1;
    bt_h=11.5;
    bt_w=23;
    bt_t=center_w+1;
    translate([3+plate_h/2,-bg_w/2,carriage_w/2])cube([belt_gap_w,bg_w,carriage_w*2],center=true);
    difference()
    {
        translate([plate_h/2,-bt_t/2,+bt_h/2-.05])cube([bt_w,bt_t,bt_h],center=true);
        translate([plate_h/2+bt_w/2+.001,0,bt_h])scale([1.01,1,3])intersection()
        {
            rotate([90,0,0])cylinder(r=4,h=center_w-1);
            translate([-5,-center_w/2,-5])cube([10,center_w,10],center=true);
        }
    }
    difference()
    {
        translate([plate_h/2,-bt_t/2,carriage_w-bt_h/2+.05])cube([bt_w,bt_t,bt_h],center=true);
        
        translate([plate_h/2+bt_w/2+.001,0,-bt_h+carriage_w])mirror([0,0,1])scale([1.01,1,3])intersection()
        {
            rotate([90,0,0])cylinder(r=4,h=center_w-1);
            translate([-5,-center_w/2,-5])cube([10,center_w,10],center=true);
        }
    }
    
}
difference()
{
    
    solids();
    translate([plate_h/2+rod_gap/2,-s_r+bearing_inset,0])
    {
        bearing_cut();
    }
    translate([plate_h/2-rod_gap/2,-s_r+bearing_inset,0])
    {
        bearing_cut();
    }
    mount_holes();
    strain_cut();
    belt_slot();
}
module belt_tie()
{
    difference()
    {
        tie_r=10/2;
        tie_h=center_w+plate_t;
        union()
        {
            
            cylinder(r=tie_r,h=tie_h);
            translate([-tie_r/2,0,tie_h/2])cube([tie_r,tie_r*2,tie_h],center=true);
            for(a=[-4:2:4])
            {
                translate([-tie_r,a,0])cylinder(r=.5,h=tie_h,$fn=16);
            }
        }
        for(a=[-5:2:5])
        {
            translate([-tie_r,a,-tie_h/2])
            {
                cylinder(r=.5,h=tie_h*2,$fn=16);
                translate([-.5,0,tie_h])cube([1,1,tie_h*2],center=true);
            }
        }
        translate([-10.8,0,tie_h+.05])rotate([0,45,0])cube([10,11,10],center=true);
    }
}
translate([plate_h/2-4.7,plate_t,5])rotate([90,0,0])belt_tie();
translate([plate_h/2-4.7,plate_t,carriage_w-5])rotate([90,0,0])belt_tie();
//belt_tie();

