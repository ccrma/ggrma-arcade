@import "lib/UIGlobals.ck"
@import "lib/GComponent.ck"
@import "lib/MouseState.ck"
@import "lib/UIUtil.ck"
@import "lib/ComponentStyleMap.ck"
@import "lib/DebugStyles.ck"
@import "UIStyle.ck"
@import "components/Rect.ck"
@import "components/Icon.ck"
@import "components/Label.ck"
@import "components/Button.ck"
@import "components/Slider.ck"
@import "components/Checkbox.ck"
@import "components/Input.ck"
@import "components/Dropdown.ck"
@import "components/ColorPicker.ck"
@import "components/Knob.ck"
@import "components/Meter.ck"
@import "components/Radio.ck"
@import "components/Spinner.ck"

@doc "ChuGUI is a flexible immediate-mode 2D GUI toolkit for ChuGL."
public class ChuGUI extends GGen {
    @doc "(hidden)"
    "0.1.3" => static string version;

    @doc "(hidden)"
    GComponent @ lastComponent;

    // ==== Pools ====

    @doc "(hidden)"
    Rect  rectPool[0];
    @doc "(hidden)"
    int rectCount;

    @doc "(hidden)"
    Icon  iconPool[0];
    @doc "(hidden)"
    int iconCount;

    @doc "(hidden)"
    Label labelPool[0];
    @doc "(hidden)"
    int labelCount;
    
    @doc "(hidden)"
    Meter meterPool[0];
    @doc "(hidden)"
    int meterCount;

    // ==== Maps ====
    
    @doc "(hidden)"
    MomentaryButton buttons[0];
    @doc "(hidden)"
    ToggleButton toggleBtns[0];

    @doc "(hidden)"
    Slider sliders[0];
    @doc "(hidden)"
    DiscreteSlider discreteSliders[0];

    @doc "(hidden)"
    Checkbox checkboxes[0];

    @doc "(hidden)"
    Input inputs[0];

    @doc "(hidden)"
    Dropdown dropdowns[0];

    @doc "(hidden)"
    ColorPicker colorPickers[0];

    @doc "(hidden)"
    Knob knobs[0];
    
    @doc "(hidden)"
    Radio radios[0];

    @doc "(hidden)"
    Spinner spinners[0];

    // ==== Debug State ====

    @doc "(hidden)"
    int _debugEnabled;
    @doc "(hidden)"
    string _debugComponents[0];
    @doc "(hidden)"
    GComponent @ _debugComponentRefs[0];
    @doc "(hidden)"
    string _debugComponentTypes[0];
    @doc "(hidden)"
    string _lastComponentType;
    @doc "(hidden)"
    string _lastComponentId;
    @doc "(hidden)"
    int _debugAddCallCount;  // Tracks position in render order per frame

    // ImGUI wrappers (reused across frames to avoid allocation)
    // Uses flat maps with compound keys: "compId/styleKey"
    @doc "(hidden)"
    UI_Float4 _colorWrappers[0];
    @doc "(hidden)"
    UI_Float _floatWrappers[0];
    @doc "(hidden)"
    UI_Float2 _vec2Wrappers[0];

    // ==== Frame Management ====

    @doc "(hidden)"
    int currentFrame;

    @doc "(hidden)"
    fun void resetFrame(GComponent components[]) {
        string keys[0];
        components.getKeys(keys);
        for (string k : keys) {
            components[k] @=> GComponent c;
            if (c != null) {
                c.frame(-1);
            }
        }
    }

    @doc "(hidden)"
    fun void cleanupPool(GComponent components[], int count) {
        for (count => int i; i < components.size(); i++) {
            components[i] @=> GComponent c;
            if (c == null || c.parent() == null) continue;
            c --< this;
        }
    }

    @doc "(hidden)"
    fun void cleanupMap(GComponent components[]) {
        string keys[0];
        components.getKeys(keys);
        for (string k : keys) {
            components[k] @=> GComponent c;
            if (c == null || c.parent() == null || c.frame() != -1) continue;
            c --< this;
        }
    }
    
    @doc "(hidden)"
    fun void update(float dt) {
        currentFrame++;
        
        GG.fps() $ int => int fps;
        (fps != 0) ? fps : 60 %=> currentFrame;

        null => lastComponent;

        UIStyle.clearStacks();
        CursorState.clearStates();

        cleanupPool(rectPool, rectCount);
        cleanupPool(iconPool, iconCount);
        cleanupPool(labelPool, labelCount);
        cleanupPool(meterPool, meterCount);

        0 => rectCount;
        0 => iconCount;
        0 => labelCount;
        0 => meterCount;

        cleanupMap(buttons);
        cleanupMap(toggleBtns);
        cleanupMap(sliders);
        cleanupMap(discreteSliders);
        cleanupMap(checkboxes);
        cleanupMap(inputs);
        cleanupMap(dropdowns);
        cleanupMap(colorPickers);
        cleanupMap(knobs);
        cleanupMap(radios);
        cleanupMap(spinners);

        resetFrame(buttons);
        resetFrame(toggleBtns);
        resetFrame(sliders);
        resetFrame(discreteSliders);
        resetFrame(checkboxes);
        resetFrame(inputs);
        resetFrame(dropdowns);
        resetFrame(colorPickers);
        resetFrame(knobs);
        resetFrame(radios);
        resetFrame(spinners);

        idStack.clear();
    }

