shader_type canvas_item;

uniform vec4 glow_color: source_color = vec4(0.2, 0.6, 0.3, 1.0);
uniform float glow_power: hint_range(0.0, 8.0, 0.1) = 2.0;

void fragment() {
	vec4 pixel = texture(TEXTURE, UV);
	vec4 glow = pixel * glow_color * glow_power;
	COLOR =  mix(pixel, glow, glow.a);
}
