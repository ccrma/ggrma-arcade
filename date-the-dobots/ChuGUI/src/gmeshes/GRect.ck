// GRect.ck
@import "../materials/RectMaterial.ck"

@doc "GPlane with extra customizability."
public class GRect extends GMesh {
    vec2 _size;
    RectMaterial _mat;
    PlaneGeometry _geo;

    @doc "Default constructor for GRect."
    fun GRect() {
        _mat.init();
       _mat => this.material;
        _geo.build(_size.x, _size.y, 1, 1);
        _geo => this.geo;
    }

    // ---- Getters and Setters ----

    @doc "Get the border radius."
    fun float borderRadius() { return _mat.borderRadius(); }
    @doc "Set the border radius."
    fun void borderRadius(float radius) { 
        Math.clampf(radius, 0, 1) => radius;
        radius * Math.min(_size.x, _size.y) * 0.5 => radius;
        _mat.borderRadius(radius);
    }

    @doc "Get the border width."
    fun float borderWidth() { return _mat.borderWidth(); }
    @doc "Set the border radius."
    fun void borderWidth(float borderWidth) {
        Math.clampf(borderWidth, 0, 1) => borderWidth;
        borderWidth * Math.min(_size.x, _size.y) * 0.5 => borderWidth;
        _mat.borderWidth(borderWidth);
    }

    @doc "Get the size."
    fun vec2 size() { return _size; }
    @doc "Set the size."
    fun void size(vec2 size) {
        size => _size;
        _mat.size(size);
        _geo.build(_size.x, _size.y, 1, 1);
    }

    @doc "Get the color."
    fun vec4 color() { return _mat.color(); }
    @doc "Set the color."
    fun void color(vec4 c) { _mat.color(c); }

    @doc "Get the border color."
    fun vec4 borderColor() { return _mat.borderColor(); }
    @doc "Set the border color."
    fun void borderColor(vec4 borderColor) { _mat.borderColor(borderColor); }

    @doc "Set whether the rect is transparent or not."
    fun void transparent(int transparent) { _mat.transparent(transparent); }
}