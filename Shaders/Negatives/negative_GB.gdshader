shader_type canvas_item;

void fragment() {
	
	COLOR.b = 1.0-COLOR.b;
	COLOR.g = 1.0-COLOR.g;
	
}
