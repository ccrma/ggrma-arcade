// Based on the GLSL code here: https://jsfiddle.net/felixmariotto/ozds3yxa/16/
public class RectMaterial extends Material {
    float _borderRadius, _borderWidth;
    vec2 _size;
    vec4 _color, _borderColor;

    // ---- Getters and Setters ----

    fun float borderRadius() { return _borderRadius; }
    fun void borderRadius(float r) { r => _borderRadius; update(); }

    fun float borderWidth() { return _borderWidth; }
    fun void borderWidth(float borderWidth) { borderWidth => _borderWidth; update(); }

    fun vec2 size() { return _size; }
    fun void size(vec2 s) { s => _size; update(); }
    
    fun vec4 color() { return _color; }
    fun void color(vec4 c) { c => _color; update(); }
    
    fun vec4 borderColor() { return _borderColor; }
    fun void borderColor(vec4 borderColor) { borderColor => _borderColor; update(); }

    // ---- WGSL Functions ----

    fun void init() {
        // WGSL vertex shader
        "
            #include FRAME_UNIFORMS
            #include DRAW_UNIFORMS
            #include STANDARD_VERTEX_INPUT

            struct VertexOutput {
                @builtin(position) position : vec4<f32>,
                @location(0) v_uv : vec2<f32>,
            };

            @vertex 
            fn vs_main(in : VertexInput) -> VertexOutput {
                var out : VertexOutput;
                let u_draw : DrawUniforms = u_draw_instances[in.instance];
                
                out.v_uv = in.uv;
                out.position = (u_frame.projection * u_frame.view * u_draw.model) * vec4<f32>(in.position, 1.0);
                
                return out;
            }
        " => string vert;

        // WGSL fragment shader
        "
            #include FRAME_UNIFORMS
            #include DRAW_UNIFORMS

            struct FragmentInput {
                @location(0) v_uv : vec2<f32>,
            };

            @group(1) @binding(0) var<uniform> u_borderRadius : f32;
            @group(1) @binding(1) var<uniform> u_borderWidth : f32;
            @group(1) @binding(2) var<uniform> u_size : vec2<f32>;
            @group(1) @binding(3) var<uniform> u_color : vec4<f32>;
            @group(1) @binding(4) var<uniform> u_borderColor : vec4<f32>;

            fn getEdgeDist(uv: vec2<f32>) -> f32 {
                let ndc = vec2<f32>(uv.x * 2.0 - 1.0, uv.y * 2.0 - 1.0);
                let planeSpaceCoord = vec2<f32>(u_size.x * 0.5 * ndc.x, u_size.y * 0.5 * ndc.y);
                let corner = u_size * 0.5;
                let offsetCorner = corner - abs(planeSpaceCoord);
                let innerRadDist = min(offsetCorner.x, offsetCorner.y) * -1.0;
                let roundedDist = length(max(abs(planeSpaceCoord) - u_size * 0.5 + u_borderRadius, vec2<f32>(0.0))) - u_borderRadius;
                let s = step(innerRadDist * -1.0, u_borderRadius);
                return mix(innerRadDist, roundedDist, s);
            }

            @fragment 
            fn fs_main(in : FragmentInput) -> @location(0) vec4<f32> {
                let edgeDist = getEdgeDist(in.v_uv);
                
                if (edgeDist > 0.0) {
                    discard;
                }
                
                var finalColor = u_color;
                if (edgeDist * -1.0 < u_borderWidth) {
                    finalColor = u_borderColor;
                }
                
                return finalColor;
            }
        " => string frag;

        ShaderDesc desc;
        vert => desc.vertexCode;
        frag => desc.fragmentCode;
        0 => desc.lit;

        new Shader(desc) => shader;

        update();
    }

    fun void update() {
        uniformFloat(0, _borderRadius);
        uniformFloat(1, _borderWidth);
        uniformFloat2(2, _size);
        uniformFloat4(3, _color);
        uniformFloat4(4, _borderColor);
    }
}