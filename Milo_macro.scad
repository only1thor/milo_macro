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