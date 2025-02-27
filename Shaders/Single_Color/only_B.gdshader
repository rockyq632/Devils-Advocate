shader_type canvas_item;

void fragment() {
	// Called for every pixel the material is visible on.
	
	// Find avg for greyscale
	float avg = (COLOR.r+COLOR.g+COLOR.b)*0.33333;
	
	// Called for every pixel the material is visible on.
	COLOR.r = avg;
	COLOR.g = avg;
	
}
