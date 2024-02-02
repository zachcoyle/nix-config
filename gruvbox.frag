precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

void main() {
    // Simulate twirly chromatic aberration with reduced strength
    float chromaticAberrationStrength = 0.3;
    vec2 uvRed = v_texcoord + vec2(0.002, 0.002);
    vec2 uvBlue = v_texcoord - vec2(0.002, 0.002);
    float twirlRed = texture2D(tex, uvRed).r;
    float twirlBlue = texture2D(tex, uvBlue).b;
    float twirlyChromaticAberration = mix(mix(twirlRed, twirlBlue, chromaticAberrationStrength), texture2D(tex, v_texcoord).r, chromaticAberrationStrength);

    // Add noise for VCR tape distortion
    float noise = 0.03 * (fract(sin(dot(gl_FragCoord.xy, vec2(12.9898, 78.233))) * 43758.5453) - 0.5);

    // Introduce subtle scanlines
    float scanlineIntensity = 0.02 * sin(gl_FragCoord.y * 0.1);

    // Simulate slight vertical jitter
    float jitter = 0.002 * sin(gl_FragCoord.x * 0.1);

    // Add subtle color shifts
    vec4 pixColor = texture2D(tex, v_texcoord);
    pixColor.r = twirlyChromaticAberration;
    pixColor.rgb += noise;
    pixColor.rgb -= scanlineIntensity;
    pixColor.rgb += jitter;
    pixColor.r *= 0.98; // Slightly decrease red color
    pixColor.g *= 0.99; // Slightly decrease green color
    pixColor.b *= 0.98; // Slightly decrease blue color

    gl_FragColor = pixColor;
}

