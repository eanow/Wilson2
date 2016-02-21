difference()
{
    union()
    {
        translate([891,53,-2.45])import("../stl/z-lower-brace-2_old_fixed_fixed.stl");
        
        linear_extrude(height=5)polygon([[0,0],[-45,0],[0,-40]]);
    }
    translate([0,0,-5])cube([200,200,10],center=true);
}