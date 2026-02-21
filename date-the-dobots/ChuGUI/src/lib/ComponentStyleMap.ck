@import "../UIStyle.ck"

@doc "Maps component types to their style keys for the debug panel."
public class ComponentStyleMap {
    // ==== Rect ====
    static string rectColors[0];
    static string rectFloats[0];
    static string rectVec2s[0];
    static string rectStrings[0];

    // ==== Icon ====
    static string iconColors[0];
    static string iconFloats[0];
    static string iconVec2s[0];
    static string iconStrings[0];

    // ==== Label ====
    static string labelColors[0];
    static string labelFloats[0];
    static string labelVec2s[0];
    static string labelStrings[0];

    // ==== Button ====
    static string buttonColors[0];
    static string buttonFloats[0];
    static string buttonVec2s[0];
    static string buttonStrings[0];

    // ==== Slider ====
    static string sliderColors[0];
    static string sliderFloats[0];
    static string sliderVec2s[0];
    static string sliderStrings[0];

    // ==== Checkbox ====
    static string checkboxColors[0];
    static string checkboxFloats[0];
    static string checkboxVec2s[0];
    static string checkboxStrings[0];

    // ==== Input ====
    static string inputColors[0];
    static string inputFloats[0];
    static string inputVec2s[0];
    static string inputStrings[0];

    // ==== Dropdown ====
    static string dropdownColors[0];
    static string dropdownFloats[0];
    static string dropdownVec2s[0];
    static string dropdownStrings[0];

    // ==== ColorPicker ====
    static string colorPickerColors[0];
    static string colorPickerFloats[0];
    static string colorPickerVec2s[0];
    static string colorPickerStrings[0];

    // ==== Knob ====
    static string knobColors[0];
    static string knobFloats[0];
    static string knobVec2s[0];
    static string knobStrings[0];

    // ==== Meter ====
    static string meterColors[0];
    static string meterFloats[0];
    static string meterVec2s[0];
    static string meterStrings[0];

    // ==== Radio ====
    static string radioColors[0];
    static string radioFloats[0];
    static string radioVec2s[0];
    static string radioStrings[0];

    // ==== Spinner ====
    static string spinnerColors[0];
    static string spinnerFloats[0];
    static string spinnerVec2s[0];
    static string spinnerStrings[0];

    // ==== Initialization ====

