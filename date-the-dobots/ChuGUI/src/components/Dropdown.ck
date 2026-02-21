@import "../lib/UIUtil.ck"
@import "../lib/MouseState.ck"
@import "../lib/GComponent.ck"
@import "../gmeshes/GRect.ck"
@import "../gmeshes/GIcon.ck"
@import "../UIStyle.ck"

public class Dropdown extends GComponent {
    GRect gField --> this;
    GText gLabel --> this;
    GIcon gArrow --> this;
    GRect gList --> this;
    GRect gItemRects[0];
    GText gItems[0];

    string _options[0];
    int _selectedIndex;
    int _open;
    
    string _placeholder;

    new MouseState(this, gField) @=> _state;

    -1 => int _hoveredIndex;

    fun Dropdown() {
        gArrow.icon(me.dir() + "../assets/icons/arrow-down.png");
    }

    // ==== Getters and Setters ====

    fun void options(string opts[]) {
        opts @=> _options;
        allocateItems();
    }
    fun int selectedIndex() { return _selectedIndex; }
    fun void selectedIndex(int idx) {
        idx => _selectedIndex;
        clampSelection();
    }
    fun void placeholder(string placeholder) { placeholder => _placeholder; }

    fun void clampSelection() {
        if (_options.size() == 0 || _selectedIndex == -1) { -1 => _selectedIndex; return; }
        if (_selectedIndex < 0) 0 => _selectedIndex;
        if (_selectedIndex >= _options.size()) _options.size()-1 => _selectedIndex;
    }

    fun void allocateItems() {
        if (_options.size() != gItems.size()) {
            for (GText t : gItems) {
                if (t.parent() != null) t --< this;
            }
            for (GRect r : gItemRects) {
                if (r.parent() != null) r --< this;
            }

            gItems.size(_options.size());
            gItemRects.size(_options.size());

            for (0 => int i; i < _options.size(); i++) {
                GText t @=> gItems[i];
                GRect r @=> gItemRects[i];
            }
        }
    }

    // ==== Update ====

