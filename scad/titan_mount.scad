//mockup parts
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
    //translate([13,40.2,-10+.2])rotate([0,0,-90])rotate([-90,0,0])import("../stl/ASM_EX_THUMB_SCREW.stl");
}
module x_carriage()
{
    //lowered hot end 6 mm
    translate([-24,65.5+1+.5+.5,-27.5])rotate([0,0,180])rotate([0,270,0])import("../stl/x-carriage.stl");
}
//this hotend and fan positioning should match how the MjRice extruder holds them
module hotend()
{
    translate([0,22,-16])rotate(270,[0,0,1])rotate(90,[1,0,0])import("../stl/e3dmockup.stl");
}
module nozzle()
{
    kneeangle=45; //angle of fan mount, from straight out
    fansize=40;
    hingeknee=12; //distance from edge of fanholder to pivor point
    bracket_h=8;
    rotate(-(180-kneeangle),[1,0,0])translate([0,(fansize/2+hingeknee),bracket_h/2])import("../stl/split_nozzle.stl");
}
//block approximately the size of a NEMA 17 motor that I'll be using
module motor_dummy()
{
    translate([33-.8+2.4,26.3+6.85-1,13.5])color([.25,.25,.25])cube([34,43.2,43.2],center=true);
}
module mount_stl()
{
    #translate([8,61+.5,9])rotate([90,0,0])import("../stl/titan_mount.stl");
}
//titan_assembly();
//motor_mount();
//motor_dummy();
//mount_stl();
fan_bracket();
//physical sizing
carriage_wall_thick=2.5+4.2; //thickness of plate against x carriage
carriage_mount_spacing=23; //center to center spacing of the carriage connectors
// Spacing between M3 holes on nema
nema_hole_spacing = 31;
// Clearance hole for motor boss
nema_boss_size = 27;
m3_slot=3.5; //width of a hole for M3 screw
mount_wall_thick=2.4; //vertical mount walls thickness
m4_nut_thick=4.2; //depth of recess for m4 nut
m4_slot=4.5; //hole for M4 screw
m4_nut_r=8.6/2-.2;
//motor size
nema17_w=42.4+.1; //tolerance
//mounting plate sizing
xxmount=44; //area around mount holes
yymount=38;
yymotor=nema17_w+mount_wall_thick*2;//area around motor
xxmotor=25;
motor_nudge=8; //adjustment of motor position, right to left
ep=0.01;
//tweak position of mount relative to mounting holes
xnudge=5;
ynudge=-0.5;
rounder=3;
titan_width=25.4; //tolerance
module motor_mount()
{
    difference()
    {
        intersection()
        {
            carriage_plate();
            //smooth out
            translate([xnudge,ynudge,0])linear_extrude(height=carriage_wall_thick+nema17_w)carriage_shape();
            translate([0,ynudge-yymount/2+nema17_w/2+mount_wall_thick,-ep+nema17_w/2+carriage_wall_thick])rotate([0,90,0])translate([0,0,-xxmount])linear_extrude(height=xxmount*2)union()
            {
                yy=nema17_w+mount_wall_thick*2;
                minkowski()
                {
                    
                    square([nema17_w-rounder*2,yy-rounder*2],center=true);
                    circle(r=rounder,$fn=50);
                }
                //want the bottom to be non-rounded
                translate([nema17_w/4+carriage_wall_thick,0])square([nema17_w/2,yy],center=true);
            }
        }
        for (aa=[-.5:1:.5])
        {
            for (bb=[-.5:1:.5])
            {
                //m4 holes
                translate([aa*carriage_mount_spacing,bb*carriage_mount_spacing,-ep])cylinder(r=m4_slot/2,h=ep*2+carriage_wall_thick,$fn=50);
                //m4 nuts
                translate([aa*carriage_mount_spacing,bb*carriage_mount_spacing,carriage_wall_thick-m4_nut_thick-ep])cylinder(r=m4_nut_r,h=ep*2+m4_nut_thick,$fn=6);
                //m4 nut access
                translate([aa*carriage_mount_spacing,bb*carriage_mount_spacing,carriage_wall_thick-ep])cylinder(r1=m4_nut_r,r2=m4_nut_r,h=ep*2+m4_nut_thick,$fn=6);
                //chamfer
                translate([aa*carriage_mount_spacing,bb*carriage_mount_spacing,-ep])cylinder(r1=.5+m4_slot/2,r2=m4_slot/2,h=ep*2+.5,$fn=50);
            }
        }
    }
}
//carriage_plate();
module carriage_plate()
{
    //part against the carriage
    translate([xnudge,ynudge,0])hull()
    {
        translate([0,0,.5])linear_extrude(height=carriage_wall_thick-.5)carriage_shape_a(0);
        linear_extrude(height=carriage_wall_thick)carriage_shape_a(.5);
    }
    translate([xnudge,ynudge,0])hull()
    {
        translate([0,0,.5])linear_extrude(height=carriage_wall_thick-.5)carriage_shape_b(0);
        linear_extrude(height=carriage_wall_thick)carriage_shape_b(.5);
    }
    //vertical part
    //line up with bottom edge, sink ep down for unambiguity
    translate([motor_nudge,ynudge-yymount/2+nema17_w/2+mount_wall_thick,-ep])
    {
        translate([0,0,nema17_w/2+carriage_wall_thick])
        {
            rotate([0,90,0])translate([0,0,-mount_wall_thick])
            {
                linear_extrude(height=mount_wall_thick)nema_shape();
            }
        }
    }
    //strength triangles
    xx=(xxmount/2+xnudge-motor_nudge+mount_wall_thick);
    zz=nema17_w;
    hull()
    {
        translate([xx/2+motor_nudge-mount_wall_thick,-yymount/2+ynudge+mount_wall_thick/2,carriage_wall_thick*.75])cube([xx,mount_wall_thick,carriage_wall_thick*.5],center=true);
        translate([-mount_wall_thick/2+motor_nudge,-yymount/2+ynudge+mount_wall_thick/2,zz/2+carriage_wall_thick-ep])cube([mount_wall_thick,mount_wall_thick,zz],center=true);
    }