    // ==== ID ====

    @doc "(hidden)"
    string idStack[0];

    @doc "Push an ID onto the ID stack. Must be popped by calling popID()."
    fun void pushID(string id) {
        idStack << id;
    }
    @doc "Pop the last ID from the ID stack. Must be preceded by a pushID() call."
    fun void popID() {
        if (idStack.size()) {
            idStack.popBack();
        }
    }
    @doc "(hidden)"
    fun string getID() {
        string id;
        for (int i; i < idStack.size(); i++) {
            idStack[i] + "/" +=> id;
        }
        return id;
    }

    // ==== Globals ====

    @doc "Set the unit system for both positions and sizes of components. Either ChuGUI.NDC or ChuGUI.WORLD."
    fun void units(string unit) {
        unit => UIGlobals.sizeUnits;
        unit => UIGlobals.posUnits;
    }

    @doc "Set the unit system for the size of components. Either ChuGUI.NDC or ChuGUI.WORLD."
    fun void sizeUnits(string unit) {
        unit => UIGlobals.sizeUnits;
    }

    @doc "Set the unit system for the position of components. Either ChuGUI.NDC or ChuGUI.WORLD."
    fun void posUnits(string unit) {
        unit => UIGlobals.posUnits;
    }

    // ==== UIUtil Functions ====

    @doc "Convert NDC size to world size."
    fun static vec2 NDCToWorldSize(vec2 ndcSize) {
        return UIUtil.NDCToWorldSize(ndcSize);
    }

    @doc "Convert world size to NDC size."
    fun static vec2 worldToNDCSize(vec2 worldSize) {
        return UIUtil.worldToNDCSize(worldSize);
    }

    @doc "Returns whether the last component rendered is hovered or not."
    fun int hovered() {
        return lastComponent._state.hovered();
    }

    // ==== Debug Panel ====

    @doc "Enable or disable the debug panel."
    fun void debugEnabled(int enabled) {
        enabled => _debugEnabled;
        if (enabled) {
            // Ensure style map is initialized
            ComponentStyleMap.init();
        }
    }

    @doc "Returns whether the debug panel is enabled."
    fun int debugEnabled() {
        return _debugEnabled;
    }

    @doc "Add the last rendered component to the debug panel with an auto-generated ID."
    fun void debugAdd() {
        debugAdd("");
    }

    @doc "Add the last rendered component to the debug panel with a custom ID."
    fun void debugAdd(string customId) {
        if (lastComponent == null) return;

        // Use internal component ID for overrides, custom ID for display
        // For pooled components, _lastComponentId will be empty
        _lastComponentId => string internalId;

        // For mapped components (with internal ID), use that ID
        // For pooled components, use type-specific counter (the count was already incremented)
        "" => string overrideId;
        if (internalId != "") {
            internalId => overrideId;
        } else {
            // Use type-specific counter for pooled components
            // The counter was already incremented after rendering, so subtract 1
            if (_lastComponentType == "Rect") {
                _lastComponentType + "_" + (rectCount - 1) => overrideId;
            } else if (_lastComponentType == "Icon") {
                _lastComponentType + "_" + (iconCount - 1) => overrideId;
            } else if (_lastComponentType == "Label") {
                _lastComponentType + "_" + (labelCount - 1) => overrideId;
            } else if (_lastComponentType == "Meter") {
                _lastComponentType + "_" + (meterCount - 1) => overrideId;
            } else {
                // Fallback for any other pooled types
                _lastComponentType + "_" + _debugAddCallCount => overrideId;
                _debugAddCallCount++;
            }
        }

        // Check if already added (by override ID)
        for (string existingId : _debugComponents) {
            if (existingId == overrideId) return;
        }

        // Add to tracking arrays
        // Note: Create copies of strings to avoid reference issues
        "" + overrideId => string idCopy;
        "" + _lastComponentType => string typeCopy;

        _debugComponents << idCopy;
        _debugComponentRefs << lastComponent;
        _debugComponentTypes << typeCopy;

        // Initialize debug styles for this component
        DebugStyles.initComponent(idCopy, typeCopy);
    }

    @doc "Check if a component is being debugged."
    fun int isDebugging(string compId) {
        for (string id : _debugComponents) {
            if (id == compId) return true;
        }
        return false;
    }

