shader_type canvas_item;

uniform float scroll_speed : hint_range(0.0, 5.0) = 1.0;
uniform float wave_amplitude : hint_range(0.0, 0.1) = 0.02;
uniform float wave_frequency : hint_range(0.1, 10.0) = 2.0;
uniform float wave_speed : hint_range(0.0, 5.0) = 2.0;
uniform vec4 water_color : source_color = vec4(0.2, 0.4, 0.8, 0.8);
uniform vec4 wave_color : source_color = vec4(0.6, 0.8, 1.0, 1.0);

void fragment() {
    vec2 uv = UV;
    float time = TIME;
    
    // Create scrolling effect
    uv.x += scroll_speed * time * 0.1;
    
    // Create multiple wave layers for more complex ripples
    float wave1 = sin(uv.x * wave_frequency * 3.0 + time * wave_speed) * wave_amplitude;
    float wave2 = sin(uv.x * wave_frequency * 1.5 + time * wave_speed * 0.8) * wave_amplitude * 0.7;
    float wave3 = cos(uv.x * wave_frequency * 2.2 + time * wave_speed * 1.2) * wave_amplitude * 0.5;
    
    // Combine waves
    float combined_waves = wave1 + wave2 + wave3;
    
    // Apply waves to the Y coordinate for ripple effect
    uv.y += combined_waves;
    
    // Create wave highlights
    float wave_highlight = abs(combined_waves) * 3.0;
    
    // Mix base water color with wave highlights
    vec4 final_color = mix(water_color, wave_color, wave_highlight);
    
    COLOR = final_color;
}