
#version 330 core

// Inputs from Hyprland / Hyprshade
layout(location = 0) in vec2 v_texcoord;
layout(location = 0) out vec4 out_color;

uniform sampler2D tex;      // the window/desktop texture
uniform float time;         // seconds
uniform vec2 resolution;    // output resolution in pixels

// Simple hash for noise
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

void main() {
    // Normalized UV
    vec2 uv = v_texcoord;

    // Centered coords for distortion / vignette
    vec2 centered = uv - 0.5;
    float radius = dot(centered, centered);

    // Barrel distortion (curved CRT screen)
    float distortion = 0.20; // tweak strength
    vec2 barrel = centered * (1.0 + distortion * radius);
    uv = barrel + 0.5;

    // If outside distorted region, draw dark border (CRT bezel)
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
        out_color = vec4(0.02, 0.02, 0.03, 1.0);
        return;
    }

    // Chromatic aberration (slight RGB offset)
    float ca = 0.0025; // tweak
    vec2 caOffset = ca * (uv - 0.5);

    float r = texture(tex, uv + caOffset).r;
    float g = texture(tex, uv).g;
    float b = texture(tex, uv - caOffset).b;

    vec3 color = vec3(r, g, b);

    // Scanlines (horizontal)
    float scanFreq = resolution.y * 1.0; // lines per screen height
    float scan = 0.90 + 0.10 * sin(uv.y * scanFreq * 3.14159265);
    color *= scan;

    // Vertical mask / subpixel-ish effect
    float maskFreq = resolution.x * 0.5;
    float mask = 0.92 + 0.08 * sin(uv.x * maskFreq * 3.14159265);
    color *= mask;

    // Vignette (dark corners)
    float vignette = 1.0 - radius * 0.7;
    vignette = clamp(vignette, 0.0, 1.0);
    color *= vignette;

    // Subtle temporal noise (flicker / grain)
    float noise = (hash(vec2(uv.x * resolution.x, uv.y * resolution.y + time * 60.0)) - 0.5) * 0.03;
    color += noise;

    // Slight gamma-ish curve
    color = pow(color, vec3(1.1));

    out_color = vec4(color, 1.0);
}

