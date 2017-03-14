module bed(buffer)
{
    linear_extrude(4)
    minkowski()
    {
        import("../doc/wilson-bed-2030-lc-nohole.dxf");
        circle(r=buffer,$fn=50);
    }
}

m3_nut_r = 6.6/2;
m3_slot=3.5;
//bed();
/*
difference()
{
//bottom left solid
    union()
    {
        translate([1.7+5+1.6+4,2,-.8])linear_extrude(7)minkowski()
        {
            square([26,30]);
            circle(r=2,$fn=30);
        }
        translate([20.2-.5,11.8-.5,-1])cylinder(r1=m3_nut_r+1.2,r2=m3_nut_r+3.6,h=2,center=true,$fn=6);
    }
//bottom_left hole
translate([20.2-.5,11.8-.5,0])cylinder(r=m3_slot/2+.25,h=20,center=true,$fn=30);
translate([20.2-.5,11.8-.5,0])cylinder(r=m3_nut_r,h=7,center=true,$fn=6);
translate([20.2+10+4.5,15,-3.4])cube([20,40,6],center=true);
bed(.3);
}
*/
/*
difference()
{
    //bottom right solid
    union()
    {
        translate([208+2.7-1.6,2,-1])linear_extrude(7)minkowski()
        {
            square([26,30]);
            circle(r=2,$fn=30);
        }
        translate([208+20.2+.5,11.8-.5,-1])cylinder(r1=m3_nut_r+1.2,r2=m3_nut_r+3.6,h=2,center=true,$fn=6);
    }

//bottom_right hole
translate([208+.5+20.2,11.8-.5,0])cylinder(r=m3_slot/2+.25,h=20,center=true,$fn=30);
translate([208+.5+20.2,11.8-.5,0])cylinder(r=m3_nut_r,h=7,center=true,$fn=6);
translate([208+20.2-10-4.5,15,-3.4])cube([20,40,6],center=true);
bed(.2);
}
*/
/*
difference()
{
    //top left solid

union()
    {
        translate([1.7+5+1.6+4-4,2+309,-1])linear_extrude(7)minkowski()
        {
            square([26,30]);
            circle(r=2,$fn=30);
        }
        translate([20.2,314+11.8,-1])cylinder(r1=m3_nut_r+1.2,r2=m3_nut_r+3.6,h=2,center=true,$fn=6);
    }
//top_left hole
translate([20.2-.5,314+.5+11.8,0])cylinder(r=m3_slot/2+.25,h=20,center=true,$fn=30);
translate([20.2-.5,314+.5+11.8,0])cylinder(r=m3_nut_r,h=7,center=true,$fn=6);
translate([20.2+10+4.5,314+15,-3.4])cube([20,40,6],center=true);
bed(.9);
}
*/

difference()
{
union()
    {
        translate([208+2.7-1.6+4,2+309,-1])linear_extrude(7)minkowski()
        {
            square([26,30]);
            circle(r=2,$fn=30);
        }
        translate([208+20.2,314+11.8,-1])cylinder(r1=m3_nut_r+1.2,r2=m3_nut_r+3.6,h=2,center=true,$fn=6);
    }

//top_right hole
    translate([208+.5+20.2,314+.5+11.8,0])cylinder(r=m3_slot/2+.25,h=20,center=true,$fn=30);
    translate([208+.5+20.2,314+.5+11.8,0])cylinder(r=m3_nut_r,h=10,center=true,$fn=6);
    bed(.7);
    translate([20.2-10-4.5+208,314+15,-3.4])cube([20,40,6],center=true);

}