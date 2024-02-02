precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

void main() {
    vec4 pixColor = texture2D(tex, v_texcoord);

    // Simulate color bleeding
    vec4 bleedColor = texture2D(tex, v_texcoord + vec2(0.005, 0.005));
    pixColor += 0.05 * bleedColor;

    // Add noise for VCR tape distortion
    float noise = 0.03 * (fract(sin(dot(gl_FragCoord.xy, vec2(12.9898, 78.233))) * 43758.5453) - 0.5);
    pixColor.rgb += noise;

    // Introduce subtle scanlines
    float scanlineIntensity = 0.02 * sin(gl_FragCoord.y * 0.1);
    pixColor.rgb -= scanlineIntensity;

    // Simulate slight vertical jitter
    float jitter = 0.005 * sin(gl_FragCoord.x * 0.1);
    pixColor.rgb += jitter;

    // Add subtle color shifts
    pixColor.r *= 0.95; // Slightly decrease red color
    pixColor.g *= 0.98; // Slightly decrease green color
    pixColor.b *= 0.97; // Slightly decrease blue color

    // Simulate chromatic aberration
    vec2 aberration = vec2(0.005, 0.005);
    vec4 redChannel = texture2D(tex, v_texcoord + aberration);
    vec4 greenChannel = texture2D(tex, v_texcoord);
    vec4 blueChannel = texture2D(tex, v_texcoord - aberration);

    pixColor = vec4(redChannel.r, greenChannel.g, blueChannel.b, pixColor.a);

    gl_FragColor = pixColor;
}

