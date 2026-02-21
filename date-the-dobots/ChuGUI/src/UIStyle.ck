@doc "ChuGUI's styling system."
public class UIStyle {
    // ==== Enums ====

    "NEAREST" => static string NEAREST;
    "LINEAR" => static string LINEAR;

    "LEFT" => static string LEFT;
    "RIGHT" => static string RIGHT;
    "CENTER" => static string CENTER;

    // ==== Color Keys ====

    // Rect
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "rect"                        => static string COL_RECT;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "rect.border"                 => static string COL_RECT_BORDER;

    // Icon
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "icon"                        => static string COL_ICON;

    // Label
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "label"                        => static string COL_LABEL;

    // Button
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "button"                      => static string COL_BUTTON;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "button.hovered"              => static string COL_BUTTON_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "button.pressed"              => static string COL_BUTTON_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "button.disabled"             => static string COL_BUTTON_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "button.text"                 => static string COL_BUTTON_TEXT;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "button.text.hovered"         => static string COL_BUTTON_TEXT_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "button.text.pressed"         => static string COL_BUTTON_TEXT_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "button.text.disabled"        => static string COL_BUTTON_TEXT_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "button.border"               => static string COL_BUTTON_BORDER;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "button.border.hovered"       => static string COL_BUTTON_BORDER_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "button.border.pressed"       => static string COL_BUTTON_BORDER_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "button.border.disabled"      => static string COL_BUTTON_BORDER_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "button.icon"                 => static string COL_BUTTON_ICON;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "button.icon.hovered"         => static string COL_BUTTON_ICON_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "button.icon.pressed"         => static string COL_BUTTON_ICON_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "button.icon.disabled"        => static string COL_BUTTON_ICON_DISABLED;

    // Slider
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "slider.track"                  => static string COL_SLIDER_TRACK;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "slider.track.hovered"          => static string COL_SLIDER_TRACK_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "slider.track.pressed"          => static string COL_SLIDER_TRACK_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "slider.track.disabled"         => static string COL_SLIDER_TRACK_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "slider.track.border"           => static string COL_SLIDER_TRACK_BORDER;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "slider.track.border.hovered"   => static string COL_SLIDER_TRACK_BORDER_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "slider.track.border.pressed"   => static string COL_SLIDER_TRACK_BORDER_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "slider.track.border.disabled"  => static string COL_SLIDER_TRACK_BORDER_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "slider.handle"                 => static string COL_SLIDER_HANDLE;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "slider.handle.hovered"         => static string COL_SLIDER_HANDLE_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "slider.handle.pressed"         => static string COL_SLIDER_HANDLE_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "slider.handle.disabled"        => static string COL_SLIDER_HANDLE_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "slider.handle.border"          => static string COL_SLIDER_HANDLE_BORDER;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "slider.handle.border.hovered"  => static string COL_SLIDER_HANDLE_BORDER_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "slider.handle.border.pressed"  => static string COL_SLIDER_HANDLE_BORDER_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "slider.handle.border.disabled" => static string COL_SLIDER_HANDLE_BORDER_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "slider.tick"                   => static string COL_SLIDER_TICK;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "slider.tick.hovered"           => static string COL_SLIDER_TICK_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "slider.tick.pressed"           => static string COL_SLIDER_TICK_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "slider.tick.disabled"          => static string COL_SLIDER_TICK_DISABLED;

    // Checkbox
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "checkbox"                    => static string COL_CHECKBOX;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "checkbox.hovered"            => static string COL_CHECKBOX_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "checkbox.pressed"            => static string COL_CHECKBOX_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "checkbox.disabled"           => static string COL_CHECKBOX_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "checkbox.border"             => static string COL_CHECKBOX_BORDER;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "checkbox.border.hovered"     => static string COL_CHECKBOX_BORDER_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "checkbox.border.pressed"     => static string COL_CHECKBOX_BORDER_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "checkbox.border.disabled"    => static string COL_CHECKBOX_BORDER_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "checkbox.icon"               => static string COL_CHECKBOX_ICON;

