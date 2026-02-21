@import "../lib/UIUtil.ck"
@import "../lib/MouseState.ck"
@import "../lib/GComponent.ck"
@import "../gmeshes/GRect.ck"
@import "../UIStyle.ck"

public class RadioOption extends GComponent {
    GRect gButton --> this;
    GText gLabel --> this;
    GRect gIndicator --> this;

    string _label;
    int _selected;
    
    new MouseState(this, gButton) @=> _state;

    // ==== Getters and Setters ====
    
    fun string label() { return _label; }
    fun void label(string label) { label => _label; }

    fun int selected() { return _selected; }
    fun void selected(int selected) { selected => _selected; }

    fun int clicked() { return _state.clicked(); }

    // ==== Update ====

    fun void updateUI() {
        UIStyle.color(UIStyle.COL_RADIO_OPTION, @(1, 1, 1, 1)) => vec4 buttonColor;
        UIStyle.color(UIStyle.COL_RADIO_BORDER, @(0.3, 0.3, 0.3, 1)) => vec4 borderColor;
        UIStyle.color(UIStyle.COL_RADIO_LABEL, @(0, 0, 0, 1)) => vec4 labelColor;

        UIUtil.sizeToWorld(UIStyle.varVec2(UIStyle.VAR_RADIO_SIZE, @(0.3, 0.3))) => vec2 buttonSize;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_RADIO_BORDER_RADIUS, 0)) => float borderRadius;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_RADIO_BORDER_WIDTH, 0.1)) => float borderWidth;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_RADIO_LABEL_SPACING, 0.1)) => float labelSpacing;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_RADIO_LABEL_SIZE, 0.20)) => float labelSize;
        UIStyle.varString(UIStyle.VAR_RADIO_FONT, "") => string font;

        UIStyle.varFloat(UIStyle.VAR_RADIO_Z_INDEX, 0) => float zIndex;
        UIStyle.varFloat(UIStyle.VAR_RADIO_ROTATE, 0) => float rotate;

        if (_disabled) {
            UIStyle.color(UIStyle.COL_RADIO_OPTION_DISABLED, @(0.9, 0.9, 0.9, 1)) => buttonColor;
            UIStyle.color(UIStyle.COL_RADIO_BORDER_DISABLED, @(0.7, 0.7, 0.7, 1)) => borderColor;
            UIStyle.color(UIStyle.COL_RADIO_LABEL_DISABLED, @(0.5, 0.5, 0.5, 1)) => labelColor;
        } else if (_state.pressed()) {
            UIStyle.color(UIStyle.COL_RADIO_OPTION_PRESSED, @(buttonColor.x, buttonColor.y, buttonColor.z, buttonColor.a/4)) => buttonColor;
            UIStyle.color(UIStyle.COL_RADIO_BORDER_PRESSED, @(borderColor.x, borderColor.y, borderColor.z, borderColor.a/4)) => borderColor;
            UIStyle.color(UIStyle.COL_RADIO_LABEL_PRESSED, labelColor) => labelColor;
        } else if (_state.hovered()) {
            UIStyle.color(UIStyle.COL_RADIO_OPTION_HOVERED, @(buttonColor.x, buttonColor.y, buttonColor.z, buttonColor.a/2)) => buttonColor;
            UIStyle.color(UIStyle.COL_RADIO_BORDER_HOVERED, @(borderColor.x, borderColor.y, borderColor.z, borderColor.a/2)) => borderColor;
            UIStyle.color(UIStyle.COL_RADIO_LABEL_HOVERED, labelColor) => labelColor;
        }

        gButton.size(buttonSize);
        gButton.color(buttonColor);
        gButton.borderRadius(borderRadius);
        gButton.borderWidth(borderWidth);
        gButton.borderColor(borderColor);

        if (_selected) {
            UIStyle.color(UIStyle.COL_RADIO_SELECTED, @(0.2, 0.2, 0.8, 1)) => vec4 selectedColor;
            @(buttonSize.x * 0.5, buttonSize.y * 0.5) => vec2 indicatorSize;
            gIndicator.size(indicatorSize);
            gIndicator.color(selectedColor);
            gIndicator.borderRadius(borderRadius); // fully circular
            gIndicator.borderWidth(0);
            gIndicator.posZ(0.1);
            if (gIndicator.parent() != this) gIndicator --> this;
        } else {
            if (gIndicator.parent() == this) gIndicator --< this;
        }

        gLabel.text(_label);
        gLabel.font(font);
        gLabel.color(labelColor);
        gLabel.size(labelSize);
        gLabel.controlPoints(@(0, 0.5));
        gLabel.posX(buttonSize.x / 2 + labelSpacing);

        this.posZ(zIndex);
        this.rotZ(rotate);
    }

    fun void update() {
        _state.update();
        updateUI();
    }
}

