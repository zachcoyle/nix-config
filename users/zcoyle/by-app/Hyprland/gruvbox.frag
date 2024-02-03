precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

void main() {
    // Simulate twirly chromatic aberration with reduced strength
    float chromaticAberrationStrength = 0.2;
    vec2 uvRed = v_texcoord + vec2(0.002, 0.002);
    vec2 uvBlue = v_texcoord - vec2(0.002, 0.002);
    float twirlRed = texture2D(tex, uvRed).r;
    float twirlBlue = texture2D(tex, uvBlue).b;
    float twirlyChromaticAberration = mix(mix(twirlRed, twirlBlue, chromaticAberrationStrength), texture2D(tex, v_texcoord).r, chromaticAberrationStrength);

    // Add noise for VCR tape distortion
    float noise = 0.02 * (fract(sin(dot(gl_FragCoord.xy, vec2(12.9898, 78.233))) * 43758.5453) - 0.5);

    // Introduce subtle scanlines
    float scanlineIntensity = 0.015 * sin(gl_FragCoord.y * 0.1);

    // Simulate slight vertical jitter
    float jitter = 0.002 * sin(gl_FragCoord.x * 0.1);

    // Add subtle color shifts and maintain vintage aesthetic
    vec4 pixColor = texture2D(tex, v_texcoord);
    pixColor.rgb += vec3(0.02, 0.01, 0.005); // Adjust for warm tones (orangey-browney)
    pixColor.rgb *= vec3(1.1, 1.05, 1.0); // Adjust for subtle vintage vibe
    pixColor.r = twirlyChromaticAberration;
    pixColor.rgb += noise;
    pixColor.rgb -= scanlineIntensity;
    pixColor.rgb += jitter;

    // Adjust the green and blue components for a better Gruvbox color
    pixColor.g = clamp(pixColor.g + 0.01, 0.0, 1.0);
    pixColor.b = clamp(pixColor.b - 0.005, 0.0, 1.0);

    gl_FragColor = pixColor;
}