    @doc "Render the debug panel. Call this each frame when debug mode is enabled."
    fun void debug() {
        if (!_debugEnabled) return;

        // Reset debugAdd call counter for next frame
        0 => _debugAddCallCount;

        if (_debugComponents.size() == 0) return;

        UI.begin("ChuGUI Debug Panel");

        for (0 => int i; i < _debugComponents.size(); i++) {
            _debugComponents[i] => string compId;
            _debugComponentTypes[i] => string compType;

            if (UI.treeNode(compType + ": " + compId)) {
                // Reset button
                if (UI.button("Reset All")) {
                    DebugStyles.clearComponent(compId);
                    DebugStyles.initComponent(compId, compType);
                }

                UI.separator();

                // Colors section
                ComponentStyleMap.getColorKeys(compType) @=> string colorKeys[];
                if (colorKeys.size() > 0 && UI.treeNode("Colors")) {
                    renderColorEditors(compId, colorKeys);
                    UI.treePop();
                }

                // Float variables section
                ComponentStyleMap.getFloatKeys(compType) @=> string floatKeys[];
                if (floatKeys.size() > 0 && UI.treeNode("Size & Layout")) {
                    renderFloatEditors(compId, floatKeys);
                    UI.treePop();
                }

                // Vec2 variables section
                ComponentStyleMap.getVec2Keys(compType) @=> string vec2Keys[];
                if (vec2Keys.size() > 0 && UI.treeNode("Dimensions")) {
                    renderVec2Editors(compId, vec2Keys);
                    UI.treePop();
                }

                // String variables section
                ComponentStyleMap.getStringKeys(compType) @=> string stringKeys[];
                if (stringKeys.size() > 0 && UI.treeNode("Options")) {
                    renderStringEditors(compId, stringKeys);
                    UI.treePop();
                }

                UI.treePop();
            }
        }

        UI.end();
    }

    @doc "(hidden)"
    fun void renderColorEditors(string compId, string keys[]) {
        for (string key : keys) {
            // Compound key for flat map
            compId + "/" + key => string wrapperKey;

            // Get or create wrapper
            if (!_colorWrappers.isInMap(wrapperKey)) {
                new UI_Float4 @=> _colorWrappers[wrapperKey];
            }
            _colorWrappers[wrapperKey] @=> UI_Float4 wrapper;

            // Load current value into wrapper
            DebugStyles.getColor(compId, key) => vec4 col;
            wrapper.val(col);

            // Checkbox to enable override
            UI_Bool enabled;
            DebugStyles.isColorEnabled(compId, key) => enabled.val;
            UI.checkbox("##en_" + key, enabled);
            UI.sameLine();

            // Color editor
            if (UI.colorEdit(key, wrapper, UI_ColorEditFlags.AlphaBar)) {
                DebugStyles.setColor(compId, key, wrapper.val());
                DebugStyles.setColorEnabled(compId, key, 1);
                1 => enabled.val;  // Also update checkbox state
            }

            // Store checkbox state (may have been toggled by user)
            enabled.val() => int enabledInt;
            DebugStyles.setColorEnabled(compId, key, enabledInt);
        }
    }

    @doc "(hidden)"
    fun void renderFloatEditors(string compId, string keys[]) {
        for (string key : keys) {
            // Compound key for flat map
            compId + "/" + key => string wrapperKey;

            // Get or create wrapper
            if (!_floatWrappers.isInMap(wrapperKey)) {
                new UI_Float @=> _floatWrappers[wrapperKey];
            }
            _floatWrappers[wrapperKey] @=> UI_Float wrapper;

            // Load current value
            DebugStyles.getFloat(compId, key) => wrapper.val;

            // Checkbox to enable override
            UI_Bool enabled;
            DebugStyles.isFloatEnabled(compId, key) => enabled.val;
            UI.checkbox("##en_" + key, enabled);
            UI.sameLine();

            // Use drag for unbounded values, slider for bounded
            0 => int changed;
            if (key.find("transparent") >= 0 || key.find("antialias") >= 0 ||
                key.find("border_radius") >= 0 || key.find("border_width") >= 0 ||
                key.find("check_width") >= 0) {
                // Bounded 0-1
                UI.slider(key, wrapper, 0.0, 1.0) => changed;
            } else if (key.find("wrap") >= 0) {
                // Wrap mode 0-2
                UI.slider(key, wrapper, 0.0, 2.0) => changed;
            } else if (key.find("rotate") >= 0) {
                // Rotation -360 to 360
                UI.slider(key, wrapper, -360.0, 360.0) => changed;
            } else {
                // Unbounded - use drag (z_index, size, spacing, characters, max_width, etc.)
                UI.drag(key, wrapper) => changed;
            }

            if (changed) {
                DebugStyles.setFloat(compId, key, wrapper.val());
                DebugStyles.setFloatEnabled(compId, key, true);
                true => enabled.val;
            }

            // Store checkbox state
            DebugStyles.setFloatEnabled(compId, key, enabled.val());
        }
    }

