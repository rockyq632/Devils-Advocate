shader_type canvas_item;

uniform float effect_scalar = 0.4;

void fragment() {
	vec3 comp_clr = vec3(1.0-COLOR.r, 1.0-COLOR.g, 1.0-COLOR.r);
	
	COLOR.r = COLOR.r- (effect_scalar*comp_clr.r);
	COLOR.g = COLOR.g- (effect_scalar*comp_clr.g);
	COLOR.b = COLOR.b- (effect_scalar*comp_clr.b);
	
	COLOR.a = 0.1;
	
}
