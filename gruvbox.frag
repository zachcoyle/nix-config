precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

void main() {
    vec4 pixColor = texture2D(tex, v_texcoord);

    // Simulate color bleeding
    vec4 bleedColor = texture2D(tex, v_texcoord + vec2(0.01, 0.01));
    pixColor += 0.1 * bleedColor;

    // Add noise for VCR tape distortion
    float noise = 0.05 * (fract(sin(dot(gl_FragCoord.xy, vec2(12.9898,78.233))) * 43758.5453) - 0.5);
    pixColor.rgb += noise;

    // Adjust the color scheme for a retro Gruvbox vibe
    pixColor.r *= 1.2; // Increase red intensity
    pixColor.g *= 0.8; // Decrease green intensity
    pixColor.b *= 0.6; // Decrease blue intensity

    gl_FragColor = pixColor;
}

