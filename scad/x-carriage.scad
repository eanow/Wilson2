//%translate([39,-40,0])import("../x-carriage.stl");
//translate([plate_h,0,carriage_w])rotate([0,180,0])import("../stl/x-carriage.stl");
final();
carriage_w=59;
plate_t=6;
plate_h=73;
m4_hole=4.5/2;
mount_gap=23;
mount_nudge=-2.6;
bearing_wall=2.3;
bearing_diameter = 19;   // 19=LM10UU 15=LM8UU
bearing_cut_extra = 0.12; //0.4;// extra cut for linear bearings so they are not too tight.
bearing_h=29;
rod_gap=50;
bearing_inset=4.8;
center_w=19.8-plate_t;
belt_gap_w=8.9;
$fa=1;
$fs=1;
s_r=bearing_cut_extra+bearing_diameter/2+bearing_wall;
ep=0.001;
//rack and pinion addtions
rack_cage_w=19.8;
rack_cage_h=9.7;
rack_cage_l=56;
rack_w=10.5;
rack_h=8.8;
rack_nudge=.75; //nudge in the y direction
rack_window_l=38;
rack_window_b=6; //distance from bottom
rack_window_point=8.5;//extra distance at the top
rack_point_w=1.8;
axle_mount_r=5.8;
axle_offset=11.9;
axle_pos=25;
m3_slot=3.5;
m3_nut_t=2;
m3_nut_r=6.6/2;
m3_head_t=2.5;
m3_head_r=6.1/2;
spring_mount_h=2.75;
sm_pos=14.7;
sm_offset=-1.6;
cable_w=5; //cable channel width
cable_h=4;
module rack_cage()
{
    translate([-rack_cage_h/2+ep+5,plate_t-rack_cage_w/2,rack_cage_l/2])cube([rack_cage_h+10,rack_cage_w,rack_cage_l],center=true);
    //axles
    hull()
    {
        translate([-axle_offset,plate_t-rack_cage_w/2,axle_pos])rotate([90,0,0])cylinder(r=axle_mount_r,h=rack_cage_w,center=true,$fn=50);
        translate([-rack_cage_h/2+ep+5,plate_t-rack_cage_w/2,.5])cube([rack_cage_h+10,rack_cage_w,1],center=true);
    }
    //spring holding cones
    rr1=m3_slot/2+1.2;
    rr2=rr1+spring_mount_h*.6;
    translate([sm_offset,spring_mount_h/2+plate_t-ep,sm_pos])rotate([90,0,0])cylinder(r1=rr1,r2=rr2,h=spring_mount_h,$fn=50,center=true);
    translate([sm_offset,-spring_mount_h/2-rack_cage_w+plate_t+ep,sm_pos])rotate([-90,0,0])cylinder(r1=rr1,r2=rr2,h=spring_mount_h,$fn=50,center=true);
    //cable management
    translate([plate_h/4+plate_h/4,.5*(cable_w+1.2)+plate_t,.5*(cable_h+2.4)])cube([plate_h/2,cable_w+1.2,cable_h+2.4],center=true);
}
module rack_channel()
{
    //body of the rack
    translate([-rack_h/2,rack_nudge-rack_w/2,carriage_w/2])cube([rack_h,rack_w,carriage_w*2],center=true);
    //'window' for the moving rack and pinion
    //hull two rectangles for nice trapezoidal look
    translate([-rack_cage_h/2-rack_h+.1,rack_nudge-rack_w/2,rack_window_l/2+rack_window_b])
    {
        hull()
        {
            cube([rack_cage_h,rack_w,rack_window_l],center=true);
            translate([0,0,rack_window_point/2])cube([rack_cage_h,rack_point_w,rack_window_l+rack_window_point],center=true);
        }
    }
    //m3 hole
    translate([-axle_offset,plate_t-rack_cage_w/2,axle_pos])rotate([90,0,0])cylinder(r=m3_slot/2,h=rack_cage_w*2,center=true,$fn=50);
    //hex slot
    translate([-axle_offset,-rack_cage_w+m3_nut_t/2+plate_t-ep,axle_pos])rotate([90,0,0])rotate([0,0,30])cylinder(r=m3_nut_r,h=m3_nut_t,center=true,$fn=6);
    //head slot
    translate([-axle_offset,-m3_head_t/2+plate_t+ep,axle_pos])rotate([90,0,0])rotate([0,0,30])cylinder(r=m3_head_r,h=m3_head_t,center=true,$fn=50);
    //spring mount hole, needs to be tapped/tight
    translate([sm_offset,rack_nudge+rack_cage_w/2+.8,sm_pos])rotate([90,0,0])cylinder(r=m3_slot/2-.25,h=rack_cage_w,$fn=50,center=true);
    translate([sm_offset,rack_nudge-rack_cage_w/2-rack_w-.8,sm_pos])rotate([90,0,0])cylinder(r=m3_slot/2-.25,h=rack_cage_w,$fn=50,center=true);
    //cable management
    translate([plate_h/4+plate_h/4,.5*(cable_w)+plate_t,.5*(cable_h+2.4)])cube([plate_h/2+1,cable_w,cable_h],center=true);
    //annulus
    //placed manually
    translate([-rack_cage_h-2.2,plate_t,8])rotate([0,-20,0])difference()
    {
        cylinder(r=4,h=3,center=true);
        cylinder(r=2.5,h=4,center=true);
    }
}
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
    rack_cage();
}
module belt_slot()
{
    bg_w=center_w-1;
    bt_h=12;
    bt_w=23;
    bt_t=center_w+1;
    translate([-3+plate_h/2,-bg_w/2,carriage_w/2])cube([belt_gap_w,bg_w,carriage_w*2],center=true);
    difference()
    {
        translate([plate_h/2,-bt_t/2,+bt_h/2-.05])cube([bt_w,bt_t,bt_h],center=true);
        translate([plate_h/2-bt_w/2-.001,0,bt_h])scale([1.01,1,3])intersection()
        {
            rotate([90,0,0])cylinder(r=4,h=center_w-1);
            translate([+5,-center_w/2,-5])cube([10,center_w,10],center=true);
        }
    }
    difference()
    {
        translate([plate_h/2,-bt_t/2,carriage_w-bt_h/2+.05])cube([bt_w,bt_t,bt_h],center=true);
        
        translate([plate_h/2-bt_w/2-.001,0,-bt_h+carriage_w])mirror([0,0,1])scale([1.01,1,3])intersection()
        {
            rotate([90,0,0])cylinder(r=4,h=center_w-1);
            translate([5,-center_w/2,-5])cube([10,center_w,10],center=true);
        }
    }
    
}
module final()
{
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
        rack_channel();
    }
    translate([plate_h/2+4.7,plate_t,5])mirror([1,0,0])rotate([90,0,0])belt_tie();
translate([plate_h/2+4.7,plate_t,carriage_w-5])mirror([1,0,0])rotate([90,0,0])belt_tie();
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

//belt_tie();

