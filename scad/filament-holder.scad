module mimic()
{
    translate([1000,0,0])import("../stl/filament-mount.stl");
}
//mimic();
spool_r=160; //radius of spool that should fit
al_ext=20;  //width of aluminum extrusion
holder_w=25; //width of holder part that contacts extrusion
plate_t=4;
space=40;
ep=0.001;
rod_r=5;
//spine_l is the length of the spin
spine_l=spool_r+rod_r*2+10;
m5_slot=6;
module spine()
{
    
    translate([-(spine_l/2-ep),(space/2-plate_t/2),plate_t/2])cube([spine_l,al_ext+plate_t,plate_t],center=true);
    translate([-(spine_l/2-ep),-(space/2-plate_t/2),plate_t/2])cube([spine_l,al_ext+plate_t,plate_t],center=true);
}
module ext_holder()
{
    //right side
    translate([0,(space/2-plate_t/2),holder_w/2])cube([plate_t,al_ext+plate_t,holder_w],center=true);
    translate([(al_ext/2+plate_t/2),(space/2-plate_t/2-al_ext/2),holder_w/2])cube([al_ext+plate_t,plate_t,holder_w],center=true);
    
    
    //left side
    translate([0,-(space/2-plate_t/2),holder_w/2])cube([plate_t,al_ext+plate_t,holder_w],center=true);
    translate([(al_ext/2+plate_t/2),-(space/2-plate_t/2-al_ext/2),holder_w/2])cube([al_ext+plate_t,plate_t,holder_w],center=true);
}

module rod_holder()
{
    //right side
    translate([-spool_r,(space/2-plate_t/2),holder_w*3/8])difference()
    {
        cube([rod_r*2,al_ext,holder_w*.75],center=true);
        translate([-rod_r,0,0])cylinder(r=rod_r,h=holder_w*2,center=true,$fn=40);
    }
    
    //left side
    translate([-spool_r,-(space/2-plate_t/2),holder_w*3/8])difference()
    {
        cube([rod_r*2,al_ext,holder_w*.75],center=true);
        translate([-rod_r,0,0])cylinder(r=rod_r,h=holder_w*2,center=true,$fn=40);
    }
}

module stiff_bit()
{
    //makes the bracket stiffer
    difference()
    {
        translate([-spine_l/2,0,holder_w*3/8])cube([spine_l,plate_t,holder_w*3/4],center=true);
        translate([-(spine_l+holder_w),0,holder_w*3/4])rotate([0,45,0])cube([holder_w*2,plate_t*2,holder_w*2],center=true);
    }
    //angled peice
    difference()
    {
        rotate([0,-10,0])translate([0,0,holder_w/2])cube([spine_l/2,plate_t,holder_w],center=true);
        translate([0,0,-holder_w/2])cube([spine_l,plate_t*2,holder_w],center=true);
        translate([0,0,holder_w*3/2])cube([spine_l,plate_t*2,holder_w],center=true);
        translate([spine_l/2,0,0])cube([spine_l,plate_t*2,holder_w*3],center=true);
    }
}
module stiff()
{
    translate([0,(space/2-plate_t/2-al_ext/2),0])stiff_bit();
    translate([0,(space/2-plate_t/2+al_ext/2),0])stiff_bit();
    translate([0,-(space/2-plate_t/2-al_ext/2),0])stiff_bit();
    translate([0,-(space/2-plate_t/2+al_ext/2),0])stiff_bit();
    //rod holder
    side=(holder_w*3/4)*(sqrt(2));
    translate([-(spool_r-rod_r+ep*2),-(space/2-plate_t/2),0])difference()
    {
        rotate([0,45,0])cube([side,(al_ext+plate_t-ep),side],center=true);
        
        translate([0,0,-side])cube([side*2,2*(al_ext+plate_t),side*2],center=true);
        translate([-side,0,0])cube([side*2,2*(al_ext+plate_t),side*2],center=true);
    }
    translate([-(spool_r-rod_r+ep*2),(space/2-plate_t/2),0])difference()
    {
        rotate([0,45,0])cube([side,(al_ext+plate_t-ep),side],center=true);
        
        translate([0,0,-side])cube([side*2,2*(al_ext+plate_t),side*2],center=true);
        translate([-side,0,0])cube([side*2,2*(al_ext+plate_t),side*2],center=true);
    }
}

module screw_holes()
{
    translate([(al_ext/2+plate_t/2),(space/2-plate_t/2-al_ext/2),holder_w/2])rotate([90,0,0])cylinder(r=m5_slot/2,h=plate_t*2,center=true,$fn=35);
    translate([0,(space/2),holder_w/2])rotate([0,90,0])cylinder(r=m5_slot/2,h=plate_t*2,center=true,$fn=35);
    
    
    translate([(al_ext/2+plate_t/2),-(space/2-plate_t/2-al_ext/2),holder_w/2])rotate([90,0,0])cylinder(r=m5_slot/2,h=plate_t*2,center=true,$fn=35);
    translate([0,-(space/2),holder_w/2])rotate([0,90,0])cylinder(r=m5_slot/2,h=plate_t*2,center=true,$fn=35);
}

module speed_slot()
{
    $fn=30;
    width=holder_w/3;
    length=spool_r/8;
    cube([length,width,plate_t*4],center=true);
    translate([length/2,0,0])cylinder(r=width/2,h=plate_t*4,center=true);
    translate([-length/2,0,0])cylinder(r=width/2,h=plate_t*4,center=true);
}
module speed_holes()
{
    translate([0,(space/2-plate_t/2),0])
    {
        translate([-(spool_r/2-spool_r/4),0,0])speed_slot();
        translate([-spool_r/2,0,0])speed_slot();
        translate([-(spool_r/2+spool_r/4),0,0])speed_slot();
    }
    
    translate([0,-(space/2-plate_t/2),0])
    {
        translate([-(spool_r/2-spool_r/4),0,0])speed_slot();
        translate([-spool_r/2,0,0])speed_slot();
        translate([-(spool_r/2+spool_r/4),0,0])speed_slot();
    }
}

module complete()
{
    difference()
    {
        union()
        {
            spine();
            ext_holder();
            rod_holder();
            stiff();
        }
        speed_holes();
        screw_holes();
    }
}
complete();
    