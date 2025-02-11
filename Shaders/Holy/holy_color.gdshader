shader_type canvas_item;

void fragment() {
	float avg = (COLOR.r+COLOR.g+COLOR.b)*0.33333;
	vec3 delta_avg = vec3( COLOR.r-avg , COLOR.g-avg, COLOR.b-avg );
	
	
	COLOR = vec4(COLOR.r+delta_avg.r, COLOR.g+delta_avg.g, COLOR.b+delta_avg.b, COLOR.a);
	
	
	
	//COLOR.r += 
	
	//COLOR.r = 1.0-COLOR.r;
	//COLOR.g = 1.0-COLOR.g;
	//COLOR.b = 1.0-COLOR.b;
	
}