    // Input
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "input"                       => static string COL_INPUT;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "input.hovered"               => static string COL_INPUT_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "input.focused"               => static string COL_INPUT_FOCUSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "input.disabled"              => static string COL_INPUT_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "input.text"                  => static string COL_INPUT_TEXT;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "input.text.disabled"         => static string COL_INPUT_TEXT_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "input.border"                => static string COL_INPUT_BORDER;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "input.border.hovered"        => static string COL_INPUT_BORDER_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "input.border.focused"        => static string COL_INPUT_BORDER_FOCUSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "input.border.disabled"       => static string COL_INPUT_BORDER_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "input.placeholder"           => static string COL_INPUT_PLACEHOLDER;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "input.cursor"                => static string COL_INPUT_CURSOR;

    // Dropdown
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "dropdown"                      => static string COL_DROPDOWN;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "dropdown.hovered"              => static string COL_DROPDOWN_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "dropdown.open"                 => static string COL_DROPDOWN_OPEN;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "dropdown.disabled"             => static string COL_DROPDOWN_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "dropdown.border"               => static string COL_DROPDOWN_BORDER;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "dropdown.border.hovered"       => static string COL_DROPDOWN_BORDER_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "dropdown.border.open"          => static string COL_DROPDOWN_BORDER_OPEN;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "dropdown.border.disabled"      => static string COL_DROPDOWN_BORDER_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "dropdown.text"                 => static string COL_DROPDOWN_TEXT;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "dropdown.text.hovered"         => static string COL_DROPDOWN_TEXT_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "dropdown.text.open"            => static string COL_DROPDOWN_TEXT_OPEN;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "dropdown.text.disabled"        => static string COL_DROPDOWN_TEXT_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "dropdown.arrow"                => static string COL_DROPDOWN_ARROW;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "dropdown.item"                 => static string COL_DROPDOWN_ITEM;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "dropdown.item.hovered"         => static string COL_DROPDOWN_ITEM_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "dropdown.item.selected"        => static string COL_DROPDOWN_ITEM_SELECTED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "dropdown.item.border"          => static string COL_DROPDOWN_ITEM_BORDER;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "dropdown.item.border.hovered"  => static string COL_DROPDOWN_ITEM_BORDER_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "dropdown.item.border.selected" => static string COL_DROPDOWN_ITEM_BORDER_SELECTED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "dropdown.item.text"            => static string COL_DROPDOWN_ITEM_TEXT;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "dropdown.item.text.hovered"    => static string COL_DROPDOWN_ITEM_TEXT_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "dropdown.item.text.selected"   => static string COL_DROPDOWN_ITEM_TEXT_SELECTED;

    // Knob
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "knob"                        => static string COL_KNOB;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "knob.hovered"                => static string COL_KNOB_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "knob.pressed"                => static string COL_KNOB_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "knob.disabled"               => static string COL_KNOB_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "knob.border"                 => static string COL_KNOB_BORDER;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "knob.border.hovered"         => static string COL_KNOB_BORDER_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "knob.border.pressed"         => static string COL_KNOB_BORDER_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "knob.border.disabled"        => static string COL_KNOB_BORDER_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "knob.indicator"              => static string COL_KNOB_INDICATOR;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "knob.indicator.hovered"      => static string COL_KNOB_INDICATOR_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "knob.indicator.pressed"      => static string COL_KNOB_INDICATOR_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "knob.indicator.disabled"     => static string COL_KNOB_INDICATOR_DISABLED;

    // Meter
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "meter.track"                 => static string COL_METER_TRACK;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "meter.fill"                  => static string COL_METER_FILL;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "meter.track.border"          => static string COL_METER_TRACK_BORDER;

    // Radio
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "radio.option"                => static string COL_RADIO_OPTION;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "radio.option.hovered"        => static string COL_RADIO_OPTION_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "radio.option.pressed"        => static string COL_RADIO_OPTION_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "radio.option.disabled"       => static string COL_RADIO_OPTION_DISABLED;

    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "radio.border"                => static string COL_RADIO_BORDER;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "radio.border.hovered"        => static string COL_RADIO_BORDER_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "radio.border.pressed"        => static string COL_RADIO_BORDER_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "radio.border.disabled"       => static string COL_RADIO_BORDER_DISABLED;

    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "radio.selected"              => static string COL_RADIO_SELECTED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "radio.label"                 => static string COL_RADIO_LABEL;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "radio.label.hovered"         => static string COL_RADIO_LABEL_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "radio.label.pressed"         => static string COL_RADIO_LABEL_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "radio.label.disabled"        => static string COL_RADIO_LABEL_DISABLED;

