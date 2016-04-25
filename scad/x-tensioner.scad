module tensioner()
{
    translate([1000-14.4,-200-.75,-8])import("../stl/x-tensioner.stl");
}
/*m3screw_t=18.5;
z_h=18.8;
module slice()
{
    translate([0,0,0])intersection()
    {
        tensioner();
        translate([0,0,5.5])cube([150,150,.5],center=true);
    }
}
module slice2()
{
    translate([0,0,0])intersection()
    {
        tensioner();
        translate([0,0,5.5])cube([80,80,.5],center=true);
    }
}
tensioner();
translate([0,0,0])slice();
//translate([34.5/2,0,0])cube([34.5,9,18],center=true);
*/
tensioner();

$fs=.5;
$fa=1;
ep=0.001;
shaft_l=32;
shaft_h=12;
shaft_w=9;
//shaft
translate([shaft_l/2,0,0])cube([shaft_l,shaft_w,shaft_h],center=true);
//yoke
yoke_w=15;
yoke_r=2.5;
yoke_l=18.75;
inside_w=10;
m4slot=4.5;
module round()
{
    translate([0,0,-shaft_h/2])linear_extrude(height=shaft_h)intersection()
    {
        minkowski()
        {
            translate([shaft_l+(yoke_l-yoke_r)-ep,0])square([2*(yoke_l-yoke_r*2),(yoke_w-yoke_r*2)],center=true);
            circle(r=yoke_r);
        }
        translate([shaft_l+yoke_l/2-ep,0])square([yoke_l+ep,yoke_w+ep],center=true);
    }
}
module yoke()
{
    difference()
    {
        round();
        xbump=(yoke_w-inside_w)/2;
        translate([yoke_l/2+shaft_l+xbump,0,0])cube([yoke_l,inside_w,shaft_h*2],center=true);
    }
}
yoke();