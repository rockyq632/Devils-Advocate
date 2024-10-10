shader_type canvas_item;

uniform vec4 line_color : source_color = vec4(1.0,1.0,1.0,0.23);
uniform float line_thickness : hint_range(0.0, 30.0) = 2.0;
uniform float line_fade : hint_range(0.0, 1.0) = 0.5;

const vec2 OFFSETS[8] = {
	vec2(-1, -1), vec2(-1, 0), vec2(-1, 1), vec2(0, -1), vec2(0, 1), 
	vec2(1, -1), vec2(1, 0), vec2(1, 1)
};


void fragment() {
	vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
	vec2 size2 = TEXTURE_PIXEL_SIZE * line_thickness*0.5;
	float outline = 0.0;
	
	for (int i = 0; i < OFFSETS.length(); i++) {
		outline += texture(TEXTURE, UV + size * OFFSETS[i]).a*line_fade;
		outline += texture(TEXTURE, UV + size2 * OFFSETS[i]).a*line_fade;
	}
	outline = min(outline, 1.0);
	
	vec4 color = texture(TEXTURE, UV);
	COLOR = mix(color, line_color, outline - color.a);
}