    // Spinner
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "spinner"                     => static string COL_SPINNER;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "spinner.text"                => static string COL_SPINNER_TEXT;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "spinner.disabled"            => static string COL_SPINNER_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "spinner.text.disabled"       => static string COL_SPINNER_TEXT_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "spinner.button"              => static string COL_SPINNER_BUTTON;
    @doc "Apply with pushColor(), using a vec3 or vec4 value."
    "spinner.button.disabled"     => static string COL_SPINNER_BUTTON_DISABLED;

    // ==== Var Keys ====

    // Rect
    @doc "Apply with pushVar(), using an int value."
    "rect.transparent"            => static string VAR_RECT_TRANSPARENT;
    @doc "Apply with pushVar(), using a vec2 value."
    "rect.control_points"         => static string VAR_RECT_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a vec2 value."
    "rect.size"                   => static string VAR_RECT_SIZE;
    @doc "Apply with pushVar(), using a float value."
    "rect.border_radius"          => static string VAR_RECT_BORDER_RADIUS;
    @doc "Apply with pushVar(), using a float value."
    "rect.border_width"           => static string VAR_RECT_BORDER_WIDTH;
    @doc "Apply with pushVar(), using a float value."
    "rect.z_index"                => static string VAR_RECT_Z_INDEX;
    @doc "Apply with pushVar(), using a float value."
    "rect.rotate"                 => static string VAR_RECT_ROTATE;

    // Icon
    @doc "Apply with pushVar(), using an int value."
    "icon.transparent"            => static string VAR_ICON_TRANSPARENT;
    @doc "Apply with pushVar(), using UIStyle.NEAREST or UIStyle.LINEAR."
    "icon.sampler"                => static string VAR_ICON_SAMPLER;
    @doc "Apply with pushVar(), using TextureSampler.Wrap_Repeat, TextureSampler.Wrap_Mirror, or TextureSampler.Wrap_Clamp."
    "icon.wrap"                 => static string VAR_ICON_WRAP;
    @doc "Apply with pushVar(), using TextureSampler.Wrap_Repeat, TextureSampler.Wrap_Mirror, or TextureSampler.Wrap_Clamp."
    "icon.wrap_u"                 => static string VAR_ICON_WRAP_U;
    @doc "Apply with pushVar(), using TextureSampler.Wrap_Repeat, TextureSampler.Wrap_Mirror, or TextureSampler.Wrap_Clamp."
    "icon.wrap_v"                 => static string VAR_ICON_WRAP_V;
    @doc "Apply with pushVar(), using TextureSampler.Wrap_Repeat, TextureSampler.Wrap_Mirror, or TextureSampler.Wrap_Clamp."
    "icon.wrap_w"                 => static string VAR_ICON_WRAP_W;
    @doc "Apply with pushVar(), using a vec2 value."
    "icon.control_points"         => static string VAR_ICON_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a vec2 value."
    "icon.size"                   => static string VAR_ICON_SIZE;
    @doc "Apply with pushVar(), using a float value."
    "icon.z_index"                => static string VAR_ICON_Z_INDEX;
    @doc "Apply with pushVar(), using a float value."
    "icon.rotate"                 => static string VAR_ICON_ROTATE;

    // Label
    @doc "Apply with pushVar(), using a vec2 value."
    "label.control_points"        => static string VAR_LABEL_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a float value."
    "label.size"                  => static string VAR_LABEL_SIZE;
    @doc "Apply with pushVar(), using a string value."
    "label.font"                  => static string VAR_LABEL_FONT;
    @doc "Apply with pushVar(), using a float value."
    "label.antialias"             => static string VAR_LABEL_ANTIALIAS;
    @doc "Apply with pushVar(), using a float value."
    "label.spacing"               => static string VAR_LABEL_SPACING;
    @doc "Apply with pushVar(), using UIStyle.LEFT, UIStyle.CENTER, or UIStyle.RIGHT."
    "label.align"                 => static string VAR_LABEL_ALIGN;
    @doc "Apply with pushVar(), using a int value."
    "label.characters"            => static string VAR_LABEL_CHARACTERS;
    @doc "Apply with pushVar(), using a float value. Default 0.0, meaning no text wrap."
    "label.max_width"             => static string VAR_LABEL_MAX_WIDTH;
    @doc "Apply with pushVar(), using a float value."
    "label.z_index"               => static string VAR_LABEL_Z_INDEX;
    @doc "Apply with pushVar(), using a float value."
    "label.rotate"                => static string VAR_LABEL_ROTATE;

