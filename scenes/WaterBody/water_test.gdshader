shader_type canvas_item;

uniform vec4 tint : source_color = vec4(1.0);
uniform float opacity : hint_range(0.0, 1.0) = 0.3;
uniform sampler2D my_texture : source_color, filter_nearest, repeat_enable;
uniform float tint_strength : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	// Polygon2D gives us custom UVs
	vec2 uv = UV;

	// Repeat texture cleanly
	vec4 tex_color = texture(my_texture, fract(uv));

	// Blend with tint
	vec4 final_color = mix(tex_color, tint, tint_strength);

	COLOR = vec4(final_color.rgb, final_color.a * opacity);
}
