translate([800,0,0])import("../stl/ramps-mount.stl");
translate([-29.187,-22.6,13])rotate(270,[0,1,0])linear_extrude(4)polygon([[0,0],[21.8,0],[0,17.5]]);
translate([-33.187,-102.2,13])rotate(180,[0,0,1])rotate(270,[0,1,0])linear_extrude(4)polygon([[0,0],[21.8,0],[0,17.5]]);
translate([0,0,-20])scale([1,1,3])translate([0,0,0])intersection()
{
    difference()
    {
        translate([5,-65,18.1])cube([60,95,18],center=true);
        translate([0,-50,0])cube([100,30,80],center=true);
    }
    translate([800,0,0])import("../stl/ramps-mount.stl");
}