    fun static void init() {
        // Rect
        [
            UIStyle.COL_RECT,
            UIStyle.COL_RECT_BORDER
        ] @=> rectColors;
        [
            UIStyle.VAR_RECT_TRANSPARENT,
            UIStyle.VAR_RECT_BORDER_RADIUS,
            UIStyle.VAR_RECT_BORDER_WIDTH,
            UIStyle.VAR_RECT_Z_INDEX,
            UIStyle.VAR_RECT_ROTATE
        ] @=> rectFloats;
        [
            UIStyle.VAR_RECT_SIZE,
            UIStyle.VAR_RECT_CONTROL_POINTS
        ] @=> rectVec2s;
        string empty[0];
        empty @=> rectStrings;

        // Icon
        [
            UIStyle.COL_ICON
        ] @=> iconColors;
        [
            UIStyle.VAR_ICON_TRANSPARENT,
            UIStyle.VAR_ICON_WRAP,
            UIStyle.VAR_ICON_WRAP_U,
            UIStyle.VAR_ICON_WRAP_V,
            UIStyle.VAR_ICON_WRAP_W,
            UIStyle.VAR_ICON_Z_INDEX,
            UIStyle.VAR_ICON_ROTATE
        ] @=> iconFloats;
        [
            UIStyle.VAR_ICON_SIZE,
            UIStyle.VAR_ICON_CONTROL_POINTS
        ] @=> iconVec2s;
        [
            UIStyle.VAR_ICON_SAMPLER
        ] @=> iconStrings;

        // Label
        [
            UIStyle.COL_LABEL
        ] @=> labelColors;
        [
            UIStyle.VAR_LABEL_SIZE,
            UIStyle.VAR_LABEL_ANTIALIAS,
            UIStyle.VAR_LABEL_SPACING,
            UIStyle.VAR_LABEL_CHARACTERS,
            UIStyle.VAR_LABEL_MAX_WIDTH,
            UIStyle.VAR_LABEL_Z_INDEX,
            UIStyle.VAR_LABEL_ROTATE
        ] @=> labelFloats;
        [
            UIStyle.VAR_LABEL_CONTROL_POINTS
        ] @=> labelVec2s;
        [
            UIStyle.VAR_LABEL_FONT,
            UIStyle.VAR_LABEL_ALIGN
        ] @=> labelStrings;

        // Button
        [
            UIStyle.COL_BUTTON,
            UIStyle.COL_BUTTON_HOVERED,
            UIStyle.COL_BUTTON_PRESSED,
            UIStyle.COL_BUTTON_DISABLED,
            UIStyle.COL_BUTTON_TEXT,
            UIStyle.COL_BUTTON_TEXT_HOVERED,
            UIStyle.COL_BUTTON_TEXT_PRESSED,
            UIStyle.COL_BUTTON_TEXT_DISABLED,
            UIStyle.COL_BUTTON_BORDER,
            UIStyle.COL_BUTTON_BORDER_HOVERED,
            UIStyle.COL_BUTTON_BORDER_PRESSED,
            UIStyle.COL_BUTTON_BORDER_DISABLED,
            UIStyle.COL_BUTTON_ICON,
            UIStyle.COL_BUTTON_ICON_HOVERED,
            UIStyle.COL_BUTTON_ICON_PRESSED,
            UIStyle.COL_BUTTON_ICON_DISABLED
        ] @=> buttonColors;
        [
            UIStyle.VAR_BUTTON_TEXT_SIZE,
            UIStyle.VAR_BUTTON_BORDER_RADIUS,
            UIStyle.VAR_BUTTON_BORDER_WIDTH,
            UIStyle.VAR_BUTTON_Z_INDEX,
            UIStyle.VAR_BUTTON_ROTATE,
            UIStyle.VAR_BUTTON_ICON_SIZE
        ] @=> buttonFloats;
        [
            UIStyle.VAR_BUTTON_SIZE,
            UIStyle.VAR_BUTTON_CONTROL_POINTS
        ] @=> buttonVec2s;
        [
            UIStyle.VAR_BUTTON_FONT,
            UIStyle.VAR_BUTTON_ICON_POSITION
        ] @=> buttonStrings;

        // Slider
        [
            UIStyle.COL_SLIDER_TRACK,
            UIStyle.COL_SLIDER_TRACK_HOVERED,
            UIStyle.COL_SLIDER_TRACK_PRESSED,
            UIStyle.COL_SLIDER_TRACK_DISABLED,
            UIStyle.COL_SLIDER_TRACK_BORDER,
            UIStyle.COL_SLIDER_TRACK_BORDER_HOVERED,
            UIStyle.COL_SLIDER_TRACK_BORDER_PRESSED,
            UIStyle.COL_SLIDER_TRACK_BORDER_DISABLED,
            UIStyle.COL_SLIDER_HANDLE,
            UIStyle.COL_SLIDER_HANDLE_HOVERED,
            UIStyle.COL_SLIDER_HANDLE_PRESSED,
            UIStyle.COL_SLIDER_HANDLE_DISABLED,
            UIStyle.COL_SLIDER_HANDLE_BORDER,
            UIStyle.COL_SLIDER_HANDLE_BORDER_HOVERED,
            UIStyle.COL_SLIDER_HANDLE_BORDER_PRESSED,
            UIStyle.COL_SLIDER_HANDLE_BORDER_DISABLED,
            UIStyle.COL_SLIDER_TICK,
            UIStyle.COL_SLIDER_TICK_HOVERED,
            UIStyle.COL_SLIDER_TICK_PRESSED,
            UIStyle.COL_SLIDER_TICK_DISABLED
        ] @=> sliderColors;
        [
            UIStyle.VAR_SLIDER_TRACK_BORDER_RADIUS,
            UIStyle.VAR_SLIDER_TRACK_BORDER_WIDTH,
            UIStyle.VAR_SLIDER_HANDLE_BORDER_RADIUS,
            UIStyle.VAR_SLIDER_HANDLE_BORDER_WIDTH,
            UIStyle.VAR_SLIDER_Z_INDEX,
            UIStyle.VAR_SLIDER_ROTATE
        ] @=> sliderFloats;
        [
            UIStyle.VAR_SLIDER_TRACK_SIZE,
            UIStyle.VAR_SLIDER_HANDLE_SIZE,
            UIStyle.VAR_SLIDER_TICK_SIZE,
            UIStyle.VAR_SLIDER_CONTROL_POINTS
        ] @=> sliderVec2s;
        string sliderEmpty[0];
        sliderEmpty @=> sliderStrings;

        // Checkbox
        [
            UIStyle.COL_CHECKBOX,
            UIStyle.COL_CHECKBOX_HOVERED,
            UIStyle.COL_CHECKBOX_PRESSED,
            UIStyle.COL_CHECKBOX_DISABLED,
            UIStyle.COL_CHECKBOX_BORDER,
            UIStyle.COL_CHECKBOX_BORDER_HOVERED,
            UIStyle.COL_CHECKBOX_BORDER_PRESSED,
            UIStyle.COL_CHECKBOX_BORDER_DISABLED,
            UIStyle.COL_CHECKBOX_ICON
        ] @=> checkboxColors;
        [
            UIStyle.VAR_CHECKBOX_BORDER_RADIUS,
            UIStyle.VAR_CHECKBOX_BORDER_WIDTH,
            UIStyle.VAR_CHECKBOX_ICON_SIZE,
            UIStyle.VAR_CHECKBOX_CHECK_WIDTH,
            UIStyle.VAR_CHECKBOX_Z_INDEX,
            UIStyle.VAR_CHECKBOX_ROTATE
        ] @=> checkboxFloats;
        [
            UIStyle.VAR_CHECKBOX_SIZE,
            UIStyle.VAR_CHECKBOX_CONTROL_POINTS
        ] @=> checkboxVec2s;
        [
            UIStyle.VAR_CHECKBOX_ICON
        ] @=> checkboxStrings;

        // Input
        [
            UIStyle.COL_INPUT,
            UIStyle.COL_INPUT_HOVERED,
            UIStyle.COL_INPUT_FOCUSED,
            UIStyle.COL_INPUT_DISABLED,
            UIStyle.COL_INPUT_TEXT,
            UIStyle.COL_INPUT_TEXT_DISABLED,
            UIStyle.COL_INPUT_BORDER,
            UIStyle.COL_INPUT_BORDER_HOVERED,
            UIStyle.COL_INPUT_BORDER_FOCUSED,
            UIStyle.COL_INPUT_BORDER_DISABLED,
            UIStyle.COL_INPUT_PLACEHOLDER,
            UIStyle.COL_INPUT_CURSOR
        ] @=> inputColors;
        [
            UIStyle.VAR_INPUT_TEXT_SIZE,
            UIStyle.VAR_INPUT_BORDER_RADIUS,
            UIStyle.VAR_INPUT_BORDER_WIDTH,
            UIStyle.VAR_INPUT_Z_INDEX,
            UIStyle.VAR_INPUT_ROTATE
        ] @=> inputFloats;
        [
            UIStyle.VAR_INPUT_SIZE,
            UIStyle.VAR_INPUT_CONTROL_POINTS
        ] @=> inputVec2s;
        [
            UIStyle.VAR_INPUT_FONT
        ] @=> inputStrings;

        // Dropdown
        [
            UIStyle.COL_DROPDOWN,
            UIStyle.COL_DROPDOWN_HOVERED,
            UIStyle.COL_DROPDOWN_OPEN,
            UIStyle.COL_DROPDOWN_DISABLED,
            UIStyle.COL_DROPDOWN_BORDER,
            UIStyle.COL_DROPDOWN_BORDER_HOVERED,
            UIStyle.COL_DROPDOWN_BORDER_OPEN,
            UIStyle.COL_DROPDOWN_BORDER_DISABLED,
            UIStyle.COL_DROPDOWN_TEXT,
            UIStyle.COL_DROPDOWN_TEXT_HOVERED,
            UIStyle.COL_DROPDOWN_TEXT_OPEN,
            UIStyle.COL_DROPDOWN_TEXT_DISABLED,
            UIStyle.COL_DROPDOWN_ARROW,
            UIStyle.COL_DROPDOWN_ITEM,
            UIStyle.COL_DROPDOWN_ITEM_HOVERED,
            UIStyle.COL_DROPDOWN_ITEM_SELECTED,
            UIStyle.COL_DROPDOWN_ITEM_BORDER,
            UIStyle.COL_DROPDOWN_ITEM_BORDER_HOVERED,
            UIStyle.COL_DROPDOWN_ITEM_BORDER_SELECTED,
            UIStyle.COL_DROPDOWN_ITEM_TEXT,
            UIStyle.COL_DROPDOWN_ITEM_TEXT_HOVERED,
            UIStyle.COL_DROPDOWN_ITEM_TEXT_SELECTED
        ] @=> dropdownColors;
        [
            UIStyle.VAR_DROPDOWN_TEXT_SIZE,
            UIStyle.VAR_DROPDOWN_BORDER_RADIUS,
            UIStyle.VAR_DROPDOWN_BORDER_WIDTH,
            UIStyle.VAR_DROPDOWN_Z_INDEX,
            UIStyle.VAR_DROPDOWN_ROTATE
        ] @=> dropdownFloats;
        [
            UIStyle.VAR_DROPDOWN_SIZE,
            UIStyle.VAR_DROPDOWN_CONTROL_POINTS
        ] @=> dropdownVec2s;
        [
            UIStyle.VAR_DROPDOWN_FONT
        ] @=> dropdownStrings;

        // ColorPicker (minimal - uses child components)
        string colorPickerColorsEmpty[0];
        colorPickerColorsEmpty @=> colorPickerColors;
        [
            UIStyle.VAR_COLOR_PICKER_Z_INDEX,
            UIStyle.VAR_COLOR_PICKER_ROTATE
        ] @=> colorPickerFloats;
        [
            UIStyle.VAR_COLOR_PICKER_SIZE,
            UIStyle.VAR_COLOR_PICKER_CONTROL_POINTS
        ] @=> colorPickerVec2s;
        string colorPickerStringsEmpty[0];
        colorPickerStringsEmpty @=> colorPickerStrings;

        // Knob
        [
            UIStyle.COL_KNOB,
            UIStyle.COL_KNOB_HOVERED,
            UIStyle.COL_KNOB_PRESSED,
            UIStyle.COL_KNOB_DISABLED,
            UIStyle.COL_KNOB_BORDER,
            UIStyle.COL_KNOB_BORDER_HOVERED,
            UIStyle.COL_KNOB_BORDER_PRESSED,
            UIStyle.COL_KNOB_BORDER_DISABLED,
            UIStyle.COL_KNOB_INDICATOR,
            UIStyle.COL_KNOB_INDICATOR_HOVERED,
            UIStyle.COL_KNOB_INDICATOR_PRESSED,
            UIStyle.COL_KNOB_INDICATOR_DISABLED
        ] @=> knobColors;
        [
            UIStyle.VAR_KNOB_BORDER_RADIUS,
            UIStyle.VAR_KNOB_BORDER_WIDTH,
            UIStyle.VAR_KNOB_Z_INDEX,
            UIStyle.VAR_KNOB_ROTATE
        ] @=> knobFloats;
        [
            UIStyle.VAR_KNOB_SIZE,
            UIStyle.VAR_KNOB_INDICATOR_SIZE,
            UIStyle.VAR_KNOB_CONTROL_POINTS
        ] @=> knobVec2s;
        string knobStringsEmpty[0];
        knobStringsEmpty @=> knobStrings;

        // Meter
        [
            UIStyle.COL_METER_TRACK,
            UIStyle.COL_METER_FILL,
            UIStyle.COL_METER_TRACK_BORDER
        ] @=> meterColors;
        [
            UIStyle.VAR_METER_BORDER_RADIUS,
            UIStyle.VAR_METER_BORDER_WIDTH,
            UIStyle.VAR_METER_Z_INDEX,
            UIStyle.VAR_METER_ROTATE
        ] @=> meterFloats;
        [
            UIStyle.VAR_METER_SIZE,
            UIStyle.VAR_METER_CONTROL_POINTS
        ] @=> meterVec2s;
        string meterStringsEmpty[0];
        meterStringsEmpty @=> meterStrings;

        // Radio
        [
            UIStyle.COL_RADIO_OPTION,
            UIStyle.COL_RADIO_OPTION_HOVERED,
            UIStyle.COL_RADIO_OPTION_PRESSED,
            UIStyle.COL_RADIO_OPTION_DISABLED,
            UIStyle.COL_RADIO_BORDER,
            UIStyle.COL_RADIO_BORDER_HOVERED,
            UIStyle.COL_RADIO_BORDER_PRESSED,
            UIStyle.COL_RADIO_BORDER_DISABLED,
            UIStyle.COL_RADIO_SELECTED,
            UIStyle.COL_RADIO_LABEL,
            UIStyle.COL_RADIO_LABEL_HOVERED,
            UIStyle.COL_RADIO_LABEL_PRESSED,
            UIStyle.COL_RADIO_LABEL_DISABLED
        ] @=> radioColors;
        [
            UIStyle.VAR_RADIO_SPACING,
            UIStyle.VAR_RADIO_BORDER_RADIUS,
            UIStyle.VAR_RADIO_BORDER_WIDTH,
            UIStyle.VAR_RADIO_LABEL_SPACING,
            UIStyle.VAR_RADIO_LABEL_SIZE,
            UIStyle.VAR_RADIO_Z_INDEX,
            UIStyle.VAR_RADIO_ROTATE
        ] @=> radioFloats;
        [
            UIStyle.VAR_RADIO_SIZE,
            UIStyle.VAR_RADIO_CONTROL_POINTS
        ] @=> radioVec2s;
        [
            UIStyle.VAR_RADIO_LAYOUT,
            UIStyle.VAR_RADIO_FONT
        ] @=> radioStrings;

        // Spinner
        [
            UIStyle.COL_SPINNER,
            UIStyle.COL_SPINNER_TEXT,
            UIStyle.COL_SPINNER_DISABLED,
            UIStyle.COL_SPINNER_TEXT_DISABLED,
            UIStyle.COL_SPINNER_BUTTON,
            UIStyle.COL_SPINNER_BUTTON_DISABLED
        ] @=> spinnerColors;
        [
            UIStyle.VAR_SPINNER_TEXT_SIZE,
            UIStyle.VAR_SPINNER_SPACING,
            UIStyle.VAR_SPINNER_Z_INDEX,
            UIStyle.VAR_SPINNER_ROTATE
        ] @=> spinnerFloats;
        [
            UIStyle.VAR_SPINNER_SIZE,
            UIStyle.VAR_SPINNER_BUTTON_SIZE,
            UIStyle.VAR_SPINNER_CONTROL_POINTS
        ] @=> spinnerVec2s;
        [
            UIStyle.VAR_SPINNER_FONT
        ] @=> spinnerStrings;
    }

