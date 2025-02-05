shader_type canvas_item;

uniform float highlight_scalar = 1.5;

void fragment() {
	if( COLOR.r > (COLOR.b*highlight_scalar)  &&  COLOR.r > (COLOR.g*highlight_scalar) ) {
		// DO NOTHING
		//COLOR.r *= highlight_scalar;
	}
	else {
		float avg = (COLOR.r + COLOR.g + COLOR.b) * 0.33333;
		COLOR.rgb = vec3(avg);
	}
	
}
