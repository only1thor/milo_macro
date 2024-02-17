render_swap=0;

// make the preview render faster
fn_preview=1;
fs_preview=0.1;
fa_preview=3;

fn_render=50;
fs_render=2;
fa_render=12;

switch_spacing=6.2;
switch_width=13.8;
switch_number_x=3;
switch_number_y=1;

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
			cube([1.3,20,rail_depth], center=true);
			// rows 
			translate([-translate_x,9,0])
			cube([21,1.3,rail_depth], center=true);
			translate([9.5,9,0])
			cube ([1.3,9.5,rail_depth], center=true);
			translate([6.75,4,0])
			cube([1.3,11,rail_depth], center=true);
			// diode for the row
			translate([-2,9,0.25])
				rotate([0,90,0]){
					cylinder(h=5.5, r=1.2, center=true);
					translate([1,0,0])
					cube([0.5,2,5.5], center=true);
				}
			if($preview){$fn=fn_preview;$fa=fa_preview;$fs=fs_preview;}
			else{$fn=fn_render;$fa=fa_render;$fs=fs_render;}
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
		if($preview){$fn=fn_preview;$fa=fa_preview;$fs=fs_preview;}
		else{$fn=fn_render;$fa=fa_render;$fs=fs_render;}
		translate([0,-6.75,-(socket_plug_height-0.25)])
		scale([2,1,1])
		sphere(0.75);
		translate([4,-0.1,-(socket_plug_height-0.45)])
		scale([2,1,1])
		sphere(0.75);
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
	translate([0,0,-7.5])
	cylinder(h=4 , d1=8, d2=3.4, center=true);
	translate([0,0,2])
	cylinder(h=15 , d=3.4, center=true);
}

chassis_x=43;
chassis_y=43;
chassis_translate_x=14;
chassis_translate_y=10;
/*
*/
difference(){
	if (render_swap==0) {
		translate([chassis_translate_x, chassis_translate_y, -3.05])
			cube(size=[chassis_x, chassis_y, 3.5], center=true);
	}
	if (render_swap==1){
		translate([chassis_translate_x,chassis_translate_y,1.7])
			cube([chassis_x,chassis_y,6], center=true);
	}
	if (0<=render_swap){
			for(j=[-0:1]){
				for(i=[-0:1])
				{
					/*
					*/
					translate ([i*20+5*cos(20*PI*j),j*20,0]){
					rotate([0,0,90]){
						socket();
						switch();
					}
					}
				}
		}
	}
	if (render_swap==-1){
		base_thickness=12.2;
		base_outer_wall_thickness=3;
		wrap_top_layers_height=6.3;
		translate([
			chassis_translate_x,
			chassis_translate_y,
			-4.8 - base_thickness/2 + wrap_top_layers_height
			])
			rounded_cube([
				chassis_x + base_outer_wall_thickness,
				chassis_y + base_outer_wall_thickness,
				base_thickness+wrap_top_layers_height
			], 3);
	}
	if (render_swap==-1){
		// size of both switch_plate, and socket_plate + 0.5mm tolerance
		translate([chassis_translate_x, chassis_translate_y, -0.1 ])
			cube([chassis_x+ 0.5, chassis_y+ 0.5, 9.51], center=true);
		
	}
	if($preview){$fn=fn_preview;$fa=fa_preview;$fs=fs_preview;}
	else{$fn=fn_render;$fa=fa_render;$fs=fs_render;}
	translate([0,0,-5]){
		translate([13,10,0])
		#screw();
	}
}