    // ==== Getters ====

    fun static string[] getColorKeys(string compType) {
        if (compType == "Rect") return rectColors;
        if (compType == "Icon") return iconColors;
        if (compType == "Label") return labelColors;
        if (compType == "Button" || compType == "MomentaryButton" || compType == "ToggleButton") return buttonColors;
        if (compType == "Slider" || compType == "DiscreteSlider") return sliderColors;
        if (compType == "Checkbox") return checkboxColors;
        if (compType == "Input") return inputColors;
        if (compType == "Dropdown") return dropdownColors;
        if (compType == "ColorPicker") return colorPickerColors;
        if (compType == "Knob") return knobColors;
        if (compType == "Meter") return meterColors;
        if (compType == "Radio") return radioColors;
        if (compType == "Spinner") return spinnerColors;
        string empty[0];
        return empty;
    }

    fun static string[] getFloatKeys(string compType) {
        if (compType == "Rect") return rectFloats;
        if (compType == "Icon") return iconFloats;
        if (compType == "Label") return labelFloats;
        if (compType == "Button" || compType == "MomentaryButton" || compType == "ToggleButton") return buttonFloats;
        if (compType == "Slider" || compType == "DiscreteSlider") return sliderFloats;
        if (compType == "Checkbox") return checkboxFloats;
        if (compType == "Input") return inputFloats;
        if (compType == "Dropdown") return dropdownFloats;
        if (compType == "ColorPicker") return colorPickerFloats;
        if (compType == "Knob") return knobFloats;
        if (compType == "Meter") return meterFloats;
        if (compType == "Radio") return radioFloats;
        if (compType == "Spinner") return spinnerFloats;
        string empty[0];
        return empty;
    }

