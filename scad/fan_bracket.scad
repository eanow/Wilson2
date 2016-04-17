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
translate([0,(fansize/2+hingeknee),0])
rotate(-kneeangle,[1,0,0])translate([-(arm_gap+wall_thick/2),(slotlength/2),0])arm();
translate([-(arm_gap+wall_thick/2),fansize/2+hingeknee-ep,0])hinge();
translate([-(wall_thick/2+hingegap/2),fansize/2+hingeknee-ep,0])hinge();
translate([(wall_thick/2+hingegap/2),fansize/2+hingeknee-ep,0])hinge();
fanholder();
