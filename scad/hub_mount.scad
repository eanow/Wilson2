hub_w=31.6+.5;
hub_l=107.4+.5;
hub_t=10+.5;
ep=0.01;

left_buffer=15; //distance between edge of mounting strip and edge of components

plate_t=3.5;
m5_post_h=3.5+.7;
m5_slot=2.66*2;
m3_slot=3.5;
m3nut_r=6.6/2;
m3nut_t=3;

load_res_w=10+.5;
load_res_l=48.2+.5;
load_gap=9;

regulator_l=49.1+.5;
regulator_w=23.5+.5;
regulator_t=14;
rsg_xx=34; //regulator screw gap
rsg_yy=16.5;

//upper_plate_l=hub_l+left_buffer+5;
//upper_plate_w=40;
plate_yy=-20;
lower_plate_w=78+40;
lower_plate_l=80+20;
plate_overlap=1;

plate_r=3;

mount_w=18;
mount_l=lower_plate_w;//upper_plate_w+lower_plate_w;
mount_ext=15;
mount_post_r=m5_slot/2+3;
mount_inset=5;

fan_mount_h=30;
fan_base_l=110;
fan_mount_l=80;
fan_mount_yy=-20;
fan_mount_w=m3_slot+4.8;
fan_screw_space=71.5;
fan_r=76/2;
fan_w=80;

hub_hole_l=100;
hub_hole_w=12;

zip_t=2;
zip_w=8;

$fs=1;
$fa=.5;



//translate([-regulator_l/2-left_buffer+40,-20,30+plate_t])import("../stl/fan_cover.stl");

module regulator()
{
    color("red")cube([regulator_l,regulator_w,regulator_t],center=true);
}

module load_res()
{
    color("white")cube([load_res_l,load_res_w,load_res_w],center=true);
}
module hub()
{
    rotate([0,0,90])rotate([90,0,0])color("black")cube([hub_l,hub_w,hub_t],center=true);
}
//translate([0,0,regulator_t/2+plate_t])regulator();
//translate([regulator_l/2+hub_w/2+10,-20,hub_w/2+plate_t])hub();
//translate([0,-regulator_w/2-load_res_w/2-load_gap,load_res_w/2+plate_t])load_res();
//translate([0,-regulator_w/2-load_res_w/2-2*load_gap-load_res_w,load_res_w/2+plate_t])load_res();

module plate()
{
    //screws holding it to the frame
    translate([-regulator_l/2+mount_w/2-left_buffer,plate_yy,0])linear_extrude(plate_t)minkowski()
    {
        square([mount_w-plate_r*2,mount_l-plate_r*2+mount_ext],center=true);
        circle(r=plate_r);
    }
    //lower portion, under regulator and resistors
    translate([lower_plate_l/2-regulator_l/2-left_buffer,plate_yy,0])linear_extrude(plate_t)minkowski()
    {
        square([lower_plate_l-plate_r*2,lower_plate_w-plate_r*2+plate_overlap],center=true);
        circle(r=plate_r);
    }
    
}

module m5_mount()
{
    translate([-regulator_l/2+mount_w/2-left_buffer,plate_yy-mount_l/2-mount_ext/2+mount_inset/2,m5_post_h/2])cube([mount_post_r*2,mount_inset,m5_post_h],center=true);
    translate([-regulator_l/2+mount_w/2-left_buffer,plate_yy-mount_l/2-mount_ext/2+mount_inset,0])cylinder(r=mount_post_r,h=m5_post_h);
    
    translate([-regulator_l/2+mount_w/2-left_buffer,plate_yy+mount_l/2+mount_ext/2-mount_inset/2,m5_post_h/2])cube([mount_post_r*2,mount_inset,m5_post_h],center=true);
    translate([-regulator_l/2+mount_w/2-left_buffer,plate_yy+mount_l/2+mount_ext/2-mount_inset,0])cylinder(r=mount_post_r,h=m5_post_h);
}
module m5_holes()
{
    translate([-regulator_l/2+mount_w/2-left_buffer,plate_yy-mount_l/2-mount_ext/2,0])cube([m5_slot,mount_inset*2,plate_t*3],center=true);
    translate([-regulator_l/2+mount_w/2-left_buffer,plate_yy-mount_l/2-mount_ext/2+mount_inset,-ep])cylinder(r=m5_slot/2,h=plate_t*3);
    
