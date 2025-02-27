shader_type canvas_item;

void fragment() {
	// Find avg for greyscale
	float avg = (COLOR.r+COLOR.g+COLOR.b)*0.33333;
	
	// Called for every pixel the material is visible on.
	COLOR.b = avg;
	COLOR.g = avg;
	
}
