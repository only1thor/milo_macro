switch_spacing=6.2;
switch_width=13.8;
switch_number_x=3;
switch_number_y=1;

foot_height=8;


plate_thickness=1.6;
plate_width=switch_width*1.5*switch_number_x;
plate_length=switch_width*1.5*switch_number_y;

module switch(){
	cube([switch_width,switch_width,10], center=true);
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
socket_width_1=4;
socket_width_2=4;
socket_height=1.8;
socket_plug_height=5.5;

module socket(){
	cube(size=[socket_length, socket_width_1, socket_height], center=true);
	translate([socket_length/2-2.5,socket_width_2/2,0])
	cube(size=[5, socket_width_2, socket_height], center=true);
	translate([-(socket_length+2)/2,-0.4,0])
	cube([2,1.6,1.8],center=true);
	translate([(socket_length+2)/2,(socket_width_2+1)/2,0])
	cube([2,1.6,1.8],center=true);
}

difference(){
	cube(size=[15, 15, 2.5], center=true);
	translate([0,0,0.4])
	socket();
}