    %translate([-7.65-1,6,0])import("../stl/z-rack.stl");    
ep=0.001;
rack_l=121.5;
rack_h=9.8;
rack_w=7.675;
tooth_pitch=4;
tooth_depth=3.675;
tooth_w=3.65;
tooth_n=1.0;
tooth_start=-23.15;

trim=1;

tooth_count=9;
difference()
{
    union()
    {
        translate([-.25+trim/2,-rack_w/2,rack_h/2])cube([rack_l-trim,rack_w,rack_h],center=true);
        translate([-.25+trim/2+1,-rack_w/2,rack_h/2])cube([rack_l-trim,1.2,rack_h],center=true);
    }
    translate([tooth_start,0,0])for (aa=[1:tooth_count])
    {
        translate([(aa-1)*tooth_pitch,0,-rack_h/2])linear_extrude(height=rack_h*2)tooth();
    }

}


module tooth()
{
    //trapezoidal shape
    translate([0,-.5-rack_w,0])hull()
    {
        square([tooth_w,1],center=true);
        translate([0,tooth_depth/2])square([tooth_n,tooth_depth+1],center=true);
    }
}
//tooth();