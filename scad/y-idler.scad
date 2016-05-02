module mimic()
{
    translate([-320,-126,0])import("../stl/y-idler.stl");
}
//mimic();
include<y-tensioner.scad>
ext_gap=155.3; //distance, center to center, of 2020 extrusions
rod_gap=170; //distance, center to center, of 10mm rods
ext_y=30.64; //distance, floor to center of extrusions
rod_y=63.38; //distance, floor to center of rods
ext_plate=4.0; //thickness of plate past the extrusions
rod_plate=4.0; //thickness of plate past the rods
ext_collar=3.75; //thickness around 2020 extrusions
rod_collar=4.8; //thickness around 10mm rods
ext_side=20.7;
rod_r=5.25;
arc=120; //top and bottom arcs
tens_collar=4; //space around tensioner
tens_w=shaft_h+1;
tens_h=shaft_w+1;
tens_plate=4;
tens_y=50; //gap between floor and bottom of tensioner
m5slot=6;
$fs=.5;
$fa=1;

module ext_holes()
{
    translate([0,ext_y,25+ext_plate])
    {
        //2020 size
        
        notch=5.1;
        difference()
        {
            union()
            {
            translate([ext_gap/2,0,0])cube([ext_side,ext_side,50],center=true);
            translate([-ext_gap/2,0,0])cube([ext_side,ext_side,50],center=true);
            }
            //notches
            translate([ext_gap/2,ext_side/2-.55,0])cube([notch,notch,1.5*50],center=true);
            translate([-ext_gap/2,ext_side/2-.55,0])cube([notch,notch,1.5*50],center=true);
        }
    }
}

module rod_holes()
{
    //rod size
    
    translate([0,rod_y,25+rod_plate])
    {
        translate([rod_gap/2,0,0])cylinder(r=rod_r,h=50,center=true);
        translate([-rod_gap/2,0,0])cylinder(r=rod_r,h=50,center=true);
    }
    //relief notches
    translate([0,rod_y+10,25+rod_plate])
    {
        translate([rod_gap/2,0,0])cube([2,20,50],center=true);
        translate([-rod_gap/2,0,0])cube([2,20,50],center=true);
    }
}

module base_plate()
{
    //2d plate base
    hull()
    {
    translate([0,rod_y/2])square([ext_gap+ext_side+ext_collar,rod_y],center=true);
    translate([rod_gap/2,rod_y])circle(r=rod_r+rod_collar,center=true);
    translate([-rod_gap/2,rod_y])circle(r=rod_r+rod_collar,center=true);
    }
}
module base()
{
    //swoopy bits
    difference()
    {
        base_plate();
        
        translate([0,-arc+20])circle(r=arc,center=true);
        difference()
        {
            translate([0,arc-20+rod_y+rod_collar])circle(r=arc,center=true);
            translate([0,-rod_gap/2+66])square([rod_gap,rod_gap],center=true);
        }
    }
}
module spine()
{
    difference()
    {
        translate([0,-arc+20])circle(r=arc+2,center=true);
        translate([0,-arc+20])circle(r=arc,center=true);
        translate([0,-3*arc/2])square([arc*3,arc*3],center=true);
    }
}
module rod_collars()
{
    translate([rod_gap/2,rod_y])circle(r=rod_r+rod_collar,center=true);
    translate([-rod_gap/2,rod_y])circle(r=rod_r+rod_collar,center=true);
}
module ext_collars()
{
    translate([0,ext_y])
    {
            translate([ext_gap/2,0])square([ext_side+ext_collar*2,ext_side+ext_collar],center=true);
            translate([-ext_gap/2,0])square([ext_side+ext_collar*2,ext_side+ext_collar],center=true);
    }
}
module feet()
//stuff below the extrusions
{
    translate([0,(ext_side+ext_collar)/2])
    {
            translate([ext_gap/2,0])square([ext_side+ext_collar*2,ext_side+ext_collar],center=true);
            translate([-ext_gap/2,0])square([ext_side+ext_collar*2,ext_side+ext_collar],center=true);
    }
}
module sidebars()
//connection between rod and extrusion collars for strength
{
    difference()
    {
        base_plate();
        rotate(3.5,[0,0,1])square([ext_gap+10,200],center=true);
        rotate(-3.5,[0,0,1])square([ext_gap+10,200],center=true);
        square([ext_gap*2,80],center=true);
    }
}
module tension_guide()
{
    linear_extrude(height=20)translate([0,tens_h/2+tens_y])square([tens_w+tens_collar*2+25,tens_h+tens_collar*2],center=true);
}
module tension_hole()
{
    translate([0,tens_h/2+tens_y-.4,tens_plate+30])cube([tens_w,tens_h,60],center=true);
    translate([tens_w/2+15+2,tens_y+tens_h/2,10+15])rotate(90,[1,0,0])cylinder(r=(25-10),h=tens_h*2,center=true);
    translate([-(tens_w/2+15+2),tens_y+tens_h/2,10+15])rotate(90,[1,0,0])cylinder(r=(25-10),h=tens_h*2,center=true);
    
    //m3 screw holes
    slot_d=m3nut_r*sqrt(3);
    translate([0,tens_y+shaft_w/2,0])rotate([0,270,0])
    {
    translate([m3screw_l/2-ep,0,shaft_h/2-1.5-slot_d/2])rotate([90,0,90])cylinder(r=m3slot/2+.3,h=m3screw_l+3,center=true);
    translate([m3screw_l/2-ep,0,-(shaft_h/2-1.5-slot_d/2)])rotate([90,0,90])cylinder(r=m3slot/2+.3,h=m3screw_l+3,center=true);
    }
}

module filled()
{
    linear_extrude(height=10)base();
    linear_extrude(height=20)spine();
    linear_extrude(height=20)rod_collars();
    linear_extrude(height=25)ext_collars();
    linear_extrude(height=25)feet();
    linear_extrude(height=20)sidebars();
    tension_guide();
    
}
module foot_holes()
{
    translate([0,ext_side/2+ext_collar*2,25+ext_plate+6])
    {
        translate([ext_gap/2+1.5,0,0])cube([ext_side-3,ext_side,50],center=true);
        translate([-ext_gap/2-1.5,0,0])cube([ext_side-3,ext_side,50],center=true);
    }
}
module screwholes()
{
    
    translate([ext_gap/2,ext_y,18])rotate(90,[0,1,0])cylinder(r=m5slot/2,h=ext_side*2,center=true);
    translate([-(ext_gap/2),ext_y,18])rotate(90,[0,1,0])cylinder(r=m5slot/2,h=ext_side*2,center=true);
}
module speedholes()
//cut outs to reduce material usage/weight
{
    translate([0,0,tens_plate])linear_extrude(height=30)hull()
    {
        translate([20,30])circle(r=3,center=true);
        translate([55,20])circle(r=3,center=true);
        translate([55,50])circle(r=3,center=true);
    }
    translate([0,0,tens_plate])linear_extrude(height=30)hull()
    {
        translate([-20,30])circle(r=3,center=true);
        translate([-55,20])circle(r=3,center=true);
        translate([-55,50])circle(r=3,center=true);
    }
}
module final()
{
    difference()
    {
        filled();
        ext_holes();
        rod_holes();
        foot_holes();
        screwholes();
        tension_hole();
        speedholes();
    }
}
//extrusion_holes();
//rod_holes();
//base();
//filled();
final();
translate([0,tens_y+shaft_w/2,tens_plate])rotate([0,270,0])complete();