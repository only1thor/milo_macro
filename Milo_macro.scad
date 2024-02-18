// top: 1, middle: 0, bottom: -1
render_swap=0;

$fn=50;
$fa=12;
$fs=2;
/* move settings over into this comment block to speed up rendering
*/

// 
switch_number_x=2;
switch_number_y=2;

// affects curvature of the switches
switch_cosine_aplitude=5;
switch_cosine_freq=25;
switch_cosine_phase=20;

switch_spacing=6.2;
switch_width=13.8;

chassis_x=23*switch_number_x;
chassis_y=22*switch_number_y;
chassis_translate_x=5;
chassis_translate_y=1;
rounding=4;

base_thickness=16;
base_outer_wall_thickness=5;
wrap_top_layers_height=6.3;

// additions to the base (bottom part)
base_wall_thickness_addition_x=4;
base_wall_thickness_addition_y=0;
// combind wall thickness, and translation to get empty space for the top or bottom
base_translate_x=-2;
base_translate_y=0;

top_edge_screw_offset=1;

module switch(){
	translate([0,0,1.2])
		cube([switch_width,switch_width,5], center=true);
	translate([0,0,5+1.19])
		cube([switch_width+2.5,switch_width+2.5,5], center=true);
}

socket_length=11.3;
socket_width_1=4.3;
socket_width_2=4;
socket_height=2.8;
socket_plug_height=5.5;

module socket(){
	difference(){
		translate_y=-4.5;
		translate_x=0.7;
		translate([translate_x, translate_y, -(socket_height+1.2)]){
			cube(size=[socket_length, socket_width_1, socket_height], center=true);
			translate([socket_length/2-2.5,socket_width_2/2,0])
			cube(size=[5, socket_width_2, socket_height], center=true);
			translate([-(socket_length+2)/2,-0.4,0])
			cube([4,1.6,socket_height],center=true);
			translate([(socket_length+2)/2,(socket_width_2+0.7)/2,0])
			cube([4,1.6,socket_height],center=true);

			// wire rails
			rail_depth=3;
			// columns
			translate([-7,-translate_y,0])
			cube([1.3,45,rail_depth], center=true);
			// rows 
			translate([-translate_x,9,0])
			cube([21,1.3,rail_depth], center=true);
			translate([9.5,8.5,0])
			cube ([1.3,11,rail_depth], center=true);
			translate([6.75,4,0])
			cube([1.3,11,rail_depth], center=true);
			// diode for the row
			translate([-2,9,0.25])
				rotate([0,90,0]){
					cylinder(h=5.5, d=2.6, center=true);
					translate([1,0,0])
					cube([0.5,2.5,5.5], center=true);
				}
			translate([-socket_length/2+0.7+1.65,-0.35,2.1])
			cylinder(h=6, r=1.65, center=true);
			translate([socket_length/2-0.8-1.55,2.3,2.1])
			cylinder(h=6, r=1.65, center=true);
			// swtich_stub
			translate([-0.7,4.7,2.1])
			cylinder(h=8, r=2.3, center=true);
			//clip a thin wall
			translate([0,0.7,0.15])
			cylinder(h=2.5, r=2.3, center=true);
		}
		translate([0,-6.75,-(socket_plug_height-0.25)])
		scale([2,1,1])
		sphere(0.75);
		translate([4,-0.1,-(socket_plug_height-0.45)])
		scale([2,1,1])
		sphere(0.75);
	}
}

module pro_micro(distanceFromPCB=0)
{
  /*
	Module originally by: Hauke Thorenz <htho@thorenz.net>
    Module from:
	https://github.com/htho/scadlib-electronic-components/blob/5a9610a1a8bb7f51295cfab7b836a92d282b66b0/modules/arduino_compatible/sparkfun/pro_micro.scad#L49
	Licence: cc-by-sa-4.0
	http://creativecommons.org/licenses/by-sa/4.0/

	Edited to center on board center.
  */

  pcb_width = 18.4;
  pcb_depth = 33.6;
  pcb_height = 1.6; //guessed


  usb_depth = 2.85+2.15;
  usb_width = 2*3.9;
  usb_height = 2*1.6;
  usb_center_x = 0; //usb_width/2;
  usb_center_y = -2.15/2;

  usb_pos_x = 0;//8.89/2;
  usb_pos_y = 31.75/2;
  usb_pos_z = (pcb_height/2) + (usb_height/2);

  connector0_x = (pcb_width/2) - 1.27;
  connector0_y = (pcb_depth/2) - (1.27 + 11*2.54);

 translate([0,0,distanceFromPCB]) //translate to the given distance
 rotate([0,0,0]){ //rotating it so the orientation fits the Fritzing part
      cube([pcb_width, pcb_depth, pcb_height], true); //PCB
      translate([usb_pos_x,usb_pos_y,usb_pos_z]) translate([usb_center_x,usb_center_y,0]) cube([usb_width, usb_depth+1, usb_height], true); //USB
  }
}