    translate([-regulator_l/2+mount_w/2-left_buffer,plate_yy+mount_l/2+mount_ext/2,0])cube([m5_slot,mount_inset*2,plate_t*3],center=true);
    translate([-regulator_l/2+mount_w/2-left_buffer,plate_yy+mount_l/2+mount_ext/2-mount_inset,-ep])cylinder(r=m5_slot/2,h=plate_t*3);
}
module fan_mount()
{
    translate([fan_mount_w/2-regulator_l/2-left_buffer,fan_mount_yy,0])
    hull()
    {
        linear_extrude(ep)minkowski()
        {
            square([fan_mount_w-plate_r*2,fan_base_l-plate_r*2],center=true);
            circle(r=plate_r);
        }
        translate([0,0,fan_mount_h+plate_t])linear_extrude(ep)minkowski()
        {
            square([fan_mount_w-plate_r*2,fan_mount_l-plate_r*2],center=true);
            circle(r=plate_r);
        }
    }
    translate([fan_mount_w/2-regulator_l/2-left_buffer+fan_screw_space,fan_mount_yy-fan_screw_space/2,0])
    hull()
    {
        linear_extrude(ep)minkowski()
        {
            square([fan_mount_w-plate_r*2,fan_mount_w+fan_base_l-fan_mount_l-plate_r*2],center=true);
            circle(r=plate_r);
        }
        translate([0,0,fan_mount_h+plate_t])linear_extrude(ep)minkowski()
        {
            square([fan_mount_w-plate_r*2,fan_mount_w-plate_r*2],center=true);
            circle(r=plate_r);
        }
    }
    translate([fan_mount_w/2-regulator_l/2-left_buffer+fan_screw_space,fan_mount_yy+fan_screw_space/2,0])
    hull()
    {
        linear_extrude(ep)minkowski()
        {
            square([fan_mount_w-plate_r*2,fan_mount_w+fan_base_l-fan_mount_l-plate_r*2],center=true);
            circle(r=plate_r);
        }
        translate([0,0,fan_mount_h+plate_t])linear_extrude(ep)minkowski()
        {
            square([fan_mount_w-plate_r*2,fan_mount_w-plate_r*2],center=true);
            circle(r=plate_r);
        }
    }
}
module fan_mount_holes()
{
    slot_d=m3nut_r*sqrt(3);
    translate([-fan_screw_space/2+fan_w/2-regulator_l/2-left_buffer,fan_mount_yy,0])
    {
        translate([0,-fan_screw_space/2,-ep])cylinder(r=m3_slot/2,h=fan_mount_h+plate_t+1);
        translate([0,fan_screw_space/2,-ep])cylinder(r=m3_slot/2,h=fan_mount_h+plate_t+1);   
            //hex
        translate([0,0,fan_mount_h/2])hull()
        {
            translate([0,fan_screw_space/2,0])cylinder(r=m3nut_r,h=m3nut_t,$fn=6);
            translate([0,fan_screw_space/2,0])cylinder(r=m3_slot/2,h=m3nut_t+1,$fn=6);
        }
        translate([-fan_mount_w/2,fan_screw_space/2,fan_mount_h/2+(m3nut_t)/2])cube([fan_mount_w,slot_d,m3nut_t+1],center=true);
        translate([0,0,fan_mount_h/2])hull()
        {
            translate([0,-fan_screw_space/2,0])cylinder(r=m3nut_r,h=m3nut_t,$fn=6);
            translate([0,-fan_screw_space/2,0])cylinder(r=m3_slot/2,h=m3nut_t+1,$fn=6);
        }
        translate([-fan_mount_w/2,-fan_screw_space/2,fan_mount_h/2+(m3nut_t)/2])cube([fan_mount_w,slot_d,m3nut_t+1],center=true);
    }
    translate([fan_screw_space/2+fan_w/2-regulator_l/2-left_buffer,fan_mount_yy,0])
    {
        translate([0,-fan_screw_space/2,-ep])cylinder(r=m3_slot/2,h=fan_mount_h+plate_t+1);
        translate([0,fan_screw_space/2,-ep])cylinder(r=m3_slot/2,h=fan_mount_h+plate_t+1);         
        translate([0,0,fan_mount_h/2])hull()
        {
            translate([0,fan_screw_space/2,0])cylinder(r=m3nut_r,h=m3nut_t,$fn=6);
            translate([0,fan_screw_space/2,0])cylinder(r=m3_slot/2,h=m3nut_t+1,$fn=6);
        }
        translate([fan_mount_w/2,fan_screw_space/2,fan_mount_h/2+(m3nut_t)/2])cube([fan_mount_w,slot_d,m3nut_t],center=true);
        translate([0,0,fan_mount_h/2])hull()
        {
            translate([0,-fan_screw_space/2,0])cylinder(r=m3nut_r,h=m3nut_t,$fn=6);
            translate([0,-fan_screw_space/2,0])cylinder(r=m3_slot/2,h=m3nut_t+1,$fn=6);
        }
        translate([fan_mount_w/2,-fan_screw_space/2,fan_mount_h/2+(m3nut_t/2)])cube([fan_mount_w,slot_d,m3nut_t],center=true);
    }
}
module fan_clearance()
{
    translate([fan_mount_w/2-regulator_l/2-left_buffer+fan_screw_space/2,fan_mount_yy,0])cylinder(r=fan_r,h=fan_mount_h+plate_t+5);
}
module hub_clearance()
{
    translate([regulator_l/2+hub_w/2+10,-20,plate_t])cube([hub_hole_w,hub_hole_l,plate_t*3],center=true);
}
module zip_holes()
{
    //hub, semi-manuall placed
    translate([regulator_l/2+hub_w/2,25,-ep])linear_extrude(plate_t*10)minkowski()
    {
        square([zip_t-1,zip_w-1],center=true);
        circle(r=.5,$fn=26);
    }
    translate([regulator_l/2+hub_w/2,-65,-ep])linear_extrude(plate_t*10)minkowski()
    {
        square([zip_t-1,zip_w-1],center=true);
        circle(r=.5,$fn=26);
    }
    //load resistors
    translate([0,-load_gap/2-regulator_w/2,-ep])linear_extrude(plate_t*10)minkowski()
    {
        square([2*zip_w-1,zip_t-1],center=true);
        circle(r=.5,$fn=26);
    }

