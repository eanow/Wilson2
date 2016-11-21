module titan_assembly()
{
    titan_extruder();
    hotend();
    translate([0,.5,0])x_carriage();
    nozzle();
    motor_dummy();
}
module motor_dummy()
{
    translate([5,26.3,13.5])color([.25,.25,.25])cube([34,42,42],center=true);
}
module titan_extruder()
{
    translate([12.5,22,-23])rotate([0,0,270])import("../stl/titan_dummy.stl");
}
module x_carriage()
{
    translate([34.5,65.5,39.5])rotate([0,0,180])rotate([0,90,0])import("../stl/x-carriage.stl");
}
module hotend()
{
    translate([39.5,38,-16])rotate(270,[0,0,1])rotate(90,[1,0,0])import("../stl/e3dmockup.stl");
}
module nozzle()
{
    kneeangle=45; //angle of fan mount, from straight out
    fansize=40;
    hingeknee=12; //distance from edge of fanholder to pivor point
    bracket_h=8;
    translate([39.5,38-22])rotate(-(180-kneeangle),[1,0,0])translate([0,(fansize/2+hingeknee),bracket_h/2])import("../stl/split_nozzle.stl");
}
titan_assembly();
motor_mount();
fan_bracket();
module motor_mount()
{
    translate([25,26.3,13.5])
    {
        rotate([0,90,0])nema_plate();
        //connections
        difference()
        {
            translate([0,42.3/2+3.5-1.6,0])cube([2,8,42.3],center=true);           
        }
    }
    translate([-18,54.3,-22])carriage_plate();
}
module fan_bracket()
{
    fansize=40;
    holespace=32;
    round_r=4;
    m3_slot=3.5;
    translate([39.5,16,0])rotate([45,0,0])translate([0,-32,-4])linear_extrude(height=7)difference()
    {
        minkowski()
        {
            square([fansize-round_r*2,fansize-round_r*2],center=true);
            circle(r=round_r,$fn=40);
        }
        for (aa=[-.5:1:.5])
        {
            for (bb=[-.5:1:.5])
            {
                translate([aa*holespace,bb*holespace])circle(r=m3_slot/2,$fn=30);
            }
        }
        circle(r=36/2,$fn=60);
    }
    
    fan_arm();
    translate([29,0,0])fan_arm();
}
module fan_arm()
{
    m3_slot=3.5;
    holespace=32;
    difference()
    {
        intersection()
        {
            translate([25-2,26.3,13.5])
            {
                rotate([0,90,0])nema_plate();
                translate([0,-15.9,-22])rotate([0,90,0])cube([10,10,2],center=true);
            }
            translate([39.5,16,0])
            {
                rotate([45,0,0])translate([0,-32,-4+50])cube([200,110,100],center=true);
            }
            translate()
            {
                cube([100,30,100],center=true);
            }
        }
        translate([39.5,16,0])rotate([45,0,0])translate([0,-32,-5])linear_extrude(height=17)translate([-.5*holespace,.5*holespace])circle(r=m3_slot/2,$fn=30);
    }
}
module carriage_plate()
{
    m4_nut_thick=4.2; //how thick an m4 nut is
    m4_r=4.5/2;
    m4_nut_r=7.8/2;
    carriage_wall_thick=2.5; //thickness of plate against x carriage
    bolt_gap=23;
    difference()
    {
        union()
        {
            translate([8,-1,7])cube([36,carriage_wall_thick+m4_nut_thick,49.65]);
               //strength triangles 
            translate([0,0,49.65+7-.01])linear_extrude(height=1.2)hull()
            {
                translate([8,-1])square([36,carriage_wall_thick+m4_nut_thick]);
                translate([8+36-.5,-40-1])square([.5,40]);
            }
            translate([0,0,13.15+.01])linear_extrude(height=1.2)hull()
            {
                translate([8,-1])square([36,carriage_wall_thick+m4_nut_thick]);
                translate([8+36-.5,-40-1])square([.5,40]);
            }
                //motor standoffs
            translate([8,-1,20])rotate([0,90,0])cylinder(r=6.8,h=36,$fn=6);
            translate([8,-1,51])rotate([0,90,0])cylinder(r=6.8,h=36,$fn=6);
        }
        
        //bolt holes
        for (aa=[-.5:1:.5])
        {
            for(bb=[-.5:1:.5])
            {
                translate([26+aa*bolt_gap,5,25+bb*bolt_gap])rotate([90,0,0])cylinder(r=m4_r,h=12,$fn=30,center=true);
                translate([26+aa*bolt_gap,-1+m4_nut_thick/2-.01,25+bb*bolt_gap])rotate([90,0,0])cylinder(r=m4_nut_r,h=m4_nut_thick,$fn=6,center=true);
            }
        }
        //access slots
        translate([11,m4_nut_thick/2-1-0.01,13.5])cube([10,m4_nut_thick,m4_nut_r*sqrt(3)],center=true);
        translate([42,m4_nut_thick/2-1-0.01,13.5])cube([10,m4_nut_thick,m4_nut_r*sqrt(3)],center=true);
    }


    //
}
module nema_plate()
{
    // Customisable E3D Titan Motor Spacer Plate

    // Thickness of spacer plate
    thickness = 2; // [1,1.5,2,2.5,3,3.5,4,5,6,7]

    // Overall width of motor
    nema_width = 42.3;

    // Spacing between M3 holes
    nema_hole_spacing = 31;

    // Clearance hole size for M3
    nema_hole_size = 3.5;

    // Clearance hole for motor boss
    nema_boss_size = 27;


    chamfer = (nema_width - 34)/2;
    H = pow(2 * pow(nema_width/2,2), 1/2);
    h = chamfer * pow(2, 1/2) / 2;
    x = (H - h) * 2;


    difference(){
        union()
        {
        intersection(){
            cube(size = [nema_width, nema_width, thickness], center = true);

            rotate([0,0,45]) cube(size = [x, x, thickness], center = true);
        }
        difference()
        {
            cube(size = [nema_width, nema_width, thickness], center = true);
            translate([0,-10,0])cube(size = [nema_width+1, nema_width+1, thickness+1], center = true);
        }
    }

        for (x = [-0.5:1:0.5])
        for (y = [-0.5:1:0.5])
        translate([x * nema_hole_spacing, 
                   y * nema_hole_spacing, 
                   0])
            cylinder(h = thickness * 2, 
                     r = nema_hole_size / 2, 
                     center = true,
                     $fn=150);
        cylinder(h = thickness * 2,
                 r = nema_boss_size / 2, 
                 center = true,
                 $fn = 250);
            
    }
}