    hull()
    {
        translate([xx/2+motor_nudge-mount_wall_thick,-yymount/2+ynudge+mount_wall_thick/2+nema17_w+mount_wall_thick,carriage_wall_thick*.75])cube([xx,mount_wall_thick,carriage_wall_thick*.5],center=true);
        translate([-mount_wall_thick/2+motor_nudge,-yymount/2+ynudge+mount_wall_thick/2+nema17_w+mount_wall_thick,zz/2+carriage_wall_thick-ep])cube([mount_wall_thick,mount_wall_thick,zz],center=true);
    }
    
    hull()
    {
        translate([-xx/2+motor_nudge-mount_wall_thick,-yymount/2+ynudge+mount_wall_thick/2,carriage_wall_thick*.75])cube([xx,mount_wall_thick,carriage_wall_thick*.5],center=true);
        translate([-mount_wall_thick/2+motor_nudge,-yymount/2+ynudge+mount_wall_thick/2,zz/4+carriage_wall_thick-ep])cube([mount_wall_thick,mount_wall_thick,zz/2],center=true);
    }
}
//nema_shape();

module nema_shape()
{
    rounder=3;
    yy=nema17_w+mount_wall_thick*2;
    difference()
    {
        union()
        {
            minkowski()
            {
                square([nema17_w-rounder*2,yy-rounder*2],center=true);
                circle(r=rounder,$fn=50);
            }
            //want the bottom to be non-rounded
            translate([nema17_w/4,0])square([nema17_w/2,yy],center=true);
        }
        //m3 holes
        for (aa=[-.5:1:.5])
        {
            for (bb=[-.5:1:.5])
            {
                translate([aa*nema_hole_spacing,bb*nema_hole_spacing])circle(r=m3_slot/2,$fn=50);
            }
        }
        //motor boss
        circle(r=nema_boss_size/2,$fn=100);
        //printability
        intersection()
        {
            rotate([0,0,45])square([nema_boss_size,nema_boss_size],center=true);
            translate([-nema_boss_size*sqrt(2)/2,0])square([nema_boss_size/sqrt(2),nema_boss_size/sqrt(2)],center=true);
        }
    }
}
module nema_shape_fan()
{
    rounder=3;
    yy=nema17_w-1;
    intersection()
    {
        difference()
        {
            union()
            {
                minkowski()
                {
                    square([yy-rounder*2,yy-rounder*2],center=true);
                    circle(r=rounder,$fn=50);
                }
            }
            //m3 holes
            for (aa=[-.5:1:.5])
            {
                for (bb=[-.5:1:.5])
                {
                    translate([aa*nema_hole_spacing,bb*nema_hole_spacing])circle(r=m3_slot/2,$fn=50);
                }
            }
            //motor boss
            circle(r=nema_boss_size/2,$fn=100);
        }
        //
        union()
        {
            hole_diag=nema_hole_spacing*sqrt(2)-nema_boss_size;
            for (aa=[-.5:1:.5])
            {
                for (bb=[-.5:1:.5])
                {
                    translate([aa*nema_hole_spacing,bb*nema_hole_spacing])circle(r=hole_diag/2,$fn=50);
                }
            }
            diag=nema17_w*sqrt(2);
            
            rotate([0,0,45])translate([0,diag/2])square([diag,diag],center=true);
        }
    }
}
module nema_shape_fan_alt()
{
    rounder=3;
    yy=nema17_w-1;
    intersection()
    {
        difference()
        {
            union()
            {
                minkowski()
                {
                    square([yy-rounder*2,yy-rounder*2],center=true);
                    circle(r=rounder,$fn=50);
                }
            }
            //m3 holes

            translate([.5*nema_hole_spacing,.5*nema_hole_spacing])circle(r=m3_slot/2,$fn=50);
            translate([-.5*nema_hole_spacing-6.4,-.5*nema_hole_spacing+.6])circle(r=m3_slot/2,$fn=50);
            
            //
            //motor boss
            //circle(r=nema_boss_size/2,$fn=100);
        }
        //
        *union()
        {
            hole_diag=nema_hole_spacing*sqrt(2)-nema_boss_size;
            for (aa=[-.5:1:.5])
            {
                for (bb=[-.5:1:.5])
                {
                    translate([aa*nema_hole_spacing,bb*nema_hole_spacing])circle(r=hole_diag/2,$fn=50);
                }
            }
            diag=nema17_w*sqrt(2);
            
            rotate([0,0,45])translate([0,diag/2])square([diag,diag],center=true);
        }
    }
}
module carriage_shape_a(inset)
{
    //basic shape-squarish around the mounting holes with extra height for motor
    minkowski()
    {
        square([xxmount-rounder*2-inset,yymount-rounder*2-inset],center=true);
            //line up on the bottom right corner
        circle(r=rounder,$fn=50);
    }
}
module carriage_shape_b(inset)
{
    //basic shape-squarish around the mounting holes with extra height for motor
    minkowski()
    {
            //line up on the bottom right corner
        translate([(xxmount-xxmotor)/2,(yymotor-yymount)/2])square([xxmotor-rounder*2-inset,yymotor-rounder*2-inset],center=true);
        circle(r=rounder,$fn=50);
    }
}
module carriage_shape()
{
    carriage_shape_a(0);
    carriage_shape_b(0);
}