    // Button
    @doc "Apply with pushVar(), using a vec2 value."
    "button.control_points"       => static string VAR_BUTTON_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a vec2 value."
    "button.size"                 => static string VAR_BUTTON_SIZE;
    @doc "Apply with pushVar(), using a float value."
    "button.text_size"            => static string VAR_BUTTON_TEXT_SIZE;
    @doc "Apply with pushVar(), using a float value."
    "button.border_radius"        => static string VAR_BUTTON_BORDER_RADIUS;
    @doc "Apply with pushVar(), using a float value."
    "button.border_width"         => static string VAR_BUTTON_BORDER_WIDTH;
    @doc "Apply with pushVar(), using a string value."
    "button.font"                 => static string VAR_BUTTON_FONT;
    @doc "Apply with pushVar(), using a float value."
    "button.rotate"               => static string VAR_BUTTON_ROTATE;
    @doc "Apply with pushVar(), using a float value."
    "button.z_index"              => static string VAR_BUTTON_Z_INDEX;
    @doc "Apply with pushVar(), using a float value."
    "button.icon_size"            => static string VAR_BUTTON_ICON_SIZE;
    @doc "Apply with pushVar(), using UIStyle.LEFT or UIStyle.RIGHT."
    "button.icon_position"        => static string VAR_BUTTON_ICON_POSITION;

    // Slider
    @doc "Apply with pushVar(), using a vec2 value."
    "slider.control_points"       => static string VAR_SLIDER_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a vec2 value."
    "slider.track_size"           => static string VAR_SLIDER_TRACK_SIZE;
    @doc "Apply with pushVar(), using a float value."
    "slider.track_border_radius"  => static string VAR_SLIDER_TRACK_BORDER_RADIUS;
    @doc "Apply with pushVar(), using a float value."
    "slider.track_border_width"   => static string VAR_SLIDER_TRACK_BORDER_WIDTH;
    @doc "Apply with pushVar(), using a vec2 value."
    "slider.handle_size"          => static string VAR_SLIDER_HANDLE_SIZE;
    @doc "Apply with pushVar(), using a float value."
    "slider.handle_border_radius" => static string VAR_SLIDER_HANDLE_BORDER_RADIUS;
    @doc "Apply with pushVar(), using a float value."
    "slider.handle_border_width"  => static string VAR_SLIDER_HANDLE_BORDER_WIDTH;
    @doc "Apply with pushVar(), using a vec2 value."
    "slider.tick_size"            => static string VAR_SLIDER_TICK_SIZE;
    @doc "Apply with pushVar(), using a float value."
    "slider.rotate"               => static string VAR_SLIDER_ROTATE;
    @doc "Apply with pushVar(), using a float value."
    "slider.z_index"              => static string VAR_SLIDER_Z_INDEX;

    // Checkbox
    @doc "Apply with pushVar(), using a vec2 value."
    "checkbox.control_points"     => static string VAR_CHECKBOX_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a vec2 value."
    "checkbox.size"               => static string VAR_CHECKBOX_SIZE;
    @doc "Apply with pushVar(), using a float value."
    "checkbox.border_radius"      => static string VAR_CHECKBOX_BORDER_RADIUS;
    @doc "Apply with pushVar(), using a float value."
    "checkbox.border_width"       => static string VAR_CHECKBOX_BORDER_WIDTH;
    @doc "Apply with pushVar(), using a string value that denotes the image path."
    "checkbox.icon"               => static string VAR_CHECKBOX_ICON;
    @doc "Apply with pushVar(), using a float value."
    "checkbox.icon_size"          => static string VAR_CHECKBOX_ICON_SIZE;
    @doc "Apply with pushVar(), using a float value."
    "checkbox.check_width"        => static string VAR_CHECKBOX_CHECK_WIDTH;
    @doc "Apply with pushVar(), using a float value."
    "checkbox.z_index"            => static string VAR_CHECKBOX_Z_INDEX;
    @doc "Apply with pushVar(), using a float value."
    "checkbox.rotate"             => static string VAR_CHECKBOX_ROTATE;

