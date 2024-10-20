shader_type canvas_item;

void fragment() {
	if(COLOR.r<0.1){
		COLOR.r = 0.0;
	}
	COLOR.a = COLOR.r;
	
}