fansize=40;
holespace=32;
round_r=4;

$fa=.5;
$fs=.5;
print_buff=1.2;


bracket_h=8; //thickness of bracket, Z
hingegap=6.25; //space between hinge brackets
wall_thick=4; //thickness of stuff, x-y
m3_slot=3.5; //diameter of space for M3 to slide in
arm_gap=10; //center of hinge to arm side
slotlength=47; //angle-holding arm slot length
fan_setback=22; //distance from center of fanbracket to center of hingehole
fan_angle=30;
bra_z=30;//bracket adjustments
bra_xl=30;
bra_xr=43;
tonguex=20;
tonguey=10;
arm_off1=9;
arm_off2=-14;
slot_w=9;


arm_h=8;//how tall arm should be
ep=0.001; //small value, used to nudge and eliminate abiguity on faces touching

module extruder()
{
    import("../stl/extruder_main.stl");
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
        translate([0,-arm_off1,0])
        {
        cube([wall_thick*2,slot_w,m3_slot],center=true);
        translate([0,slot_w/2,0])rotate(90,[0,1,0])cylinder(r=m3_slot/2,h=wall_thick*2,center=true);
        translate([0,-slot_w/2,0])rotate(90,[0,1,0])cylinder(r=m3_slot/2,h=wall_thick*2,center=true);
        }
        translate([0,-arm_off2,0])
        {
        cube([wall_thick*2,slot_w,m3_slot],center=true);
        translate([0,slot_w/2,0])rotate(90,[0,1,0])cylinder(r=m3_slot/2,h=wall_thick*2,center=true);
        translate([0,-slot_w/2,0])rotate(90,[0,1,0])cylinder(r=m3_slot/2,h=wall_thick*2,center=true);
        }
        translate([0,-slotlength/2,0])rotate(90,[0,1,0])cylinder(r=m3_slot/2,h=wall_thick*2,center=true);
    }
}
module m_cir()
{
    //hingey circles
    rotate(180,[1,0,0])rotate(90,[0,1,0])difference()
    {
        union()
        {
            cylinder(r=bracket_h/2,h=wall_thick,center=true);
            translate([0,bracket_h/2,0])cube([bracket_h,bracket_h,wall_thick],center=true);
        }
        cylinder(r=m3_slot/2,h=wall_thick*2,center=true);
    }
}
module extruder_bracket()
//bit that screws to the extruder
{
    translate([-(wall_thick/2+hingegap/2),0,0])m_cir();
    translate([-(wall_thick/2+hingegap/2)-4,0,0])m_cir();
    translate([(wall_thick/2+hingegap/2),0,0])m_cir();
    translate([-(arm_gap+wall_thick/2),(slotlength/2),0])arm();
    difference()
    {
    translate([-(arm_gap+wall_thick/2),0,0])rotate(180,[1,0,0])rotate(90,[0,1,0])
        translate([0,bracket_h/2,0])cube([bracket_h,bracket_h,wall_thick],center=true);
        //hacky, remove half a hole
        translate([-(arm_gap+wall_thick/2),(slotlength/2),0])
        translate([0,-slotlength/2,0])rotate(90,[0,1,0])cylinder(r=m3_slot/2,h=wall_thick*2,center=true);
    }
    //left side
    translate([-bra_xl,fan_setback,-bra_z])rotate((90-fan_angle),[0,-1,0])fanholder();
    bump=3.5;
    difference()
    {
        
        translate([-bra_xl,fan_setback+bump,-bra_z])rotate((90-fan_angle),[0,-1,0])
        translate([(fansize/2)+tonguex/2,0,0])cube([tonguex,tonguey,bracket_h],center=true);
        //trim back down
        translate([0,0,10+arm_h/2])cube([100,100,20],center=true);
        translate([0,0,0])cube([(arm_gap*2),100,20],center=true);
    }
    //right side
    translate([bra_xr,fan_setback,-bra_z])rotate((90-fan_angle),[0,1,0])fanholder();
    difference()
    {
        
        translate([bra_xr,fan_setback+bump,-bra_z])rotate((90-fan_angle),[0,1,0])
        translate([-((fansize/2)+tonguex/2),0,0])cube([tonguex,tonguey,bracket_h],center=true);
        //trim back down
        translate([0,0,10+arm_h/2])cube([100,100,20],center=true);
        translate([0,0,0])cube([(arm_gap*2),100,20],center=true);
    }
    //gave up and did this with literals; was late in evening
    translate([(bra_xr/2-arm_gap-wall_thick),-bracket_h,0])cube([bra_xr,bracket_h,bracket_h,],center=true);
    
    translate([24,9.5,0])cube([bracket_h+2,42,bracket_h,],center=true);
    
}
extruder_bracket();
//translate([0,(fansize/2+hingeknee),0])
//rotate(-kneeangle,[1,0,0])translate([-(arm_gap+wall_thick/2),(slotlength/2),0])arm();
//translate([-(arm_gap+wall_thick/2),fansize/2+hingeknee-ep,0])hinge();
//translate([-(wall_thick/2+hingegap/2),fansize/2+hingeknee-ep,0])hinge();
//translate([(wall_thick/2+hingegap/2),fansize/2+hingeknee-ep,0])hinge();
//fanholder();
//translate([-15,64.5,-20])rotate(90,[1,0,0])rotate(90,[0,1,0])extruder();
