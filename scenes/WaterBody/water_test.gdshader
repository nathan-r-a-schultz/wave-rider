shader_type canvas_item;

uniform vec4 tint : source_color = vec4(1.0);
uniform float opacity : hint_range(0.0, 1.0) = 0.3;
uniform sampler2D my_texture : source_color, filter_nearest, repeat_enable;
uniform float tint_strength : hint_range(0.0, 1.0) = 0.1;

void fragment() {
	vec2 uv = UV;

	vec4 tex_color = texture(my_texture, fract(uv));

	vec4 final_color = mix(tex_color, tint, tint_strength);

	COLOR = vec4(final_color.rgb, tex_color.a * opacity);
}
