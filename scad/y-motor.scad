module mimic()
{
    translate([-320,-126,0])import("../stl/y-motor.stl");
}

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
ep=0.01;
base_t=10;

m_buttress_t=5;
belt_r=12;

m5slot=6;
m3slot=3.5;
$fs=.5;
$fa=1;

//motor sizing
motor_w=44; //width of the motor
bolt_space=(31/2)*sqrt(2); //center of motor to screw holes
m_plate_t=7.5;
mount_z=motor_w+base_t-2.5;

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
            translate([ext_gap/2,0])square([ext_side+ext_collar*2,ext_side+ext_collar*2],center=true);
            translate([-ext_gap/2,0])square([ext_side+ext_collar*2,ext_side+ext_collar*2],center=true);
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

module motormount()
{
    y_bump=0.5+rod_y-(m_plate_t/2)-rod_r;
    translate([0,y_bump,mount_z/2])cube([motor_w+m_buttress_t*2,m_plate_t,mount_z],center=true);
    translate([-(m_buttress_t/2+motor_w/2),y_bump-motor_w/2,mount_z/2])cube([m_buttress_t,motor_w,mount_z],center=true);
    translate([(m_buttress_t/2+motor_w/2),y_bump-motor_w/2,mount_z/2])cube([m_buttress_t,motor_w,mount_z],center=true);
}

module motorblock()
{
    
    cut_s=(0.5+rod_y-(m_plate_t)-rod_r)/sqrt(2);
    translate([0,1.1,motor_w/2+10])
    {
        cube([motor_w+ep,100,motor_w+ep],center=true);
        rotate([90,0,0])for(ii=[45:90:360])
        {
            rotate([0,0,ii])translate([bolt_space,0,0])cylinder(r=m3slot/2,h=150,center=true);
        }
    }
    z_bump=motor_w+base_t;
    translate([0,0,mount_z])rotate([45,0,0])
    {
        cube([motor_w+m_buttress_t*2+.1,cut_s*2,cut_s*2],center=true);
    }
    //spindle cutout
    translate([0,50,motor_w/2+base_t])rotate([90,0,0])cylinder(r=belt_r,h=100,center=true);
    translate([0,50,base_t+motor_w])rotate([90,0,0])cube([belt_r*2,motor_w,100],center=true);
    //screw insets
    y_bump=rod_y-(m_plate_t/2)-rod_r+m_buttress_t;
    translate([0,y_bump,motor_w/2+10])
    {
        rotate([90,0,0])for(ii=[45:90:360])
        {
            rotate([0,0,ii])translate([bolt_space,0,0])cylinder(r=m3slot*1.55,h=5,center=true);
        }
    }
}
s_width=12.7;
s_thick=23.3;
s_length=42.4;
s_wall=3.2;
module switchholder()
{
    y_bump=rod_y-(m_plate_t/2)-rod_r+m_buttress_t+1.1;
    x_bump1=motor_w/2+m_buttress_t+s_width/2-s_wall;
    x_bump2=motor_w/2+m_buttress_t+s_width-s_wall*3/2;
    translate([-(x_bump1),y_bump,s_thick/2])cube([s_width,s_length,s_thick],center=true);
    translate([-(x_bump2),y_bump-(s_length*(3/8)),(s_thick+6)/2])cube([s_wall,s_length/4,s_thick+6],center=true);
    diag=(s_length/4)*sqrt(2);
    //diagonal
    translate([-(x_bump2),y_bump-s_length/4,s_thick+6-diag/2])rotate([-45,0,0])cube([s_wall,s_length/4,s_length/4],center=true);
    //bottom
    translate([-(x_bump1),y_bump-s_length/2+s_wall/2,s_thick/2+6])cube([s_width,s_wall,s_thick],center=true);
}

module switchgap()
{
    y_bump=rod_y-(m_plate_t/2)-rod_r+m_buttress_t+1.1;
    x_bump1=motor_w/2+m_buttress_t+s_width/2-s_wall;
    translate([-(x_bump1),y_bump-s_wall/6-ep,s_thick/2+rod_plate/2+ep])cube([s_width-(s_wall*2),s_length-s_wall/3,s_thick-rod_plate],center=true);
    translate([-(x_bump1),y_bump+ep,s_thick/2+base_t/2+ep])cube([s_width-(s_wall*2),s_length,s_thick-base_t],center=true);
    side=(s_width-(s_wall*2))/sqrt(2);
    translate([-(x_bump1),y_bump-1,s_thick])rotate([90,0,0])rotate([0,0,45])cube([side,side,s_length],center=true);
    //screw slots, placed manually
    translate([-(x_bump1),y_bump+7.15,s_thick-5.5])cube([s_width*2,2.4,4],center=true);
    translate([-(x_bump1),y_bump+10+7.15,s_thick-5.5])cube([s_width*2,2.4,4],center=true);
}
module zipslot()
{
    translate([-39,16,10+(2.5/2)])cube([5,10,2.5],center=true);
}

module filled()
{
    linear_extrude(height=base_t)base();
    linear_extrude(height=20)spine();
    linear_extrude(height=20)rod_collars();
    linear_extrude(height=32)ext_collars();
    linear_extrude(height=25)feet();
    linear_extrude(height=20)sidebars();
    motormount();
    switchholder();
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
    
    translate([ext_gap/2,ext_y,18+2])rotate(90,[0,1,0])cylinder(r=m5slot/2,h=ext_side*2,center=true);
    translate([-(ext_gap/2),ext_y,18+2])rotate(90,[0,1,0])cylinder(r=m5slot/2,h=ext_side*2,center=true);
}
module speedholes()
//cut outs to reduce material usage/weight
{
    translate([0,0,ext_plate])linear_extrude(height=30)hull()
    {
        translate([30,30])circle(r=3,center=true);
        translate([55,20])circle(r=3,center=true);
        translate([55,50])circle(r=3,center=true);
    }
    translate([0,0,ext_plate])linear_extrude(height=30)hull()
    {
        translate([-30,30])circle(r=3,center=true);
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
        speedholes();
        motorblock();
        switchgap();
        zipslot();
    }
}
//extrusion_holes();
//rod_holes();
//base();
//filled();
//translate([220,0,0])mimic();

final();