fansize=40;
module fan_bracket()
{

    holespace=32;
    round_r=4;
    m3_slot=3.5;
    translate([0,0,0])rotate([45,0,0])translate([0,-32,-4])linear_extrude(height=7)difference()
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
    //%cube([mount_wall_thick,60,60],center=true);
    
    
    fan_arm_alt();
}
module fan_arm()
{
    intersection()
    {
        rotate([45,0,0])translate([0,0,3.5-4-8])cube([200,200,16+7],center=true);
        union()
        {   
            fan_arm_a();
            
            hull()
            {
                translate([15,0,0])rotate([45,0,0])translate([0,-32+fansize/2,-4])linear_extrude(height=7)translate([])square([mount_wall_thick,mount_wall_thick/2],center=true);
                translate([8,61+.5,9])rotate([90,0,0])translate([motor_nudge,ynudge-yymount/2+nema17_w/2+mount_wall_thick,-ep])
                {
                translate([0,0,nema17_w/2+carriage_wall_thick])rotate([0,90,0])translate([-18,0,-mount_wall_thick])
                    {
                        linear_extrude(height=mount_wall_thick)square([1,nema17_w-1],center=true);
                    }
                }
            }
        }
    }
    //titan position
    intersection()
    {
        rotate([45,0,0])translate([0,0,3.5-4-8])cube([200,200,16+7],center=true);
        difference()
        {
            rotate([30,0,0])translate([3,-32+fansize/2+15-ep-.6,-4+3.5])cube([24,30,7+5],center=true);
            translate([0,25+7.5+.25+.01,0])cube([50,50,50],center=true);
            translate([0,25+7.5+.25+.01-10,33])cube([50,50,50],center=true);
        }
    }
}
module fan_arm_alt()
{
    intersection()
    {
        rotate([45,0,0])translate([0,0,3.5-4-8])cube([200,200,16+7],center=true);
        union()
        {   
            //moved the backet to the other side of the titan
            translate([-titan_width-mount_wall_thick,0,0])fan_arm_a();
            
            difference()
            {
                translate([-titan_width-mount_wall_thick,0,0])hull()
                {
                    translate([15,0,0])rotate([45,0,0])translate([0,-32+fansize/2,-4])linear_extrude(height=7)translate([])square([mount_wall_thick,mount_wall_thick/2],center=true);
                    translate([8,61+.5,9])rotate([90,0,0])translate([motor_nudge,ynudge-yymount/2+nema17_w/2+mount_wall_thick,-ep])
                    {
                    translate([0,0,nema17_w/2+carriage_wall_thick])rotate([0,90,0])translate([-18,0,-mount_wall_thick])
                        {
                            linear_extrude(height=mount_wall_thick)square([1,nema17_w-1],center=true);
                        }
                    }
                }
                translate([-titan_width-mount_wall_thick,0,0])translate([8,61+.5,9])rotate([90,0,0])translate([motor_nudge,ynudge-yymount/2+nema17_w/2+mount_wall_thick,-ep])translate([0,0,nema17_w/2+carriage_wall_thick])rotate([0,90,0])translate([0,0,-mount_wall_thick])translate([0,0,-.5])linear_extrude(height=mount_wall_thick+1)translate([-.5*nema_hole_spacing-6.4,-.5*nema_hole_spacing+.6])circle(r=m3_slot/2,$fn=50);
            }
        }
    }
    //titan position
    intersection()
    {
        rotate([45,0,0])translate([0,0,3.5-4-8])cube([200,200,16+7],center=true);
        translate([-3,0,0])difference()
        {
            rotate([30,0,0])translate([3,-32+fansize/2+15-ep-.6,-4+3.5])cube([24,30,7+5],center=true);
            translate([0,25+7.5+.25+.01,0])cube([50,50,50],center=true);
            translate([0,25+7.5+.25+.01-10,33])cube([50,50,50],center=true);
        }
    }
}
module fan_arm_a()
{
    translate([8,61+.5,9])rotate([90,0,0])translate([motor_nudge,ynudge-yymount/2+nema17_w/2+mount_wall_thick,-ep])
    {
        translate([0,0,nema17_w/2+carriage_wall_thick])
        {
            rotate([0,90,0])translate([0,0,-mount_wall_thick])
            {
                linear_extrude(height=mount_wall_thick)nema_shape_fan_alt();
            }
        }
    }
}
