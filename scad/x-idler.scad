// Wilson II X Ends
// By M. Rice
// GNU GPL v3
// Adapted from design by Josef Průša <iam@josefprusa.cz> and contributors
// http://www.reprap.org/wiki/Prusa_Mendel
// http://prusamendel.org

include <configuration.scad>

rod_distance = 50;       // vertical distance between X axis smooth rods (was 45mm on original prusa i3 xends)
pushfit_d = 10.3;        // slightly larger than the rods themselves to accomodate extrusion
bearing_diameter = 19;   // 19=LM10UU 15=LM8UU
bearing_cut_extra = 0.12;//0.4; // extra cut for linear bearings so they are not too tight.
thinwall = 3;            // thickness of the wall that holds in the linear bearings
height = rod_distance+15;// height of the x ends

center_z = 30.25 -1;
tensioner_size_z = 12;

bearing_size = bearing_diameter + 2 * thinwall;

// MODULE -------------------------------------
module vertical_bearing_base(){
 translate(v=[-2-bearing_size/4,0,height/2]) cube(size = [4+bearing_size/2,bearing_size,height], center = true);
 cylinder(h = height, r=bearing_size/2, $fn = 90);
}

// MODULE -------------------------------------
module vertical_bearing_holes(){
  #translate(v=[0,0,-4]) cylinder(h = height+3, r=bearing_diameter/2 + bearing_cut_extra, $fn = 60);
  translate(v=[0,0,height-4]) cylinder(h=10,r=bearing_diameter/2-1,$fn=60);
  
  // the slit cut along the vertical bearing holder for some flex
  rotate(a=[0,0,80]) translate(v=[8,0,27]) cube(size = [10,5 ,height+13], center = true);

  translate([0,0,-1]) cylinder(h=9,r1=bearing_diameter/2+thinwall/2+1,r2=4,$fn=60);

}

// MODULE -------------------------------------
module x_end_base(){
  // Main block
  height = rod_distance + 15;
  translate(v=[-15,-10,height/2]) cube(size = [17,45,height], center = true);

  // Bearing holder
  vertical_bearing_base();	

  // thing to hold the brass nut
  translate(v=[-3.5,-22,4]) cube(size=[7.8,20,8],center=true);

  translate(v=[5.5,-24,4]) cylinder(h=8,r=12.5,$fn=50,center=true);
   // post for actuating z rack
z_post_h = 14;
  translate(v=[-14,-27.5,height+z_post_h/2]) { 
  difference() {
    cube(size=[15,10,z_post_h],center=true);
    //rotate([90,0,0]) cylinder(h=20,r=m3_hole_r,$fn=50,center=true);
  }
}  

}

// MODULE -------------------------------------
module x_end_holes(){
 vertical_bearing_holes();
 // Belt hole
 translate(v=[-1,-3.5,0]){
 // Stress relief
 //translate(v=[-5.5-10+1.5,-10-1,30]) cube(size = [20,1,28], center = true);
 difference(){
	translate(v=[-5.5-10+1.5,-10,30]) cube(size = [10,46,28], center = true);
	// Nice edges
	translate(v=[-5.5-10+1.5,-10,30+23]) rotate([0,45,0]) cube(size = [10,46,28], center = true);
	translate(v=[-5.5-10+1.5,-10,30+23]) rotate([0,-45,0]) cube(size = [10,46,28], center = true);
	translate(v=[-5.5-10+1.5,-10,30-23]) rotate([0,45,0]) cube(size = [10,46,28], center = true);
	translate(v=[-5.5-10+1.5,-10,30-23]) rotate([0,-45,0]) cube(size = [10,46,28], center = true);
   }
 }

 // Bottom pushfit rod
 translate(v=[-15,-41.5,7.5]) rotate(a=[-90,0,0]) pushfit_rod(pushfit_d,50);
 // Top pushfit rod
 translate(v=[-15,-41.5,rod_distance+7.5]) rotate(a=[-90,0,0]) pushfit_rod(pushfit_d,50);