    @doc "(hidden)"
    fun void renderVec2Editors(string compId, string keys[]) {
        for (string key : keys) {
            // Compound key for flat map
            compId + "/" + key => string wrapperKey;

            // Get or create wrapper
            if (!_vec2Wrappers.isInMap(wrapperKey)) {
                new UI_Float2 @=> _vec2Wrappers[wrapperKey];
            }
            _vec2Wrappers[wrapperKey] @=> UI_Float2 wrapper;

            // Load current value
            DebugStyles.getVec2(compId, key) => vec2 val;
            wrapper.val(val);

            // Checkbox to enable override
            UI_Bool enabled;
            DebugStyles.isVec2Enabled(compId, key) => enabled.val;
            UI.checkbox("##en_" + key, enabled);
            UI.sameLine();

            // Drag input for vec2
            if (UI.drag(key, wrapper)) {
                wrapper.val() => vec2 newVal;

                // Clamp control points to 0-1
                if (key.find("control_points") >= 0) {
                    Math.max(0.0, Math.min(1.0, newVal.x)) => newVal.x;
                    Math.max(0.0, Math.min(1.0, newVal.y)) => newVal.y;
                }
                // Clamp sizes to non-negative values
                else if (key.find("size") >= 0) {
                    Math.max(0.0, newVal.x) => newVal.x;
                    Math.max(0.0, newVal.y) => newVal.y;
                }

                DebugStyles.setVec2(compId, key, newVal);
                DebugStyles.setVec2Enabled(compId, key, true);
                true => enabled.val;
            }

            // Store checkbox state
            DebugStyles.setVec2Enabled(compId, key, enabled.val());
        }
    }

    @doc "(hidden)"
    fun void renderStringEditors(string compId, string keys[]) {
        for (string key : keys) {
            DebugStyles.getString(compId, key) => string val;

            // Checkbox to enable override
            UI_Bool enabled;
            DebugStyles.isStringEnabled(compId, key) => enabled.val;
            UI.checkbox("##en_" + key, enabled);
            UI.sameLine();

            // For align/position options, use a combo
            if (key.find("align") >= 0 || key.find("position") >= 0) {
                ["LEFT", "CENTER", "RIGHT"] @=> string options[];
                0 => int currentIdx;
                if (val == "CENTER") 1 => currentIdx;
                else if (val == "RIGHT") 2 => currentIdx;

                UI_Int selectedIdx;
                currentIdx => selectedIdx.val;
                if (UI.combo(key, selectedIdx, options)) {
                    DebugStyles.setString(compId, key, options[selectedIdx.val()]);
                    DebugStyles.setStringEnabled(compId, key, true);
                    true => enabled.val;
                }
            } else if (key.find("layout") >= 0) {
                ["column", "row"] @=> string options[];
                0 => int currentIdx;
                if (val == "row") 1 => currentIdx;

                UI_Int selectedIdx;
                currentIdx => selectedIdx.val;
                if (UI.combo(key, selectedIdx, options)) {
                    DebugStyles.setString(compId, key, options[selectedIdx.val()]);
                    DebugStyles.setStringEnabled(compId, key, true);
                    true => enabled.val;
                }
            } else if (key.find("sampler") >= 0) {
                ["NEAREST", "LINEAR"] @=> string options[];
                0 => int currentIdx;
                if (val == "LINEAR") 1 => currentIdx;

                UI_Int selectedIdx;
                currentIdx => selectedIdx.val;
                if (UI.combo(key, selectedIdx, options)) {
                    DebugStyles.setString(compId, key, options[selectedIdx.val()]);
                    DebugStyles.setStringEnabled(compId, key, true);
                    true => enabled.val;
                }
            } else {
                // Generic text input
                UI_String wrapper;
                val => wrapper.val;
                if (UI.inputText(key, wrapper)) {
                    DebugStyles.setString(compId, key, wrapper.val());
                    DebugStyles.setStringEnabled(compId, key, true);
                    true => enabled.val;
                }
            }

            // Store checkbox state (may have been toggled by user)
            DebugStyles.setStringEnabled(compId, key, enabled.val());
        }
    }

    // ==== Pooled Components (Stateless) ====
    
    // Rect
    @doc "Render a GRect at the given position in NDC coordinates."
    fun void rect(vec2 pos) {
        if (rectCount == rectPool.size()) rectPool << new Rect();
        rectPool[rectCount] @=> Rect rect;

        rect.pos(pos);

        if (rect.parent() == null) {
            rect --> this;
        }

        // Calculate debug ID for this rect (before incrementing count)
        "Rect_" + rectCount => string debugId;

        // Apply debug overrides if component is being debugged
        if (_debugEnabled && isDebugging(debugId)) {
            DebugStyles.applyOverrides(debugId);
        }

        rect.frame(currentFrame);
        rect.update();

        // Pop debug overrides
        if (_debugEnabled && isDebugging(debugId)) {
            UIStyle.popColor(DebugStyles.countColorOverrides(debugId));
            UIStyle.popVar(DebugStyles.countVarOverrides(debugId));
        }

        rect @=> lastComponent;
        "Rect" => _lastComponentType;
        "" => _lastComponentId;
        rectCount++;
    }

