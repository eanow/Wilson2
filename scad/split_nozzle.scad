fansize=40;
holespace=32;
round_r=4;
bracket_h=8;
wall_thick=4;
m3_tap=3;
m3_slot=3.5;
$fa=.5;
$fs=.5;
print_buff=1.2;
hingeknee=12; //distance from edge of fanholder to pivor point
kneeangle=45; //angle of fan mount, from straight out
hingegap=6.25; //space between hinge brackets
slotlength=37; //angle-holding arm slot length
arm_gap=10; //center of hinge to arm side
arm_h=8;//how tall arm should be
ep=0.001; //small value, used to nudge and eliminate abiguity on faces touching
module extruder()
{
    import("../stl/extruder_main.stl");
}
module hotend()
{
    import("../stl/e3dmockup.stl");
}
module fansquare()
{
    difference()
    {
        union()
        {
        //circles on four corners
        offsets=(fansize/2)-round_r;
        translate([-offsets,-offsets,0])cylinder(h=bracket_h,r=round_r,center=true);
        translate([-offsets,offsets,0])cylinder(h=bracket_h,r=round_r,center=true);
        translate([offsets,offsets,0])cylinder(h=bracket_h,r=round_r,center=true);
        translate([offsets,-offsets,0])cylinder(h=bracket_h,r=round_r,center=true);
        rotate(0,[0,0,1])translate([-(offsets-wall_thick/2+round_r),0,0])cube([wall_thick,offsets*2,bracket_h],center=true);
        rotate(90,[0,0,1])translate([-(offsets-wall_thick/2+round_r),0,0])cube([wall_thick,offsets*2,bracket_h],center=true);
        rotate(180,[0,0,1])translate([-(offsets-wall_thick/2+round_r),0,0])cube([wall_thick,offsets*2,bracket_h],center=true);
        rotate(270,[0,0,1])translate([-(offsets-wall_thick/2+round_r),0,0])cube([wall_thick,offsets*2,bracket_h],center=true);   
        }
        //clean up inside
        cube([(fansize-wall_thick*2),(fansize-wall_thick*2),bracket_h*2],center=true);
    }
}
module fanholder()
{
    difference()
    {
        union()
        {
        fansquare();
        //mounting holes buffer
                translate([-holespace/2,-holespace/2,0])cylinder(h=bracket_h,r=(m3_slot/2)+print_buff,center=true);
                translate([-holespace/2,holespace/2,0])cylinder(h=bracket_h,r=(m3_slot/2)+print_buff,center=true);
                translate([holespace/2,holespace/2,0])cylinder(h=bracket_h,r=(m3_slot/2)+print_buff,center=true);
                translate([holespace/2,-holespace/2,0])cylinder(h=bracket_h,r=(m3_slot/2)+print_buff,center=true);
        }
        translate([-holespace/2,-holespace/2,0])cylinder(h=bracket_h*2,r=(m3_slot/2),center=true);
        translate([-holespace/2,holespace/2,0])cylinder(h=bracket_h*2,r=(m3_slot/2),center=true);
        translate([holespace/2,holespace/2,0])cylinder(h=bracket_h*2,r=(m3_slot/2),center=true);
        translate([holespace/2,-holespace/2,0])cylinder(h=bracket_h*2,r=(m3_slot/2),center=true);
    }
}
module hinge()
{
    rotate(180,[1,0,0])rotate(90,[0,1,0])difference()
    {
        union()
        {
            cylinder(r=bracket_h/2,h=wall_thick,center=true);
            translate([0,hingeknee/2,0])cube([bracket_h,hingeknee,wall_thick],center=true);
        }
        cylinder(r=m3_slot/2,h=wall_thick*2,center=true);
    }
}
module arm()
{
    difference()
    {
        union()
        {
            cube([wall_thick,slotlength,arm_h],center=true);
            translate([0,slotlength/2,0])rotate(90,[0,1,0])cylinder(r=arm_h/2,h=wall_thick,center=true);
            translate([0,-slotlength/2,0])rotate(90,[0,1,0])cylinder(r=arm_h/2,h=wall_thick,center=true);
        }
        cube([wall_thick*2,slotlength,m3_slot],center=true);
        translate([0,slotlength/2,0])rotate(90,[0,1,0])cylinder(r=m3_slot/2,h=wall_thick*2,center=true);
        translate([0,-slotlength/2,0])rotate(90,[0,1,0])cylinder(r=m3_slot/2,h=wall_thick*2,center=true);
    }
}
module assembled()
{
translate([0,(fansize/2+hingeknee),0])
rotate(-kneeangle,[1,0,0])translate([-(arm_gap+wall_thick/2),(slotlength/2),0])arm();
translate([-(arm_gap+wall_thick/2),fansize/2+hingeknee-ep,0])hinge();
translate([-(wall_thick/2+hingegap/2),fansize/2+hingeknee-ep,0])hinge();
translate([(wall_thick/2+hingegap/2),fansize/2+hingeknee-ep,0])hinge();
fanholder();
}
module split()
{
    union()
    {
        translate([-(slotlength/2+arm_gap-ep),(slotlength+fansize/2+hingeknee+bracket_h/2),0])cube([slotlength,slotlength*2,slotlength*2],center=true);
        translate([-(slotlength/2+arm_gap-ep),(slotlength+fansize/2+hingeknee+bracket_h/2-bracket_h),-(slotlength+arm_h/2+ep)])cube([slotlength,slotlength*2,slotlength*2],center=true);
        translate([-(slotlength/2+arm_gap-ep+wall_thick/2),(slotlength+fansize/2+hingeknee-bracket_h/2),0])cube([slotlength,slotlength*2,slotlength*2],center=true);
    }
}
//split into two parts
//part a
module subA()
{
    intersection()
    {
        split();
        assembled();
    }
}
module subB()
{
    difference()
    {
        assembled();
        split();
        
    }
}
nozplate=2; //thickness of nozzle baseplate
k1gap=36; //shift at first knee
k2gap=45;
k3gap=42;
k3down=3; //shift the end down a bit
shell_t=1;
duct0h=24;
duct1h=10;
duct2h=24;
duct0r=36/2;
duct1r=28/2;
duct2r=18/2;
duct3r=12/2;
module duct1(inset)
{
    hull()
    {
        cylinder(r=duct0r-inset,h=ep,center=true);
        translate([k1gap/2,0,duct0h])cylinder(r=duct1r-inset,h=ep,center=true);
    }
    hull()
    {
        cylinder(r=duct0r-inset,h=ep,center=true);
        translate([-k1gap/2,0,duct0h])cylinder(r=duct1r-inset,h=ep,center=true);
    }
}
module duct2(inset)
{
    hull()
    {
        translate([k1gap/2,0,duct0h-ep])cylinder(r=duct1r-inset,h=ep,center=true);
        translate([0,0,duct0h])rotate(kneeangle/2,[1,0,0])translate([k2gap/2,0,duct1h])cylinder(r=duct2r-inset,h=ep,center=true);
    }
    hull()
    {
        translate([-k1gap/2,0,duct0h-ep])cylinder(r=duct1r-inset,h=ep,center=true);
        translate([0,0,duct0h])rotate(kneeangle/2,[1,0,0])translate([-k2gap/2,0,duct1h])cylinder(r=duct2r-inset,h=ep,center=true);
    }
}
module duct3(inset)
{
    hull()
    {
        translate([0,0,duct0h-ep])rotate(kneeangle/2,[1,0,0])translate([k2gap/2,0,duct1h])cylinder(r=duct2r-inset,h=ep,center=true);
        translate([0,k3down,duct0h])rotate(kneeangle/2,[1,0,0])translate([0,0,duct1h])rotate(kneeangle/2,[1,0,0])translate([k3gap/2,0,duct2h])cylinder(r=duct3r-inset,h=ep,center=true);
        //endcap
        translate([0,k3down,duct0h])rotate(kneeangle/2,[1,0,0])translate([0,0,duct1h])rotate(kneeangle/2,[1,0,0])translate([k3gap/2,0,duct2h])sphere(r=duct3r-inset,center=true);
    }
    hull()
    {
        translate([0,0,duct0h-ep])rotate(kneeangle/2,[1,0,0])translate([-k2gap/2,0,duct1h])cylinder(r=duct2r-inset,h=ep,center=true);
        translate([0,k3down,duct0h])rotate(kneeangle/2,[1,0,0])translate([0,0,duct1h])rotate(kneeangle/2,[1,0,0])translate([-k3gap/2,0,duct2h])cylinder(r=duct3r-inset,h=ep,center=true);
        translate([0,k3down,duct0h])rotate(kneeangle/2,[1,0,0])translate([0,0,duct1h])rotate(kneeangle/2,[1,0,0])translate([-k3gap/2,0,duct2h])sphere(r=duct3r-inset,center=true);
    }
}
module nozzle()
{
    difference()
    {
        union()
        {
        //plate
        linear_extrude(height=nozplate)minkowski()
        {
            square([fansize-round_r*2,fansize-round_r*2],center=true);
            circle(r=round_r);
        }
        //first duct
        duct1(0);
        }
        translate([0,0,-ep/2])scale([1,1,1+ep])duct1(shell_t);
        translate([-holespace/2,-holespace/2,ep])cylinder(h=nozplate*2,r=(m3_slot/2),center=true);
        translate([-holespace/2,holespace/2,ep])cylinder(h=nozplate*2,r=(m3_slot/2),center=true);
        translate([holespace/2,holespace/2,ep])cylinder(h=nozplate*2,r=(m3_slot/2),center=true);
        translate([holespace/2,-holespace/2,ep])cylinder(h=nozplate*2,r=(m3_slot/2),center=true);
    }
    difference()
    {
        duct2(0);
        translate([0,0,+ep])duct2(shell_t);
        translate([0,0,-ep])duct2(shell_t);
    }
    difference()
    {
        duct3(0);
        translate([0,0,+ep])duct3(shell_t);
        translate([0,0,-ep])duct3(shell_t);
        //air slots
        //added in extra translate
        translate([17,-10,48])rotate(kneeangle,[1,0,0])translate([0,1,-2])cube([6,4,15],center=true);
        translate([-17,-10,48])rotate(kneeangle,[1,0,0])translate([0,1,-2])cube([6,4,15],center=true);
    }
}
module assembly()
{
rotate(kneeangle,[1,0,0])translate([0,-(fansize/2+hingeknee),0])
{
subB();
subA();
}
translate([-15,64.5,-20])rotate(90,[1,0,0])rotate(90,[0,1,0])extruder();
translate([0,22,-16])rotate(270,[0,0,1])rotate(90,[1,0,0])hotend();
}
//assembly();
//rotate(-(180-kneeangle),[1,0,0])translate([0,(fansize/2+hingeknee),bracket_h/2])nozzle();
nozzle();