@import "../lib/UIUtil.ck"
@import "../lib/MouseState.ck"
@import "../lib/GComponent.ck"
@import "../UIStyle.ck"
@import "Button.ck"
@import "Label.ck"

public class Spinner extends GComponent {
    MomentaryButton minusButton --> this;
    Label numLabel --> this;
    MomentaryButton plusButton --> this;

    int _min;
    int _num;
    int _max;

    fun Spinner() {
        minusButton.icon(me.dir() + "../assets/icons/minus.png");
        plusButton.icon(me.dir() + "../assets/icons/plus.png");
    }

    // ==== Getters and Setters ====

    fun void disabled(int disabled) {
        disabled => _disabled;
        if(minusButton != null) minusButton.disabled(disabled);
        if(plusButton != null) plusButton.disabled(disabled);
    }

    fun void min(int min) {
        min => _min;
    }
    fun void max(int max) {
        max => _max;
    }

    fun void num(int num) {
        num => _num;
    }
    fun int num() {
        return _num;
    }

    // ==== Update ====

    fun void updateUI() {
        UIStyle.color(UIStyle.COL_SPINNER_TEXT, @(0, 0, 0, 1)) => vec4 textColor;

        UIUtil.sizeToWorld(UIStyle.varVec2(UIStyle.VAR_SPINNER_SIZE, @(3.0, 0.5))) => vec2 size;
        UIUtil.sizeToWorld(UIStyle.varVec2(UIStyle.VAR_SPINNER_BUTTON_SIZE, @(0.25, 0.25))) => vec2 buttonSize;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_SPINNER_TEXT_SIZE, 0.2)) => float textSize;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_SPINNER_SPACING, 0.1)) => float spacing;
        UIStyle.varString(UIStyle.VAR_SPINNER_FONT, "") => string font;

        UIStyle.varVec2(UIStyle.VAR_SPINNER_CONTROL_POINTS, @(0.5, 0.5)) => vec2 controlPoints;
        UIStyle.varFloat(UIStyle.VAR_SPINNER_Z_INDEX, 0.0) => float zIndex;
        UIStyle.varFloat(UIStyle.VAR_SPINNER_ROTATE, 0.0) => float rotate;

        if (_disabled) {
            UIStyle.color(UIStyle.COL_SPINNER_TEXT_DISABLED, textColor) => textColor;
        }

        minusButton.gBtn.size(buttonSize);
        plusButton.gBtn.size(buttonSize);
        numLabel.gLabel.size(textSize);
        numLabel.gLabel.font(font);
        numLabel.gLabel.color(textColor);
        numLabel.gLabel.align(1); // center alignment
        numLabel.gLabel.text(Std.itoa(_num));

        buttonSize.x => float minusWidth;
        buttonSize.x => float plusWidth;
        textSize * Std.itoa(_num).length() $ float => float labelWidth; // estimate for 3-digit numbers

        minusWidth + spacing + labelWidth + spacing + plusWidth => float totalWidth;
        applyLayout(@(totalWidth, size.y), controlPoints, zIndex, rotate);

        -totalWidth * 0.5 => float currentX;
        currentX + minusWidth * 0.5 => minusButton.posX;
        currentX + minusWidth + spacing + labelWidth * 0.5 => numLabel.posX;
        currentX + minusWidth + spacing + labelWidth + spacing + plusWidth * 0.5 => plusButton.posX;
    }

    fun void update() {
        minusButton.update();
        numLabel.update();
        plusButton.update();

        if (minusButton.clicked()) {
            1 -=> _num;
        }
        if (plusButton.clicked()) {
            1 +=> _num;
        }

        Math.clampi(_num, _min, _max) => _num;

        updateUI();
    }
}