    // Icon
    @doc "Render a GIcon with the given image path at the given position in NDC coordinates."
    fun void icon(string iconPath, vec2 pos) {
        if (iconCount == iconPool.size()) iconPool << new Icon();
        iconPool[iconCount] @=> Icon icon;
        icon.icon(iconPath);

        icon.pos(pos);

        if (icon.parent() == null) {
            icon --> this;
        }

        // Calculate debug ID for this icon (before incrementing count)
        "Icon_" + iconCount => string debugId;

        // Apply debug overrides if component is being debugged
        if (_debugEnabled && isDebugging(debugId)) {
            DebugStyles.applyOverrides(debugId);
        }

        icon.frame(currentFrame);
        icon.update();

        // Pop debug overrides
        if (_debugEnabled && isDebugging(debugId)) {
            UIStyle.popColor(DebugStyles.countColorOverrides(debugId));
            UIStyle.popVar(DebugStyles.countVarOverrides(debugId));
        }

        icon @=> lastComponent;
        "Icon" => _lastComponentType;
        "" => _lastComponentId;
        iconCount++;
    }

    // Label
    @doc "Render a label at the given position in NDC coordinates."
    fun void label(string text, vec2 pos) {
        if (labelCount == labelPool.size()) labelPool << new Label();
        labelPool[labelCount] @=> Label label;
        label.label(text);

        label.pos(pos);

        if (label.parent() == null) {
            label --> this;
        }

        // Calculate debug ID for this label (before incrementing count)
        "Label_" + labelCount => string debugId;

        // Apply debug overrides if component is being debugged
        if (_debugEnabled && isDebugging(debugId)) {
            DebugStyles.applyOverrides(debugId);
        }

        label.frame(currentFrame);
        label.update();

        // Pop debug overrides
        if (_debugEnabled && isDebugging(debugId)) {
            UIStyle.popColor(DebugStyles.countColorOverrides(debugId));
            UIStyle.popVar(DebugStyles.countVarOverrides(debugId));
        }

        label @=> lastComponent;
        "Label" => _lastComponentType;
        "" => _lastComponentId;
        labelCount++;
    }

    // Meter
    @doc "Render a meter at the given position in NDC coordinates."
    fun void meter(vec2 pos, float min, float max, float val) {
        if (meterCount == meterPool.size()) meterPool << new Meter();
        meterPool[meterCount] @=> Meter meter;
        meter.min(min);
        meter.max(max);
        meter.val(val);

        meter.pos(pos);

        if (meter.parent() == null) {
            meter --> this;
        }

        // Calculate debug ID for this meter (before incrementing count)
        "Meter_" + meterCount => string debugId;

        // Apply debug overrides if component is being debugged
        if (_debugEnabled && isDebugging(debugId)) {
            DebugStyles.applyOverrides(debugId);
        }

        meter.frame(currentFrame);
        meter.update();

        // Pop debug overrides
        if (_debugEnabled && isDebugging(debugId)) {
            UIStyle.popColor(DebugStyles.countColorOverrides(debugId));
            UIStyle.popVar(DebugStyles.countVarOverrides(debugId));
        }

        meter @=> lastComponent;
        "Meter" => _lastComponentType;
        "" => _lastComponentId;
        meterCount++;
    }

    // ==== Mapped Components (Stateful, Interactive) ====

    // Buttons
    @doc "Render a button with given label at the given position in NDC coordinates; returns 1 if the button is clicked during the current frame."
    fun int button(string label, vec2 pos) { return button(label, "", pos, false); }
    @doc "Render a button with given label at the given position in NDC coordinates; returns 1 if the button is clicked during the current frame."
    fun int button(string label, vec2 pos, int disabled) { return button(label, "", pos, disabled); }
    @doc "Render a button with given label and icon at the given position in NDC coordinates; returns 1 if the button is clicked during the current frame."
    fun int button(string label, string icon, vec2 pos) { return button(label, icon, pos, false); }
    @doc "Render a button with given label and icon at the given position in NDC coordinates; returns 1 if the button is clicked during the current frame."
    fun int button(string label, string icon, vec2 pos, int disabled) {
        label != "" ? label : icon => string key;
        getID() != "" ? getID() : key => string id;
        if (!buttons.isInMap(id)) {
            new MomentaryButton() @=> buttons[id];
        }
        buttons[id] @=> MomentaryButton b;
        b.label(label);
        b.icon(icon);
        b.disabled(disabled);

        b.pos(pos);

        if (b.parent() == null) {
            b --> this;
        }

        // Apply debug overrides if component is being debugged
        if (_debugEnabled && isDebugging(id)) {
            DebugStyles.applyOverrides(id);
        }

        b.frame(currentFrame);
        b.update();

        // Pop debug overrides
        if (_debugEnabled && isDebugging(id)) {
            UIStyle.popColor(DebugStyles.countColorOverrides(id));
            UIStyle.popVar(DebugStyles.countVarOverrides(id));
        }

        b @=> lastComponent;
        "Button" => _lastComponentType;
        id => _lastComponentId;
        return b.clicked();
    }

