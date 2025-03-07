//extern number pitch;
extern vec2 screen;
extern float iTime;
varying vec4 vpos;

float inverseLerp( float a, float b, float v) {
    return (v-a)/(b-a);
}

float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}


#ifdef VERTEX
vec4 position ( mat4 transform_projection, vec4 vertex_position) {
    vpos = vertex_position;
    return transform_projection * vertex_position;
}
#endif

#ifdef PIXEL

#define RIPPLES

vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords) {

    float ID1, ID2;
    vec2 P1, P2;
    float t1, t2;
    
    float dt = iTime;
    vec4 out_color;
    vec2 ipos;
    vec2 fpos;
    vec2 sc;
    vec3 output_col;

    sc = vec2(screen_coords.x / screen.x, screen_coords.y / screen.y);

    sc *= 10;
    ipos = floor(sc);
    fpos = fract(sc);

    // Assign a random value based on the integer coord
    output_col = vec3(random( ipos ));

    // Uncomment to see the subdivided grid
    output_col = vec3(fpos,0.0);

    


    

    out_color = vec4 ( output_col, 1);


    

    return out_color;
    
}
#endif