 // the holes for the brass nut
 translate(v=[5.5,-24,4]) // <-- This is the offset from the smooth rod to the threaded rod (5.5,-24)
     union() { 
               // center post of brass nut
                   cylinder(h=10,r=5.45,$fn=50,center=true);
                   // holes for m3 screws in brass nut
                   #translate(v=[8,0,0]) cylinder(h=12,r=1.8,$fn=20,center=true);
                   #rotate([0,0,90]) translate(v=[8,0,0]) cylinder(h=12,r=1.8,$fn=20,center=true);
                   #rotate([0,0,180]) translate(v=[8,0,0]) cylinder(h=12,r=1.8,$fn=20,center=true);
                   #rotate([0,0,270]) translate(v=[8,0,0]) cylinder(h=12,r=1.8,$fn=20,center=true);
           }
 //twin tensioner holes
 m3nut_r=6.6/2;
 slot_d=(5/2)*sqrt(3);
 m3slot=3.5;
 shaft_h=20;
translate(v=[-5.5-11+1.5,10,30])
           {
 #translate([0,0,shaft_h/2-1.5-slot_d/2])rotate([90,0,0])cylinder(r=m3slot/2,h=20,center=true,$fn=30);
 #translate([0,0,-(shaft_h/2-1.5-slot_d/2)])rotate([90,0,0])cylinder(r=m3slot/2,h=20,center=true,$fn=30);
           }
}

// MODULE -------------------------------------
module pushfit_rod(diameter,length){
 // intentionally making the holes oblong in the Z direction to help with binding of the X axis
 translate([0,-0.2,0])  cylinder(h = length, r=diameter/2, $fn=30);
 translate([0,0.2,0])  cylinder(h = length, r=diameter/2, $fn=30);
}

// X END IDLER -----------------------------------------------------------
idler_offs_z = -1; // negative here means "up" when installed
idler_offs_y = 7;
M4_head_d = 8;

module x_end_idler_base(){
 x_end_base();
}

module x_end_idler_holes(){
 x_end_holes();
 translate([0,idler_offs_y,idler_offs_z]) {
   translate(v=[0,-22,30.25]) { 
    //translate(v=[0,0,0])   rotate(a=[0,-90,0]) cylinder(h = 80, r=idler_bearing_inner_d/2+.3, $fn=30);
    //translate(v=[6,0,0])   rotate(a=[0,-90,0]) cylinder(h = 12.5, r=M4_head_d/2+.1, $fn=30);
    //translate(v=[-22,0,0]) rotate(a=[0,-90,0]) rotate(a=[0,0,30]) cylinder(h = 80, r=idler_bearing_inner_d, $fn=6);   

    // create a notch for the X tensioner, to improve the length of travel available
    translate(v=[-10,-20,1]) #difference() { rotate(a=[45,0,0])  cube(size=[30,22,22],center=true); 
                                             translate(v=[0,14,0]) cube(size=[31,4,8],center=true); }
   }
 }
}
 
// Final part
module x_end_idler(){
 mirror([0,1,0]) union() { 
      difference(){
  x_end_idler_base();
  x_end_idler_holes();
      }

}
}

// X END MOTOR ------------------------------------------------------------
offs_adjuster_y = 5.5;
adj_block_x = 12;

motor_offs_z = 0;
screw_head_r = 3.5;

module x_end_motor_sr() {
    difference() { 
       cube(size=[8,12,10]);
       #translate([4,11.5,9]) rotate([0,90,0]) 
               difference() { cylinder(r=4.5,h=4,$fn=16,center=true);
                              translate([0,0,-1]) cylinder(r=2.5,h=7,$fn=16,center=true);
               }

        #translate([9,10.6,10]) rotate([0,45,90]) cube(size=[2,11,2]);
    }
}


// Make parts
x_end_idler();
use<x-tensioner.scad>
translate([-5.5-9.5,0,30])rotate([0,0,90])complete();