    @doc "Render a toggle button at the given position in NDC coordinates; returns 1 if the button is toggled during the current frame."
    fun int toggleButton(string label, vec2 pos, int toggled) { return toggleButton(label, "", pos, toggled, false); }
    @doc "Render a toggle button at the given position in NDC coordinates; returns 1 if the button is toggled during the current frame."
    fun int toggleButton(string label, vec2 pos, int toggled, int disabled) { return toggleButton(label, "", pos, toggled, disabled); }
    @doc "Render a toggle button at the given position in NDC coordinates; returns 1 if the button is toggled during the current frame."
    fun int toggleButton(string label, string icon, vec2 pos, int toggled) { return toggleButton(label, icon, pos, toggled, false); }
    @doc "Render a toggle button at the given position in NDC coordinates; returns 1 if the button is toggled during the current frame."
    fun int toggleButton(string label, string icon, vec2 pos, int toggled, int disabled) {
        label != "" ? label : icon => string key;
        getID() != "" ? getID() : key => string id;
        if (!toggleBtns.isInMap(id)) {
            new ToggleButton() @=> toggleBtns[id];
        }
        toggleBtns[id] @=> ToggleButton b;
        b.label(label);
        b.icon(icon);
        b.disabled(disabled);
        b.toggled(toggled);

        b.pos(pos);

        if (b.parent() == null) {
            b --> this;
        }

        // Apply debug overrides if component is being debugged
        if (_debugEnabled && isDebugging(id)) {
            DebugStyles.applyOverrides(id);
        }

        b.frame(currentFrame);
        b.update();

        // Pop debug overrides
        if (_debugEnabled && isDebugging(id)) {
            UIStyle.popColor(DebugStyles.countColorOverrides(id));
            UIStyle.popVar(DebugStyles.countVarOverrides(id));
        }

        b @=> lastComponent;
        "Button" => _lastComponentType;
        id => _lastComponentId;
        return b.toggled();
    }

    // Sliders
    @doc "Render a slider at the given position in NDC coordinates; returns the value at the current frame."
    fun float slider(string id, vec2 pos, float min, float max, float val) { return slider(id, pos, min, max, val, false); }
    @doc "Render a slider at the given position in NDC coordinates; returns the value at the current frame."
    fun float slider(string id, vec2 pos, float min, float max, float val, int disabled) {
        getID() != "" ? getID() : id => string _id;
        if (!sliders.isInMap(_id)) {
            new Slider() @=> sliders[_id];
        }
        sliders[_id] @=> Slider slider;
        slider.min(min);
        slider.max(max);
        slider.val(val);
        slider.disabled(disabled);

        slider.pos(pos);

        if (slider.parent() == null) {
            slider --> this;
        }

        // Apply debug overrides
        if (_debugEnabled && isDebugging(_id)) {
            DebugStyles.applyOverrides(_id);
        }

        slider.frame(currentFrame);
        slider.update();

        // Pop debug overrides
        if (_debugEnabled && isDebugging(_id)) {
            UIStyle.popColor(DebugStyles.countColorOverrides(_id));
            UIStyle.popVar(DebugStyles.countVarOverrides(_id));
        }

        slider @=> lastComponent;
        "Slider" => _lastComponentType;
        _id => _lastComponentId;
        return slider.val();
    }

    @doc "Render a discrete slider at the given position in NDC coordinates; returns the value at the current frame."
    fun float discreteSlider(string id, vec2 pos, float min, float max, int steps, float val) { return discreteSlider(id, pos, min, max, steps, val, false); }
    @doc "Render a discrete slider at the given position in NDC coordinates; returns the value at the current frame."
    fun float discreteSlider(string id, vec2 pos, float min, float max, int steps, float val, int disabled) {
        getID() != "" ? getID() : id => string _id;
        if (!discreteSliders.isInMap(_id)) {
            new DiscreteSlider() @=> discreteSliders[_id];
        }
        discreteSliders[_id] @=> DiscreteSlider slider;
        slider.min(min);
        slider.max(max);
        slider.val(val);
        slider.steps(steps);
        slider.disabled(disabled);

        slider.pos(pos);

        if (slider.parent() == null) {
            slider --> this;
        }

        // Apply debug overrides
        if (_debugEnabled && isDebugging(_id)) {
            DebugStyles.applyOverrides(_id);
        }

        slider.frame(currentFrame);
        slider.update();

        // Pop debug overrides
        if (_debugEnabled && isDebugging(_id)) {
            UIStyle.popColor(DebugStyles.countColorOverrides(_id));
            UIStyle.popVar(DebugStyles.countVarOverrides(_id));
        }

        slider @=> lastComponent;
        "Slider" => _lastComponentType;
        _id => _lastComponentId;
        return slider.val();
    }

    // Checkbox
    @doc "Render a checkbox at the given position in NDC coordinates; returns 1 if the checkbox is checked during the current frame."
    fun int checkbox(string id, vec2 pos, int checked) { return checkbox(id, pos, checked, false); }
    @doc "Render a checkbox at the given position in NDC coordinates; returns 1 if the checkbox is checked during the current frame."
    fun int checkbox(string id, vec2 pos, int checked, int disabled) {
        getID() != "" ? getID() : id => string _id;
        if (!checkboxes.isInMap(_id)) {
            new Checkbox() @=> checkboxes[_id];
        }
        checkboxes[_id] @=> Checkbox checkbox;
        checkbox.disabled(disabled);
        checkbox.checked(checked);

        checkbox.pos(pos);

        if (checkbox.parent() == null) {
            checkbox --> this;
        }

        // Apply debug overrides
        if (_debugEnabled && isDebugging(_id)) {
            DebugStyles.applyOverrides(_id);
        }

        checkbox.frame(currentFrame);
        checkbox.update();

        // Pop debug overrides
        if (_debugEnabled && isDebugging(_id)) {
            UIStyle.popColor(DebugStyles.countColorOverrides(_id));
            UIStyle.popVar(DebugStyles.countVarOverrides(_id));
        }

        checkbox @=> lastComponent;
        "Checkbox" => _lastComponentType;
        _id => _lastComponentId;
        return checkbox.checked();
    }

