shader_type canvas_item;

uniform vec2 rect = vec2(0,0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV;
	uv = floor(uv * rect) / rect;
	uv = uv * 2. - 1.;
	float circ_mask = length(uv) - 1.;
	circ_mask = step(0., circ_mask);
	circ_mask = 1. - circ_mask;
	
	COLOR.a = circ_mask;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