    translate([0,-load_gap*3/2-regulator_w/2-load_res_w,-ep])linear_extrude(plate_t*10)minkowski()
    {
        square([2*zip_w-1,zip_t-1],center=true);
        circle(r=.5,$fn=26);
    }
    translate([0,-load_gap*5/2-regulator_w/2-load_res_w*2,-ep])linear_extrude(plate_t*10)minkowski()
    {
        square([2*zip_w-1,zip_t-1],center=true);
        circle(r=.5,$fn=26);
    }
    //regulator
    translate([-rsg_xx/2,rsg_yy/2,-ep])cylinder(r=1.75,h=plate_t*5);
    translate([rsg_xx/2,-rsg_yy/2,-ep])cylinder(r=1.75,h=plate_t*5);
    translate([-rsg_xx/2,regulator_w/2+2,-ep])linear_extrude(plate_t*10)minkowski()
    {
        square([zip_w-1,zip_t-1],center=true);
        circle(r=.5,$fn=26);
    }
    translate([rsg_xx/2,-regulator_w/2-2,-ep])linear_extrude(plate_t*10)minkowski()
    {
        square([zip_w-1,zip_t-1],center=true);
        circle(r=.5,$fn=26);
    }
}
module hub_stab()
{
    smaller=80;
    difference()
    {
        translate([lower_plate_l/2-regulator_l/2-left_buffer+smaller/2,plate_yy,0])linear_extrude(plate_t+5)minkowski()
        {

            square([lower_plate_l-plate_r*2-smaller,lower_plate_w-plate_r*2+plate_overlap],center=true);
            circle(r=plate_r);
        
        }
        translate([regulator_l/2+hub_w/2+10,-20,hub_w/2+plate_t])hub();
    }
}
module load_stab()
{
    smaller_x=42;
    smaller_y=50;
    difference()
    {
        translate([0,plate_yy,0])linear_extrude(plate_t+3)minkowski()
        {

            square([lower_plate_l-plate_r*2-smaller_x,-smaller_y+lower_plate_w-plate_r*2+plate_overlap],center=true);
            circle(r=plate_r);
        
        }
        translate([0,0,regulator_t/2+plate_t])regulator();
        translate([0,-regulator_w/2-load_res_w/2-load_gap,load_res_w/2+plate_t])load_res();
        translate([0,-regulator_w/2-load_res_w/2-2*load_gap-load_res_w,load_res_w/2+plate_t])load_res();
    }   
}
difference()
{
    union()
    {
        plate();
        m5_mount();
        difference()
        {
            fan_mount();
            fan_clearance();
        }
        hub_stab();
        load_stab();
    }
    m5_holes();
    fan_mount_holes();
    hub_clearance();
    zip_holes();
}
        