public class Radio extends GComponent {
    RadioOption _options[0];

    string _optionLabels[];
    int _selectedIndex;

    // ==== Getters and Setters ====

    fun void options(string options[]) {
        if (_optionLabels == null || optionsChanged(options)) {
            options @=> _optionLabels;
            updateOptions();
        }
    }
    fun string[] options() { return _optionLabels; }

    fun int selectedIndex() { return _selectedIndex; }
    fun void selectedIndex(int index) { 
        Math.clampi(index, 0, _optionLabels.size() - 1) => _selectedIndex;
        updateSelection();
    }

    fun int disabled() { return _disabled; }
    fun void disabled(int disabled) { 
        disabled => _disabled;
        for (0 => int i; i < _options.size(); i++) {
            _options[i].disabled(disabled);
        }
    }

    // ==== UIUtility ====

    fun int optionsChanged(string options[]) {
        if (options.size() != _optionLabels.size()) {
            return 1;
        }
        
        for (0 => int i; i < options.size(); i++) {
            if (options[i] != _optionLabels[i]) {
                return 1;
            }
        }
        
        return 0;
    }

    // ==== Update ====

    fun void updateUI() {
        UIStyle.varFloat(UIStyle.VAR_CHECKBOX_Z_INDEX, 0) => float zIndex;
        UIStyle.varFloat(UIStyle.VAR_CHECKBOX_ROTATE, 0) => float rotate;

        UIStyle.varVec2(UIStyle.VAR_RADIO_CONTROL_POINTS, @(0.5, 0.5)) => vec2 controlPoints;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_RADIO_SPACING, 0.4)) => float spacing;
        UIStyle.varString(UIStyle.VAR_RADIO_LAYOUT, "column") => string layout;

        for (0 => int i; i < _options.size(); i++) {
            if (layout == "row") {
                _options[i].posX(i * spacing);
                _options[i].posY(0);
            } else {
                _options[i].posX(0);
                _options[i].posY(-i * spacing);
            }
        }

        applyLayout(@(0, 0), controlPoints, zIndex, rotate);
    }

    fun void updateOptions() {
        for (0 => int i; i < _options.size(); i++) {
            _options[i] --< this;
        }
        _options.size(0);

        _options.size(_optionLabels.size());
        for (0 => int i; i < _optionLabels.size(); i++) {
            new RadioOption @=> _options[i];
            _options[i].label(_optionLabels[i]);
            _options[i].disabled(_disabled);
            _options[i] --> this;
        }

        updateSelection();
    }

    fun void updateSelection() {
        for (0 => int i; i < _options.size(); i++) {
            _options[i].selected(i == _selectedIndex);
        }
    }

    fun void update() {
        if (!_disabled) {
            for (0 => int i; i < _options.size(); i++) {
                _options[i].update();
                
                if (_options[i].clicked()) {
                    i => _selectedIndex;
                    updateSelection();
                }
            }
        }

        updateUI();
    }
}