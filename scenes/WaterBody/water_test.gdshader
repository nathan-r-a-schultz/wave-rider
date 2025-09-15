shader_type canvas_item;

uniform vec4 tint : source_color = vec4(1.0);
uniform float opacity : hint_range(0.0, 1.0) = 0.3;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

void fragment(){
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV, 5);
	
	color = mix(color, tint, 1.0);
	color = mix(vec4(0.5), color, 1.4);
	
	COLOR = vec4(color.rgb, opacity);
}