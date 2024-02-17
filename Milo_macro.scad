render_swap=0;


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
			cube([20,1.3,rail_depth], center=true);
			translate([6.75,4,0])
			cube([1.3,11,rail_depth], center=true);
			// diode for the row
			translate([-2,9,0.25])
				rotate([0,90,0]){
					cylinder(h=5.5, r=1.2, center=true);
					translate([1,0,0])
					cube([0.5,2,5.5], center=true);
				}
			$fn=30;
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
		$fn=50;
		translate([0,-6.75,-(socket_plug_height-0.25)])
		scale([2,1,1])
		sphere(0.75);
		translate([4,-0.1,-(socket_plug_height-0.45)])
		scale([2,1,1])
		sphere(0.75);
	}
}


difference(){
	if (render_swap==0) {
		translate([2, 0, -3.05])
			cube(size=[110, 100, 3.5], center=true);
	}
	if (render_swap==1){
		translate([2,0,2.19])
			cube([110,100,3], center=true);
	}
	for(j=[-2:2]){
		for(i=[-2:2])
		{
			translate ([i*20+5*cos(20*PI*j),j*20,0]){
				socket();
				switch();
			}
		}
	}
	$fn=30;
	translate([10,10,0])
		cylinder(h=16, r=1.3, center=true);
	cylinder(h=3 , r1=4, r2=1.3, center=true);
}
