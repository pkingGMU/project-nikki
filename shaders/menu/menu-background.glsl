extern number pitch;

vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords) {

    vec4 og_color = vec4(1.0, 1.0, 1.0, 1.0);

    float norm_pitch = pitch / 80;

    vec3 pitch_pixel = og_color.rgb * norm_pitch;

    return vec4(pitch_pixel,1.0);
}