module rounded_cube(size, radius) {
    hull() {
        for (x=[-1,1], y=[-1,1], z=[-1,1]) {
            translate([x*(size[0]/2 - radius), y*(size[1]/2 - radius), 0])
            cylinder(r=radius, h=size[2], center=true);
        }
    }
}
module screw(){
	translate([0,0,7])
	cylinder(h=4.5 , d1=3.5, d2=2, center=true);
	translate([0,0,0])
	cylinder(h=9.5 , d=4, center=true);
	translate([0,0,-6.5])
	cylinder(h=4 , d1=8, d2=3.8, center=true);
	translate([0,0,-11])
	cylinder(h=5 , d=8, center=true);
}

module top_clip(){
	difference(){
		sphere(3);
		translate([0,0,-2.2])
		cube([10,10,2],center=true);
	}
}

difference(){
	if (render_swap==0) {
		translate([chassis_translate_x, chassis_translate_y, -3.05])
			rounded_cube([chassis_x, chassis_y, 3.5], rounding);
	}
	if (render_swap==1){
		translate([chassis_translate_x,chassis_translate_y,1.2])
			//cube([chassis_x,chassis_y,5], center=true);
			rounded_cube([chassis_x,chassis_y,5], rounding);
		translate([(chassis_translate_x - chassis_x/2), chassis_translate_y - chassis_y/4, -0.1 ]){
			top_clip();
		}
		translate([(chassis_translate_x - chassis_x/2), chassis_translate_y + chassis_y/4, -0.1 ]){
			top_clip();
		}
	}
	if (0<=render_swap){
		// switch and socket placement to be cut out from top 2 chassis models
			for(j=[-(switch_number_y-1)/2:(switch_number_y/2)]){
				for(i=[-(switch_number_x-1)/2:(switch_number_x/2)]){
					translate ([
						i*20+switch_cosine_aplitude*cos(switch_cosine_freq*PI*j + switch_cosine_phase),
						j*20,
						0]){
					rotate([0,0,90]){
						switch();
						if (0==render_swap){
							socket();
						}
					}
					}
				}
		}
		// additonal thick channel for row cables
			translate([chassis_translate_x,(chassis_y/2) -3,-4.15])
			cube([chassis_x,3,3], center=true);
	}
	if (render_swap==-1){
		translate([
			chassis_translate_x + base_translate_x,
			chassis_translate_y + base_translate_y,
			-4.8 - base_thickness/2 + wrap_top_layers_height
			])
			rounded_cube([
				chassis_x + base_outer_wall_thickness + base_wall_thickness_addition_x,
				chassis_y + base_outer_wall_thickness + base_wall_thickness_addition_y,
				base_thickness+wrap_top_layers_height
			], rounding);
	}
	if (render_swap==-1){
		// parts to slice out of the bottom model
		// size of both switch_plate, and socket_plate + 0.5mm tolerance
		translate([chassis_translate_x, chassis_translate_y, -0.1 ])
			rounded_cube([chassis_x + 0.5, chassis_y + 0.5, 9.51], rounding);
		translate([(chassis_translate_x - chassis_x/2), chassis_translate_y - chassis_y/4, -0.1 ]){
			sphere(3);
		}
		translate([(chassis_translate_x - chassis_x/2), chassis_translate_y + chassis_y/4, -0.1 ]){
			sphere(3);
		}

		base_champfer_thickness=50;
		base_champfer_offsset_z=6;
		base_champfer_angle=12;
		translate([
			chassis_translate_x + base_translate_x,
			chassis_translate_y + base_translate_y,
			-base_thickness - base_champfer_thickness/2 + base_champfer_offsset_z
			])
			rotate([0,base_champfer_angle,0])
			cube([
				chassis_x + base_outer_wall_thickness + base_wall_thickness_addition_x + 20,
				chassis_y + base_outer_wall_thickness + base_wall_thickness_addition_y + 20,
				base_champfer_thickness
			], center=true);
		pro_micro_length=33.6;
		pro_micro_width=18.4;
		rotate([0,0,0])
		translate([
			(chassis_x/2)-pro_micro_length/2+chassis_translate_x+1.6,
			0,
			-(base_thickness+wrap_top_layers_height-16)]){
				// TODO: cut channel beneath the pro micro, angeled like the base.
			translate([0,0,2])
			#cube([pro_micro_length,pro_micro_width,5], center=true);
			translate([-3,0,4])
			#cube([pro_micro_length,pro_micro_width,8], center=true);
			rotate([0,0,-90])
			#pro_micro(0);
			translate([chassis_translate_x+4,chassis_translate_y,-1])
			#cube([5,chassis_y,7],center=true);
		}
	}
	// parts to slice out of all 3 models
	translate([0,0,-6.3]){
		translate([
			chassis_x/2 + chassis_translate_x + base_translate_x - top_edge_screw_offset,
			(chassis_y/4 + chassis_translate_y + base_translate_y),
			0
			])
		#screw();
		translate([
			chassis_x/2 + chassis_translate_x + base_translate_x - top_edge_screw_offset,
			-(chassis_y/4 + chassis_translate_y + base_translate_y),
			0
			])
		#screw();
	}
} 