    // Input
    @doc "Apply with pushVar(), using a vec2 value."
    "input.control_points"        => static string VAR_INPUT_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a vec2 value."
    "input.size"                  => static string VAR_INPUT_SIZE;
    @doc "Apply with pushVar(), using a float value."
    "input.text_size"             => static string VAR_INPUT_TEXT_SIZE;
    @doc "Apply with pushVar(), using a float value."
    "input.border_radius"         => static string VAR_INPUT_BORDER_RADIUS;
    @doc "Apply with pushVar(), using a float value."
    "input.border_width"          => static string VAR_INPUT_BORDER_WIDTH;
    @doc "Apply with pushVar(), using a string value."
    "input.font"                  => static string VAR_INPUT_FONT;
    @doc "Apply with pushVar(), using a float value."
    "input.z_index"               => static string VAR_INPUT_Z_INDEX;
    @doc "Apply with pushVar(), using a float value."
    "input.rotate"                => static string VAR_INPUT_ROTATE;

    // Dropdown
    @doc "Apply with pushVar(), using a vec2 value."
    "dropdown.control_points"     => static string VAR_DROPDOWN_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a vec2 value."
    "dropdown.size"               => static string VAR_DROPDOWN_SIZE;
    @doc "Apply with pushVar(), using a float value."
    "dropdown.text_size"          => static string VAR_DROPDOWN_TEXT_SIZE;
    @doc "Apply with pushVar(), using a float value."
    "dropdown.border_radius"      => static string VAR_DROPDOWN_BORDER_RADIUS;
    @doc "Apply with pushVar(), using a float value."
    "dropdown.border_width"       => static string VAR_DROPDOWN_BORDER_WIDTH;
    @doc "Apply with pushVar(), using a string value."
    "dropdown.font"               => static string VAR_DROPDOWN_FONT;
    @doc "Apply with pushVar(), using a float value."
    "dropdown.z_index"            => static string VAR_DROPDOWN_Z_INDEX;
    @doc "Apply with pushVar(), using a float value."
    "dropdown.rotate"             => static string VAR_DROPDOWN_ROTATE;

    // Color Picker
    @doc "Apply with pushVar(), using a vec2 value."
    "color_picker.control_points" => static string VAR_COLOR_PICKER_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a vec2 value."
    "color_picker.size"           => static string VAR_COLOR_PICKER_SIZE;
    @doc "Apply with pushVar(), using a float value."
    "color_picker.z_index"        => static string VAR_COLOR_PICKER_Z_INDEX;
    @doc "Apply with pushVar(), using a float value."
    "color_picker.rotate"         => static string VAR_COLOR_PICKER_ROTATE;

    // Knob
    @doc "Apply with pushVar(), using a vec2 value."
    "knob.control_points"         => static string VAR_KNOB_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a vec2 value."
    "knob.size"                   => static string VAR_KNOB_SIZE;
    @doc "Apply with pushVar(), using a float value."
    "knob.border_radius"          => static string VAR_KNOB_BORDER_RADIUS;
    @doc "Apply with pushVar(), using a float value."
    "knob.border_width"           => static string VAR_KNOB_BORDER_WIDTH;
    @doc "Apply with pushVar(), using a vec2 value."
    "knob.indicator_size"         => static string VAR_KNOB_INDICATOR_SIZE;
    @doc "Apply with pushVar(), using a float value."
    "knob.z_index"                => static string VAR_KNOB_Z_INDEX;
    @doc "Apply with pushVar(), using a float value."
    "knob.rotate"                 => static string VAR_KNOB_ROTATE;