    // Input
    @doc "Render an input field at the given position in NDC coordinates; returns the input at the current frame."
    fun string input(string label, vec2 pos, string value) { return input(label, pos, value, "", false); }
    @doc "Render an input field at the given position in NDC coordinates; returns the input at the current frame."
    fun string input(string label, vec2 pos, string value, string placeholder) { return input(label, pos, value, placeholder, false); }
    @doc "Render an input field at the given position in NDC coordinates; returns the input at the current frame."
    fun string input(string label, vec2 pos, string value, string placeholder, int disabled) {
        getID() != "" ? getID() : label => string _id;
        if (!inputs.isInMap(_id)) {
            new Input() @=> inputs[_id];
        }
        inputs[_id] @=> Input input;
        input.value(value);
        input.placeholder(placeholder);
        input.disabled(disabled);

        input.pos(pos);

        if (input.parent() == null) {
            input --> this;
        }

        // Apply debug overrides
        if (_debugEnabled && isDebugging(_id)) {
            DebugStyles.applyOverrides(_id);
        }

        input.frame(currentFrame);
        input.update();

        // Pop debug overrides
        if (_debugEnabled && isDebugging(_id)) {
            UIStyle.popColor(DebugStyles.countColorOverrides(_id));
            UIStyle.popVar(DebugStyles.countVarOverrides(_id));
        }

        input @=> lastComponent;
        "Input" => _lastComponentType;
        _id => _lastComponentId;
        return input.value();
    }

    // Dropdown
    @doc "Render a dropdown at the given position in NDC coordinates; returns the selected option at the current frame."
    fun int dropdown(string label, vec2 pos, string options[], int selectedIndex) { return dropdown(label, pos, options, selectedIndex, false); }
    @doc "Render a dropdown at the given position in NDC coordinates; returns the selected option at the current frame."
    fun int dropdown(string label, vec2 pos, string options[], int selectedIndex, int disabled) {
        getID() != "" ? getID() : label => string _id;
        if (!dropdowns.isInMap(_id)) {
            new Dropdown() @=> dropdowns[_id];
        }
        dropdowns[_id] @=> Dropdown dropdown;
        dropdown.placeholder(label);
        dropdown.options(options);
        dropdown.disabled(disabled);
        dropdown.selectedIndex(selectedIndex);

        dropdown.pos(pos);

        if (dropdown.parent() == null) {
            dropdown --> this;
        }

        // Apply debug overrides
        if (_debugEnabled && isDebugging(_id)) {
            DebugStyles.applyOverrides(_id);
        }

        dropdown.frame(currentFrame);
        dropdown.update();

        // Pop debug overrides
        if (_debugEnabled && isDebugging(_id)) {
            UIStyle.popColor(DebugStyles.countColorOverrides(_id));
            UIStyle.popVar(DebugStyles.countVarOverrides(_id));
        }

        dropdown @=> lastComponent;
        "Dropdown" => _lastComponentType;
        _id => _lastComponentId;
        return dropdown.selectedIndex();
    }

    // Color Picker
    @doc "Render a color picker at the given position in NDC coordinates; returns the selected color at the current frame."
    fun vec3 colorPicker(string id, vec2 pos, vec3 color) { return colorPicker(id, pos, color, false); }
    @doc "Render a color picker at the given position in NDC coordinates; returns the selected color at the current frame."
    fun vec3 colorPicker(string id, vec2 pos, vec3 color, int disabled) {
        getID() != "" ? getID() : id => string _id;
        if (!colorPickers.isInMap(_id)) {
            new ColorPicker() @=> colorPickers[_id];
        }
        colorPickers[_id] @=> ColorPicker colorPicker;
        colorPicker.color(color);
        colorPicker.disabled(disabled);

        colorPicker.pos(pos);

        if (colorPicker.parent() == null) {
            colorPicker --> this;
        }

        // Apply debug overrides
        if (_debugEnabled && isDebugging(_id)) {
            DebugStyles.applyOverrides(_id);
        }

        colorPicker.frame(currentFrame);
        colorPicker.update();

        // Pop debug overrides
        if (_debugEnabled && isDebugging(_id)) {
            UIStyle.popColor(DebugStyles.countColorOverrides(_id));
            UIStyle.popVar(DebugStyles.countVarOverrides(_id));
        }

        colorPicker @=> lastComponent;
        "ColorPicker" => _lastComponentType;
        _id => _lastComponentId;
        return colorPicker.color();
    }