    fun static string[] getVec2Keys(string compType) {
        if (compType == "Rect") return rectVec2s;
        if (compType == "Icon") return iconVec2s;
        if (compType == "Label") return labelVec2s;
        if (compType == "Button" || compType == "MomentaryButton" || compType == "ToggleButton") return buttonVec2s;
        if (compType == "Slider" || compType == "DiscreteSlider") return sliderVec2s;
        if (compType == "Checkbox") return checkboxVec2s;
        if (compType == "Input") return inputVec2s;
        if (compType == "Dropdown") return dropdownVec2s;
        if (compType == "ColorPicker") return colorPickerVec2s;
        if (compType == "Knob") return knobVec2s;
        if (compType == "Meter") return meterVec2s;
        if (compType == "Radio") return radioVec2s;
        if (compType == "Spinner") return spinnerVec2s;
        string empty[0];
        return empty;
    }

    fun static string[] getStringKeys(string compType) {
        if (compType == "Rect") return rectStrings;
        if (compType == "Icon") return iconStrings;
        if (compType == "Label") return labelStrings;
        if (compType == "Button" || compType == "MomentaryButton" || compType == "ToggleButton") return buttonStrings;
        if (compType == "Slider" || compType == "DiscreteSlider") return sliderStrings;
        if (compType == "Checkbox") return checkboxStrings;
        if (compType == "Input") return inputStrings;
        if (compType == "Dropdown") return dropdownStrings;
        if (compType == "ColorPicker") return colorPickerStrings;
        if (compType == "Knob") return knobStrings;
        if (compType == "Meter") return meterStrings;
        if (compType == "Radio") return radioStrings;
        if (compType == "Spinner") return spinnerStrings;
        string empty[0];
        return empty;
    }
}

// Initialize on load
ComponentStyleMap.init();
