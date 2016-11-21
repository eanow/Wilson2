module titan_assembly()
{
    titan_extruder();
    hotend();
    x_carriage();
    nozzle();
}
module titan_extruder()
{
    translate([27.1,37.5,-23])rotate([0,0,90])import("../stl/titan_dummy.stl");
}
module x_carriage()
{
    translate([34.5,65.5,39.5])rotate([0,0,180])rotate([0,90,0])import("../stl/x-carriage.stl");
}
module hotend()
{
    translate([0,22,-16])rotate(270,[0,0,1])rotate(90,[1,0,0])import("../stl/e3dmockup.stl");
}
module nozzle();
{
    kneeangle=45; //angle of fan mount, from straight out
    fansize=40;
    hingeknee=12; //distance from edge of fanholder to pivor point
    bracket_h=8;
    rotate(-(180-kneeangle),[1,0,0])translate([0,(fansize/2+hingeknee),bracket_h/2])import("../stl/split_nozzle.stl");
}
titan_assembly();
m4_nut_thick=3.2; //how thick an m4 nut is
carriage_wall_thick=2.5; //thickness of plate against x carriage

module motor_plate();
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
    echo(x);

    difference(){
        intersection(){
            cube(size = [nema_width, nema_width, thickness], center = true);

            rotate([0,0,45]) cube(size = [x, x, thickness], center = true);
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