    // Knob
    @doc "Render a knob at the given position in NDC coordinates; returns the value at the current frame."
    fun float knob(string id, vec2 pos, float min, float max, float val) { return knob(id, pos, min, max, val, false); }
    @doc "Render a knob at the given position in NDC coordinates; returns the value at the current frame."
    fun float knob(string id, vec2 pos, float min, float max, float val, int disabled) {
        getID() != "" ? getID() : id => string _id;
        if (!knobs.isInMap(_id)) {
            new Knob() @=> knobs[_id];
        }
        knobs[_id] @=> Knob knob;
        knob.min(min);
        knob.max(max);
        knob.val(val);
        knob.disabled(disabled);

        knob.pos(pos);

        if (knob.parent() == null) {
            knob --> this;
        }

        // Apply debug overrides
        if (_debugEnabled && isDebugging(_id)) {
            DebugStyles.applyOverrides(_id);
        }

        knob.frame(currentFrame);
        knob.update();

        // Pop debug overrides
        if (_debugEnabled && isDebugging(_id)) {
            UIStyle.popColor(DebugStyles.countColorOverrides(_id));
            UIStyle.popVar(DebugStyles.countVarOverrides(_id));
        }

        knob @=> lastComponent;
        "Knob" => _lastComponentType;
        _id => _lastComponentId;
        return knob.val();
    }

    // Radio
    @doc "Render a radio group at the given position in NDC coordinates; returns the selected option at the current frame."
    fun int radio(string groupId, vec2 pos, string options[], int selectedIndex) { return radio(groupId, pos, options, selectedIndex, false); }
    @doc "Render a radio group at the given position in NDC coordinates; returns the selected option at the current frame."
    fun int radio(string groupId, vec2 pos, string options[], int selectedIndex, int disabled) {
        getID() != "" ? getID() : groupId => string _id;
        if (!radios.isInMap(_id)) {
            new Radio() @=> radios[_id];
        }
        radios[_id] @=> Radio radio;
        radio.options(options);
        radio.selectedIndex(selectedIndex);
        radio.disabled(disabled);

        radio.pos(pos);

        if (radio.parent() == null) {
            radio --> this;
        }

        // Apply debug overrides
        if (_debugEnabled && isDebugging(_id)) {
            DebugStyles.applyOverrides(_id);
        }

        radio.frame(currentFrame);
        radio.update();

        // Pop debug overrides
        if (_debugEnabled && isDebugging(_id)) {
            UIStyle.popColor(DebugStyles.countColorOverrides(_id));
            UIStyle.popVar(DebugStyles.countVarOverrides(_id));
        }

        radio @=> lastComponent;
        "Radio" => _lastComponentType;
        _id => _lastComponentId;
        return radio.selectedIndex();
    }

    // Spinner
    @doc "Render a spinner at the given position in NDC coordinates; returns the value at the current frame."
    fun int spinner(string id, vec2 pos, int min, int max, int num) { return spinner(id, pos, min, max, num, false); }
    @doc "Render a spinner at the given position in NDC coordinates; returns the value at the current frame."
    fun int spinner(string id, vec2 pos, int min, int max, int num, int disabled) {
        getID() != "" ? getID() : id => string _id;
        if (!spinners.isInMap(_id)) {
            new Spinner() @=> spinners[_id];
        }
        spinners[_id] @=> Spinner spinner;
        spinner.min(min);
        spinner.num(num);
        spinner.max(max);
        spinner.disabled(disabled);

        spinner.pos(pos);

        if (spinner.parent() == null) {
            spinner --> this;
        }

        // Apply debug overrides
        if (_debugEnabled && isDebugging(_id)) {
            DebugStyles.applyOverrides(_id);
        }

        spinner.frame(currentFrame);
        spinner.update();

        // Pop debug overrides
        if (_debugEnabled && isDebugging(_id)) {
            UIStyle.popColor(DebugStyles.countColorOverrides(_id));
            UIStyle.popVar(DebugStyles.countVarOverrides(_id));
        }

        spinner @=> lastComponent;
        "Spinner" => _lastComponentType;
        _id => _lastComponentId;
        return spinner.num();
    }

    // Enums
    "NDC" => static string NDC;
    "WORLD" => static string WORLD;

    // ==== Provided Icons ====

    @doc "(hidden)"
    me.dir() + "assets/icons/" => string iconDir;

    static string ARROW_RIGHT;
    iconDir + "arrow-right.png" => ARROW_RIGHT;
    static string ARROW_LEFT;
    iconDir + "arrow-left.png" => ARROW_LEFT;
    static string ARROW_DOWN;
    iconDir + "arrow-down.png" => ARROW_DOWN;
    static string ARROW_UP;
    iconDir + "arrow-up.png" => ARROW_UP;
    static string X;
    iconDir + "x.png" => X;
    static string PLUS;
    iconDir + "plus.png" => PLUS;
    static string MINUS;
    iconDir + "minus.png" => MINUS;
    static string USER;
    iconDir + "user.png" => USER;
    static string GEAR;
    iconDir + "gear.png" => GEAR;
    static string CHECK;
    iconDir + "check.png" => CHECK;
    static string SEARCH;
    iconDir + "magnifying-glass.png" => SEARCH;
}