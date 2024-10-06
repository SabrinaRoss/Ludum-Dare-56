shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform float size_x = 0.0103;
uniform float size_y = 0.103;

void fragment() {
	vec2 uv = SCREEN_UV;
	uv -= mod(uv, vec2(size_x, size_y));
	
	COLOR.rgb = textureLod(SCREEN_TEXTURE, uv, 0.0).rgb;
}
float rand(vec2 co) {
	return fract(sin(dot(co.xy ,vec2(12.9898, 78.233))) * 43758.5453);
}