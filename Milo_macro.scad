switch_spacing=6.2;
switch_width=13.8;
switch_number_x=3;
switch_number_y=1;

foot_height=8;


plate_thickness=1.6;
plate_width=switch_width*1.5*switch_number_x;
plate_length=switch_width*1.5*switch_number_y;

module switch(){
	translate([0,0,1.2])
		cube([switch_width,switch_width,5], center=true);
	translate([0,0,5+1.19])
		cube([switch_width+2.5,switch_width+2.5,5], center=true);
}

module switch_plate(){
	cube([plate_width,plate_length,plate_thickness], center=true);
}

module plate() {
	difference(){
		switch_plate();
		for (i = [-1, 0, 1]) {
			translate([i*(switch_width+switch_spacing),0,0]) switch();
		}
	}

	//feet
	module foot(){
		$fn=100;
		cylinder(h=foot_height, r=2, center=true);
	}
	for (i = [-1, 1]) {
		for (j = [-1, 1]) {
			translate([i*(plate_width/2-2), j*(plate_length/2-2), foot_height/2+plate_thickness/2]) foot();
		}
	}
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
			#cube([1.3,20,rail_depth], center=true);
			// rows 
			translate([-translate_x,9,0])
			#cube([20,1.3,rail_depth], center=true);
			translate([7,4,0])
			#cube([1.3,11,rail_depth], center=true);

			$fn=30;
			translate([-socket_length/2+0.7+1.65,-0.35,2.1])
			cylinder(h=6, r=1.65, center=true);
			translate([socket_length/2-0.8-1.55,2.3,2.1])
			cylinder(h=6, r=1.65, center=true);
			// swtich_stub
			translate([-0.7,4.7,2.1])
			cylinder(h=8, r=2.3, center=true);
		}
		$fn=100;
		translate([0,-6.75,-(socket_plug_height-0.25)])
		scale([2,1,1])
		sphere(0.75);
	}
}

transl=0;
for(j=[0,1])
{
	for(i=[0,1])
	{
		translate ([i*20,j*20,0])
		difference(){
			translate([0, 0, -0.5+transl/2])
			cube(size=[20, 20, 9.5+transl], center=true);
			socket();
			switch();
			//translate([-6.5,0,-4])
			//cube([1.3,20,4], center=true);
		}
	}
}