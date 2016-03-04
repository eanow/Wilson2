tube=5/2;
difference()
{
translate([-5,5,5])import("../stl/extruder_body_fixed.stl");
#translate([-5,5,5])translate([-37.7,50,9.8])rotate(90,[1,0,0])cylinder(r1=tube,r2=tube,h=30,$fn=30);
    #translate([-5,5,5])translate([-37.7,24,9.8])rotate(90,[1,0,0])cylinder(r1=tube,r2=tube+2,h=3,$fn=30);
}
