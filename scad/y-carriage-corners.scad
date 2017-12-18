module bed(buffer)
{
    linear_extrude(4)
    minkowski()
    {
        import("../doc/wilson-bed-2030-lc-nohole.dxf");
        circle(r=buffer,$fn=50);
    }
}
pcb_w=218;
pcb_l=320;
spring_h=12.5;
spring_d=4.8+.5;
captive_nut_offset=7;
board_t=1.5;
spring_adj=2; //travel intended for spring
m3_nut_r = 6.6/2;
m3_slot=3.5;
m3_nut_h=2.6;
underside_sink=-1;
ep=0.01;

module pcb()
{
    board_center_x=((20.2-.5)+(208+20.2+.5))/2;
    board_center_y=((11.8-.5)+(314+11.8))/2;
    translate([board_center_x,board_center_y])square([pcb_w,pcb_l],center=true);
}
//%pcb();
bl();
br();
tl();
tr();
//bed();
module bl()
{
    difference()
    {
    //bottom left solid
        union()
        {
            translate([1.7+5+1.6+4,2,underside_sink])linear_extrude(captive_nut_offset+m3_nut_h)minkowski()
            {
                square([26,30]);
                circle(r=2,$fn=30);
            }
            translate([20.2-.5,11.8-.5,underside_sink])cylinder(r1=m3_nut_r+1.2,r2=m3_nut_r+3.6,h=2,center=true,$fn=6);
        }
    //top captive nut
    translate([20.2-.5,11.8-.5,captive_nut_offset+underside_sink+ep])cylinder(r=m3_nut_r,h=m3_nut_h,$fn=6);    
    //bottom_left hole
    translate([20.2-.5,11.8-.5,0])cylinder(r=m3_slot/2+.25,h=20,center=true,$fn=30);
    translate([20.2-.5,11.8-.5,0])cylinder(r=m3_nut_r,h=7,center=true,$fn=6);
    translate([20.2+10+4.5,15,-3.4])cube([20,40,6],center=true);
    bed(.3);
    }
}
module br()
{
    difference()
    {
        //bottom right solid
        union()
        {
            translate([208+2.7-1.6,2,underside_sink])linear_extrude(captive_nut_offset+m3_nut_h)minkowski()
            {
                square([26,30]);
                circle(r=2,$fn=30);
            }
            translate([208+20.2+.5,11.8-.5,underside_sink])cylinder(r1=m3_nut_r+1.2,r2=m3_nut_r+3.6,h=2,center=true,$fn=6);
        }
    //top captive nut
    translate([208+.5+20.2,11.8-.5,captive_nut_offset+underside_sink+ep])cylinder(r=m3_nut_r,h=m3_nut_h,$fn=6);
    //bottom_right hole
    translate([208+.5+20.2,11.8-.5,0])cylinder(r=m3_slot/2+.25,h=20,center=true,$fn=30);
    translate([208+.5+20.2,11.8-.5,0])cylinder(r=m3_nut_r,h=7,center=true,$fn=6);
    translate([208+20.2-10-4.5,15,-3.4])cube([20,40,6],center=true);
    bed(.2);
    }
}

module tl()
{
    difference()
    {
        //top left solid

    union()
        {
            translate([1.7+5+1.6+4-4,2+309,underside_sink])linear_extrude(captive_nut_offset+m3_nut_h)minkowski()
            {
                square([26,30]);
                circle(r=2,$fn=30);
            }
            translate([20.2,314+11.8,underside_sink])cylinder(r1=m3_nut_r+1.2,r2=m3_nut_r+3.6,h=2,center=true,$fn=6);
        }
    //top captive nut
    translate([20.2-.5,314+.5+11.8,captive_nut_offset+underside_sink+ep])cylinder(r=m3_nut_r,h=m3_nut_h,$fn=6);
    //top_left hole
    translate([20.2-.5,314+.5+11.8,0])cylinder(r=m3_slot/2+.25,h=20,center=true,$fn=30);
    translate([20.2-.5,314+.5+11.8,0])cylinder(r=m3_nut_r,h=7,center=true,$fn=6);
    translate([20.2+10+4.5,314+15,-3.4])cube([20,40,6],center=true);
    bed(.9);
    }
}

module tr()
{
    difference()
    {
    union()
        {
            translate([208+2.7-1.6+4,2+309,underside_sink])linear_extrude(captive_nut_offset+m3_nut_h)minkowski()
            {
                square([26,30]);
                circle(r=2,$fn=30);
            }
            translate([208+20.2,314+11.8,underside_sink])cylinder(r1=m3_nut_r+1.2,r2=m3_nut_r+3.6,h=2,center=true,$fn=6);
        }
    //top captive nut
    translate([208+.5+20.2,314+.5+11.8,captive_nut_offset+underside_sink+ep])cylinder(r=m3_nut_r,h=m3_nut_h,$fn=6);
    //top_right hole
        translate([208+.5+20.2,314+.5+11.8,0])cylinder(r=m3_slot/2+.25,h=20,center=true,$fn=30);
        translate([208+.5+20.2,314+.5+11.8,0])cylinder(r=m3_nut_r,h=10,center=true,$fn=6);
        bed(.7);
        translate([20.2-10-4.5+208,314+15,-3.4])cube([20,40,6],center=true);

    }
}