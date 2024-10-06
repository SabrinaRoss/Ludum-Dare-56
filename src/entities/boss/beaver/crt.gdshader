shader_type canvas_item;

uniform int scanline_intensity : hint_range(0, 100) = 50; // Adjustable intensity of scanlines (0 to 100)
uniform int screen_width : hint_range(1, 2000) = 800; // Screen width (integer)
uniform int screen_height : hint_range(1, 2000) = 200; // Screen height (integer)
uniform sampler2D texture0; // The texture being processed
uniform float line_thickness : hint_range(0.0, 10.0) = 2.0; // Thickness of the scanlines (adjustable max thickness)
uniform float second_scanline_frequency : hint_range(0.5, 5.0) = 3.0; // Frequency of the second scanline pattern

void fragment() {
    vec2 uv = UV;

    // Calculate the actual scanline index based on UV coordinates and screen height
    float scanline = floor(uv.y * float(screen_height)); // Get the scanline index

    // Calculate the scanline effect with increased thickness
    float scan_effect = 0.0;
    for (int i = -int(line_thickness); i <= int(line_thickness); i++) {
        float current_scanline = scanline + float(i);
        scan_effect += 0.5 + 0.5 * sin(current_scanline * 3.14159 / float(screen_height));
    }
    scan_effect /= float(int(line_thickness) * 2 + 1); // Average over the thickness range

    // Calculate the second scanline effect with a different frequency
    float second_scanline_effect = 0.5 + 0.5 * sin(scanline * second_scanline_frequency * 3.14159 / float(screen_height));

    // Combine the scanline effects
    scan_effect = scan_effect * second_scanline_effect;

    // Get the color from the texture
    vec4 textureColor = texture(texture0, uv);

    // Convert scanline intensity to a float between 0 and 1
    float intensity = float(scanline_intensity) / 350.0;

    // Calculate alpha for pitch-black scanlines
    float alpha = intensity * (1.0 - scan_effect);

    // Set the final color: pitch-black for lines, transparent for other areas
    if (alpha < 0.05) {
        discard; // Discard non-scanline areas to make them transparent
    }

    // Set the color to pitch black for the scanlines with calculated alpha
    COLOR = vec4(0.0, 0.0, 0.0, 1); // Output pitch-black lines with varying transparency
}