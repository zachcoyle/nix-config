precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

void main() {
    vec4 pixColor = texture2D(tex, v_texcoord);

    // Simulate color bleeding with reduced intensity
    vec4 bleedColor = texture2D(tex, v_texcoord + vec2(0.0015, 0.0015));
    pixColor += 0.02 * bleedColor;

    // Add noise for VCR tape distortion
    float noise = 0.02 * (fract(sin(dot(gl_FragCoord.xy, vec2(12.9898, 78.233))) * 43758.5453) - 0.5);
    pixColor.rgb += noise;

    // Introduce subtle scanlines with reduced intensity
    float scanlineIntensity = 0.015 * sin(gl_FragCoord.y * 0.1);
    pixColor.rgb -= scanlineIntensity;

    // Simulate slight vertical jitter with reduced intensity
    float jitter = 0.0015 * sin(gl_FragCoord.x * 0.1);
    pixColor.rgb += jitter;

    // Add subtle color shifts with reduced intensity
    pixColor.r *= 0.985; // Slightly decrease red color
    pixColor.g *= 0.995; // Slightly decrease green color
    pixColor.b *= 0.985; // Slightly decrease blue color

    // Simulate chromatic aberration with reduced intensity
    vec2 aberration = vec2(0.002, 0.002);
    vec4 redChannel = texture2D(tex, v_texcoord + aberration);
    vec4 greenChannel = texture2D(tex, v_texcoord);
    vec4 blueChannel = texture2D(tex, v_texcoord - aberration);

    pixColor = vec4(redChannel.r, greenChannel.g, blueChannel.b, pixColor.a);

    // Add VHS-like fuzz with reduced intensity
    float fuzz = 0.015 * sin(gl_FragCoord.y * 0.1);
    pixColor.rgb += fuzz;

    gl_FragColor = pixColor;
}

