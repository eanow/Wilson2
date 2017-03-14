board_t=3.7;
bracket_t=board_t+(.8*5);
m3_nut_r = 6.6/2;
m3_slot=3.5;
tongue=35;
nut_h=4;
m3=4;
ep=0.001;
$fa=1;
$fs=1;
module clip()
{
    difference()
    {
        cube([tongue,m3_nut_r*2*2,bracket_t],center=true);
        translate([-(m3_nut_r*2*2),0,0])cube([tongue,m3_nut_r*2*3,board_t],center=true);
        translate([(tongue/2-m3_nut_r*2),0,(bracket_t/2-bracket_t/8)+ep])rotate([0,0,30])cylinder(r1=m3_nut_r,r2=m3_nut_r,h=bracket_t/4,center=true,$fn=6);
        translate([(tongue/2-m3_nut_r*2),0,0])cylinder(r1=m3/2,r2=m3/2,h=bracket_t*2,center=true);
    }
}
//translate([(tongue/2-m3_nut_r*2),0,0])cube([m3_nut_r,m3_nut_r,bracket_t*2],center=true);

module thumb()
{
    difference()
    {
        union()
        {
            cylinder(r=2.4+(m3_nut_r), h=nut_h*2,center=true);
            translate([0,0,-nut_h*.5])cylinder(r=3.6+(m3_nut_r), h=nut_h,center=true);
        }
        translate([0,0,nut_h/2+ep])cylinder(r=m3_nut_r,h=nut_h*2,center=true,$fn=6);
    }
    translate([0,0,-(nut_h+.5-ep)])cylinder(r1=2*(m3_nut_r)-1,r2=2*(m3_nut_r), h=1,center=true);
}

//thumb();
clip();