shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
// Xor's gausian blur function 
// Link: https://xorshaders.weebly.com/tutorials/blur-shaders-5-part-2
// Defaults from: https://www.shadertoy.com/view/Xltfzj
//
// BLUR BLURRINESS (Default 8.0)
// BLUR ITERATIONS (Default 16.0 - More is better but slower)
// BLUR QUALITY (Default 4.0 - More is better but slower)
//
// Desc.: Don't have the best performance but will run on almost
// anything, although, if developing for mobile, is better to use 
// 'texture_nodevgaussian(...) instead'.
vec4 texture_xorgaussian(sampler2D tex, vec2 uv, vec2 pixel_size, float blurriness, int iterations, int quality){
	float pi = 6.28;
	
	vec2 radius = blurriness / (1.0 / pixel_size).xy;
	vec4 blurred_tex = texture(tex, uv);
	
	for(float d = 0.0; d < pi; d += pi / float(iterations)){
		for( float i = 1.0 / float(quality); i <= 1.0; i += 1.0 / float(quality) ){
			vec2 directions = uv + vec2(cos(d), sin(d)) * radius * i;
			vec4 add = texture(tex, directions);
			if (add.r+add.g+add.b > 0.5f) {
				blurred_tex += add;
			}
			
		}
	}
	blurred_tex /= float(quality) * float(iterations) + 1.0;
	
	return blurred_tex;
}


//  -- EXAMPLE CODE -- //
uniform int blur_type = 0;
uniform int blur_amount = 2;
uniform float blur_radius = 1;
uniform vec2 blur_direction = vec2(1, 1);
void fragment(){
	vec2 uv = SCREEN_UV.xy;
	vec4 col = texture(screen_texture,vec2(uv.x,uv.y));
	vec4 xorgaussian = texture_xorgaussian(screen_texture, uv, SCREEN_PIXEL_SIZE, float(blur_amount), 16, 4);
	COLOR = col+xorgaussian*0.2f;
	
}