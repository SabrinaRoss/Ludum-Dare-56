shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
uniform int rows = 2;
uniform int columns = 2;

void fragment() {
	vec2 uv = vec2(UV.x, 1.0 - UV.y);
	vec2 grid_uv = vec2((uv.x - floor(uv.x/(1.0/float(rows))) * 1.0/float(rows))*float(rows), (uv.y - floor(uv.y/(1.0/float(columns))) * 1.0/float(columns)) * float(columns));
	vec4 text = texture(SCREEN_TEXTURE, grid_uv);
	COLOR = text;
}