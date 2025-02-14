//extern number pitch;
extern vec2 screen;
extern float iTime;

number offset = .6;
vec4 color_a = vec4(1.0, 0.0, 0.0, 1.0);
vec4 color_b = vec4(0.0, 0.0, 1.0, 1.0);
float color_start = 0.4;
float color_end = 0.6;

varying vec4 vpos;

float inverseLerp( float a, float b, float v) {
    return (v-a)/(b-a);
}


#ifdef VERTEX
vec4 position ( mat4 transform_projection, vec4 vertex_position) {
    vpos = vertex_position;
    return transform_projection * vertex_position;
}
#endif

#ifdef PIXEL
vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords) {

    vec2 sc = vec2(screen_coords.x / screen.x, screen_coords.y / screen.y);

    color_a.y = abs(sin(color_a.y + iTime * .5) * .9);
    color_b.x = abs(cos(color_b.x + iTime * .5) * .9);
    color_a.w = 1;  
    color_b.w = 1;  

    /*Trying lerping*/

    float t = clamp(inverseLerp(color_start, color_end, sc.x), 0, 1);

    vec4 outColor = mix(color_a, color_b, t);

    return outColor;
    
}
#endif