    fun void updateUI() {
        UIStyle.color(UIStyle.COL_DROPDOWN, @(0.5, 0.5, 0.5, 1)) => vec4 color;
        UIStyle.color(UIStyle.COL_DROPDOWN_BORDER, @(0, 0, 0, 1)) => vec4 borderColor;
        UIStyle.color(UIStyle.COL_DROPDOWN_TEXT, @(0, 0, 0, 1)) => vec4 textColor;
        UIStyle.color(UIStyle.COL_DROPDOWN_ARROW, textColor) => vec4 arrowColor;

        UIUtil.sizeToWorld(UIStyle.varVec2(UIStyle.VAR_DROPDOWN_SIZE, @(3, 0.4))) => vec2 size;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_DROPDOWN_TEXT_SIZE, 0.2)) => float textSize;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_DROPDOWN_BORDER_RADIUS, 0)) => float borderRadius;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_DROPDOWN_BORDER_WIDTH, 0.1)) => float borderWidth;
        UIStyle.varString(UIStyle.VAR_DROPDOWN_FONT, "") => string font;

        UIStyle.varVec2(UIStyle.VAR_DROPDOWN_CONTROL_POINTS, @(0.5, 0.5)) => vec2 controlPoints;
        UIStyle.varFloat(UIStyle.VAR_DROPDOWN_Z_INDEX, 0.0) => float zIndex;
        UIStyle.varFloat(UIStyle.VAR_DROPDOWN_ROTATE, 0.0) => float rotate;

        if (_disabled) {
            UIStyle.color(UIStyle.COL_DROPDOWN_DISABLED, color) => color;
            UIStyle.color(UIStyle.COL_DROPDOWN_TEXT_DISABLED, textColor) => textColor;
            UIStyle.color(UIStyle.COL_DROPDOWN_BORDER_DISABLED, borderColor) => borderColor;
        } else if (_open) {
            UIStyle.color(UIStyle.COL_DROPDOWN_OPEN, color) => color;
            UIStyle.color(UIStyle.COL_DROPDOWN_TEXT_OPEN, textColor) => textColor;
            UIStyle.color(UIStyle.COL_DROPDOWN_BORDER_OPEN, borderColor) => borderColor;
        } else if (_state.hovered()) {
            UIStyle.color(UIStyle.COL_DROPDOWN_HOVERED, @(color.x, color.y, color.z, color.a / 2)) => color;
            UIStyle.color(UIStyle.COL_DROPDOWN_TEXT_HOVERED, textColor) => textColor;
            UIStyle.color(UIStyle.COL_DROPDOWN_BORDER_HOVERED, borderColor) => borderColor;
        }

        UIStyle.color(UIStyle.COL_DROPDOWN_ITEM_TEXT, textColor) => vec4 itemTextColor;
        UIStyle.color(UIStyle.COL_DROPDOWN_ITEM_TEXT_HOVERED, itemTextColor) => vec4 itemTextHoveredColor;
        UIStyle.color(UIStyle.COL_DROPDOWN_ITEM_TEXT_SELECTED, itemTextColor) => vec4 itemTextSelectedColor;

        UIStyle.color(UIStyle.COL_DROPDOWN_ITEM_BORDER, borderColor) => vec4 itemBorderColor;
        UIStyle.color(UIStyle.COL_DROPDOWN_ITEM_BORDER_HOVERED, itemBorderColor) => vec4 itemBorderHoveredColor;
        UIStyle.color(UIStyle.COL_DROPDOWN_ITEM_BORDER_SELECTED, itemBorderColor) => vec4 itemBorderSelectedColor;
        
        UIStyle.color(UIStyle.COL_DROPDOWN_ITEM, color) => vec4 itemColor;
        UIStyle.color(UIStyle.COL_DROPDOWN_ITEM_HOVERED, @(itemColor.x, itemColor.y, itemColor.z, itemColor.a / 2)) => vec4 itemHoveredColor;
        UIStyle.color(UIStyle.COL_DROPDOWN_ITEM_SELECTED, itemColor) => vec4 itemSelectedColor;

        gField.size(size);
        gField.color(color);
        gField.borderRadius(borderRadius);
        gField.borderWidth(borderWidth);
        gField.borderColor(borderColor);

        gLabel.text(_selectedIndex>=0 ? _options[_selectedIndex] : _placeholder);
        gLabel.font(font);
        gLabel.color(textColor);
        gLabel.size(textSize);
        gLabel.controlPoints(@(0,0.5));
        gLabel.posX(-size.x/2 + 0.1 * size.x);
        gLabel.posZ(0.1);

        gArrow.color(arrowColor);
        gArrow.sca(@(textSize,textSize));
        gArrow.posX(size.x/2 - textSize);

        applyLayout(size, controlPoints, zIndex, rotate);

        if (_open) {
            _options.size() * size.y => float listH;
            gList.size(@(size.x,listH));
            gList.color(color);
            gList.borderRadius(borderRadius);
            gList.borderWidth(borderWidth);
            gList.borderColor(borderColor);
            gList.posY(-size.y/2 - listH/2);

            for (0 => int i; i < _options.size(); i++) {
                gItemRects[i] @=> GRect r;
                gItems[i] @=> GText t;

                r --> this;
                t --> this;

                if (i == _hoveredIndex) {
                    r.color(itemHoveredColor);
                    r.borderColor(itemBorderHoveredColor);
                    t.color(itemTextHoveredColor);
                } else if (i == _selectedIndex) {
                    r.color(itemSelectedColor);
                    r.borderColor(itemBorderSelectedColor);
                    t.color(itemTextSelectedColor);
                } else {
                    r.color(itemColor);
                    r.borderColor(itemBorderColor);
                    t.color(itemTextColor);
                }

                r.size(@(size.x,size.y));
                r.borderRadius(borderRadius);
                r.borderWidth(borderWidth);
                r.posY(-size.y/2 - size.y*i - size.y/2);

                t.text(_options[i]);
                t.font(font);
                t.sca(textSize);
                t.controlPoints(@(0,0.5));
                t.posY(r.pos().y);
                t.posX(-size.x/2 + 0.1 * size.x);
                t.posZ(0.1);
            }
        } else {
            if (gList.parent() != null) { gList --< this; }
            for (GRect r : gItemRects) {
                if (r.parent() != null) { r --< this; }
            }
            for (GText t : gItems) {
                if (t.parent() != null) { t --< this; }
            }
        }
    }

    fun void update() {
        _state.update();
        
        if (!_disabled) {
            if (_state.clicked()) {
                !_open => _open;
            }

            -1 => _hoveredIndex;

            if (_open) {
                for (0 => int i; i < _options.size(); i++) {
                    UIUtil.hovered(this, gItemRects[i]) => int hovered;
                    if (hovered && _state.mouseState()) {
                        i => _selectedIndex;
                        clampSelection();
                        false => _open;
                        break;
                    } else if (hovered) {
                        i => _hoveredIndex;
                    }
                }
            }
        }

        updateUI();
    }
}