    // Meter
    @doc "Apply with pushVar(), using a vec2 value."
    "meter.control_points"        => static string VAR_METER_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a vec2 value."
    "meter.size"                  => static string VAR_METER_SIZE;
    @doc "Apply with pushVar(), using a float value."
    "meter.border_radius"         => static string VAR_METER_BORDER_RADIUS;
    @doc "Apply with pushVar(), using a float value."
    "meter.border_width"          => static string VAR_METER_BORDER_WIDTH;
    @doc "Apply with pushVar(), using a float value."
    "meter.z_index"               => static string VAR_METER_Z_INDEX;
    @doc "Apply with pushVar(), using a float value."
    "meter.rotate"                => static string VAR_METER_ROTATE;

    // Radio
    @doc "Apply with pushVar(), using a vec2 value."
    "radio.control_points"        => static string VAR_RADIO_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a float value."
    "radio.spacing"               => static string VAR_RADIO_SPACING;
    @doc "Apply with pushVar(), using a vec2 value."
    "radio.size"                  => static string VAR_RADIO_SIZE;
    @doc "Apply with pushVar(), using a string value of 'column' or 'row'."
    "radio.layout"                => static string VAR_RADIO_LAYOUT;
    @doc "Apply with pushVar(), using a float value."
    "radio.border_radius"         => static string VAR_RADIO_BORDER_RADIUS;
    @doc "Apply with pushVar(), using a float value."
    "radio.border_width"          => static string VAR_RADIO_BORDER_WIDTH;
    @doc "Apply with pushVar(), using a float value."
    "radio.label_spacing"         => static string VAR_RADIO_LABEL_SPACING;
    @doc "Apply with pushVar(), using a float value."
    "radio.label_size"            => static string VAR_RADIO_LABEL_SIZE;
    @doc "Apply with pushVar(), using a string value."
    "radio.font"                  => static string VAR_RADIO_FONT;
    @doc "Apply with pushVar(), using a float value."
    "radio.z_index"               => static string VAR_RADIO_Z_INDEX;
    @doc "Apply with pushVar(), using a float value."
    "radio.rotate"                => static string VAR_RADIO_ROTATE;

    // Spinner
    @doc "Apply with pushVar(), using a vec2 value."
    "spinner.control_points"      => static string VAR_SPINNER_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a vec2 value."
    "spinner.size"                => static string VAR_SPINNER_SIZE;
    @doc "Apply with pushVar(), using a vec2 value."
    "spinner.button_size"        => static string VAR_SPINNER_BUTTON_SIZE;
    @doc "Apply with pushVar(), using a float value."
    "spinner.text_size"           => static string VAR_SPINNER_TEXT_SIZE;
    @doc "Apply with pushVar(), using a float value."
    "spinner.spacing"             => static string VAR_SPINNER_SPACING;
    @doc "Apply with pushVar(), using a string value."
    "spinner.font"                  => static string VAR_SPINNER_FONT;
    @doc "Apply with pushVar(), using a float value."
    "spinner.z_index"             => static string VAR_SPINNER_Z_INDEX;
    @doc "Apply with pushVar(), using a float value."
    "spinner.rotate"              => static string VAR_SPINNER_ROTATE;

    // ==== Internal Stacks and Value Arrays ====

    @doc "(hidden)"
    static vec4        colorStacks[0][0];
    @doc "(hidden)"
    static string      colorOrder[0];

    @doc "(hidden)"
    static float       floatStacks[0][0];
    @doc "(hidden)"
    static vec2        vec2Stacks[0][0];
    @doc "(hidden)"
    static string      stringStacks[0][0];
    @doc "(hidden)"
    static string      varOrder[0];

    @doc "(hidden)"
    fun static void clearStacks() {
        // clear color stacks
        colorOrder.clear();
        string colorKeys[0];
        colorStacks.getKeys(colorKeys);
        for (string k : colorKeys) {
            colorStacks[k].clear();
        }
        // clear var stacks
        varOrder.clear();
        string varKeys[0];
        floatStacks.getKeys(varKeys);
        for (string k : varKeys) floatStacks[k].clear();
        vec2Stacks.getKeys(varKeys);
        for (string k : varKeys) vec2Stacks[k].clear();
        stringStacks.getKeys(varKeys);
        for (string k : varKeys) stringStacks[k].clear();
    }

    // ==== Color API ====

