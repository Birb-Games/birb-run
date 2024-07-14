// Still not totally satisfied with the current effect, so I left in the functions required for rainbow
shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D noise;

// Function to calculate minimum of three floats
//float min3(float a, float b, float c) {
    //return min(min(a, b), c);
//}

// Function to convert hue to RGB
//vec4 hue_to_rgb(float h) {
    //float kr = mod(5.0 + h * 6.0, 6.0);
    //float kg = mod(3.0 + h * 6.0, 6.0);
    //float kb = mod(1.0 + h * 6.0, 6.0);
//
    //float r = 1.0 - max(min3(kr, 4.0 - kr, 1.0), 0.0);
    //float g = 1.0 - max(min3(kg, 4.0 - kg, 1.0), 0.0);
    //float b = 1.0 - max(min3(kb, 4.0 - kb, 1.0), 0.0);
//
    //return vec4(r, g, b, 1.0);
//}

const float NOISE_SCROLL_SPEED = 0.2;

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV);
	
	COLOR = vec4(255.0, 215.0, 0.0, 1.0);
	
	// This only works if there are 3 distinct frames for animation and
	// if all those three frames are on the same row in the spritesheet
	// Kind of a hack, but it works for now
	vec2 noise_uv = vec2(fract(UV.x * 3.0), UV.y);
	noise_uv = fract(noise_uv + vec2(0.0, TIME * NOISE_SCROLL_SPEED));
	COLOR.a -= texture(noise, noise_uv).r * 3.0 / 4.0;
	
	COLOR *= pixelColor.a;
}
