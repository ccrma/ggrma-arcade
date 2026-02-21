@import "spring.ck"

public class QuestionMark extends GGen {
    "
    #include FRAME_UNIFORMS
    #include DRAW_UNIFORMS
    #include STANDARD_VERTEX_INPUT
    #include STANDARD_VERTEX_OUTPUT
    #include STANDARD_VERTEX_SHADER

    @group(1) @binding(0) var<uniform> u_color : vec3f;
    @group(1) @binding(1) var u_sampler : sampler;
    @group(1) @binding(2) var u_color_map : texture_2d<f32>;
    @group(1) @binding(3) var<uniform> u_fill_y : f32;

    fn srgbToLinear(c : vec4f) -> vec4f {
        return vec4f(
            pow(c.r, 2.2),
            pow(c.g, 2.2),
            pow(c.b, 2.2),
            c.a
        );
    }

    @fragment 
    fn fs_main(in : VertexOutput) -> @location(0) vec4f
    {   
        let uv = in.v_uv;
        var col = srgbToLinear(textureSample(u_color_map, u_sampler, uv));

        let fill_y = uv.y + .02*sin(10*uv.x + 3*u_frame.time);

        if (fill_y < u_fill_y) { col *= vec4f(u_color, 1); }

        // alpha test
        if (col.a < .01) { discard; }

        return col;
    }
    " => static string shader_code;

    static Shader@ fill_shader;
    static Texture@ tex;

    Spring spring(0, 4200, 20);
    Spring rot_spring(0, 3500, 12);

    SndBuf tick(me.dir() + "../assets/audio/tick.wav") => dac; tick.samples() => tick.pos;
    SndBuf tock(me.dir() + "../assets/audio/tock.wav") => dac; tock.samples() => tock.pos;
    SndBuf alarm(me.dir() + "../assets/audio/alarm.wav") => dac; alarm.samples() => alarm.pos;

    if (fill_shader == null) {
        ShaderDesc shader_desc;
        shader_code => shader_desc.vertexCode;
        shader_code => shader_desc.fragmentCode;

        // create shader from shader_desc
        new Shader(shader_desc) @=> fill_shader; 

        // load tex
        TextureLoadDesc load_desc;
        true => load_desc.flip_y;  // flip the texture vertically
        true => load_desc.gen_mips; // generate mip maps automatically
        Texture.load(me.dir() + "../assets/ui/question_mark.png", load_desc) @=> tex;
    }

    Material material;
    true => material.transparent;
    fill_shader => material.shader; // connect shader to material

    material.uniformFloat3(0, Color.hex(0x901212));
    material.sampler(1, TextureSampler.linear());
    material.texture(2, tex);
    material.uniformFloat(3, 0);

    PlaneGeometry geo;
    GMesh mesh(geo, material) --> this;

    float _last_percentage;
    fun void fill(float percentage) { 
        material.uniformFloat(3, percentage); 
        percentage => _last_percentage;
    }
    fun float fill() { return _last_percentage; }
    fun void color(vec3 color) { material.uniformFloat3(0, color); }
    fun void alert() { 
        spring.pull(.5); 
        spork ~ _alarmShred();
    }

    fun void _alarmShred() {
        0 => alarm.pos;
        1 => alarm.gain;
        // linearly ramp down volume
        now + alarm.length() => time later;
        now => time start;
        while (now < later) {
            Math.pow(1 - ((now - start) / alarm.length()), 2) => alarm.gain;
            second => now;
        }
    }

    int warn_count;
    fun void warn() { 
        rot_spring.pull(.12); 
        if (warn_count++ % 2) {
            0 => tick.pos;
        } else {
            0 => tock.pos;
        }
        
    }

    fun void update(float dt) {
        spring.update(dt);
        rot_spring.update(dt);

        1 + spring.x => mesh.sca;
        rot_spring.x => mesh.rotZ;
    }
}

// unit test
if (1) {
    QuestionMark mark --> GG.scene();

    UI_Float3 color(Color.hex(0x901212));
    UI_Float y;
    UI_Float force(.1);

    // render loop
    while (1)
    {
        GG.nextFrame() => now;

        // Math.sin(now/second) => mark.fill;
        // .5 => mark.fill;

        UI.slider("fill", y, 0, 1);
        UI.colorEdit("color", color);
        UI.slider("force", force, 0, 1);

        // if (UI.button("bounce")) mark.spring.pull(force.val());
        if (UI.button("bounce")) {
            mark.warn();
            // mark.alert();
            // mark.rot_spring.pull(force.val());
        }


        y.val() => mark.fill;
        // mark.color(color.val());


    }
}