    @doc "Push a temporary override for a color style key onto the stack. Must be popped by calling popColor()."
    fun static void pushColor(string key, vec3 v) {
        pushColor(key, @(v.x, v.y, v.z, 1.0));
    }
    @doc "Push a temporary override for a color style key onto the stack. Must be popped by calling popColor()."
    fun static void pushColor(string key, vec4 v) {
        if (!colorStacks.isInMap(key)) { vec4 s[0] @=> colorStacks[key]; }
        colorStacks[key] << v;
        colorOrder << key;
    }
    @doc "Pop the last color style override. Must be preceded by a pushColor() call."
    fun static void popColor() {
        if (colorOrder.size() == 0) return;
        colorOrder[colorOrder.size() - 1] => string key;
        colorOrder.popBack();
        if (colorStacks.isInMap(key) && colorStacks[key].size() > 0) colorStacks[key].popBack();
    }
    @doc "Pop the last 'count' color style overrides. Must be preceded by 'count' pushStyleColor() calls."
    fun static void popColor(int count) {
        for (0 => int i; i < count; i++) {
            popColor();
        }
    }

    @doc "Get the color value for a color style key, returning a fallback value if not set."
    fun static vec4 color(string key, vec3 fallback) { return color(key, @(fallback.x, fallback.y, fallback.z, 1.0)); }
    @doc "Get the color value for a color style key, returning a fallback value if not set."
    fun static vec4 color(string key, vec4 fallback) {
        if (colorStacks.isInMap(key) && colorStacks[key].size() > 0)
            return colorStacks[key][colorStacks[key].size() - 1];
        return fallback;
    }

    // ==== Var API ====

    @doc "Push a temporary override for a variable style key onto the stack. Must be popped by calling popVar()."
    fun static void pushVar(string key, float v) {
        if (!floatStacks.isInMap(key)) { float s[0] @=> floatStacks[key]; }
        floatStacks[key] << v;
        varOrder << key;
    }
    @doc "Push a temporary override for a variable style key onto the stack. Must be popped by calling popVar()."
    fun static void pushVar(string key, vec2 v) {
        if (!vec2Stacks.isInMap(key)) { vec2 s[0] @=> vec2Stacks[key]; }
        vec2Stacks[key] << v;
        varOrder << key;
    }
    @doc "Push a temporary override for a variable style key onto the stack. Must be popped by calling popVar()."
    fun static void pushVar(string key, string v) {
        if (!stringStacks.isInMap(key)) { string s[0] @=> stringStacks[key]; }
        stringStacks[key] << v;
        varOrder << key;
    }

    @doc "Pop the last variable style override. Must be preceded by a pushVar() call."
    fun static void popVar() {
        if (varOrder.size() == 0) return;
        varOrder[varOrder.size() - 1] => string key;
        varOrder.popBack();
        if (floatStacks.isInMap(key) && floatStacks[key].size() > 0) floatStacks[key].popBack();
        else if (vec2Stacks.isInMap(key) && vec2Stacks[key].size() > 0) vec2Stacks[key].popBack();
        else if (stringStacks.isInMap(key) && stringStacks[key].size() > 0) stringStacks[key].popBack();
    }
    @doc "Pop the last 'count' variable style overrides. Must be preceded by 'count' pushVar() calls."
    fun static void popVar(int count) {
        for (0 => int i; i < count; i++) {
            popVar();
        }
    }

    @doc "Get the value for a variable style key, returning a fallback value if not set."
    fun static float varFloat(string key, float fallback) {
        if (floatStacks.isInMap(key) && floatStacks[key].size() > 0)
            return floatStacks[key][floatStacks[key].size() - 1];
        return fallback;
    }
    @doc "Get the value for a variable style key, returning a fallback value if not set."
    fun static vec2 varVec2(string key, vec2 fallback) {
        if (vec2Stacks.isInMap(key) && vec2Stacks[key].size() > 0)
            return vec2Stacks[key][vec2Stacks[key].size() - 1];
        return fallback;
    }
    @doc "Get the value for a variable style key, returning a fallback value if not set."
    fun static string varString(string key, string fallback) {
        if (stringStacks.isInMap(key) && stringStacks[key].size() > 0)
            return stringStacks[key][stringStacks[key].size() - 1];
        return fallback;
    }
}