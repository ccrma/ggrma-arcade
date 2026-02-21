@import "../UIStyle.ck"
@import "ComponentStyleMap.ck"

@doc "Persistent storage for debug style overrides using flat maps with compound keys."
public class DebugStyles {
    // ==== Override Storage ====
    // Maps use compound keys: "compId/styleKey" => value

    static vec4 colorOverrides[0];
    static float floatOverrides[0];
    static vec2 vec2Overrides[0];
    static string stringOverrides[0];

    // Track which overrides are enabled
    static int colorEnabled[0];
    static int floatEnabled[0];
    static int vec2Enabled[0];
    static int stringEnabled[0];

    // Track initialized components
    static int initializedComponents[0];

    // ==== Helpers ====

    fun static string makeKey(string compId, string styleKey) {
        return compId + "/" + styleKey;
    }

    // ==== Component Management ====

    @doc "Initialize storage for a component with default values from current styles."
    fun static void initComponent(string compId, string compType) {
        // Check if already initialized
        if (initializedComponents.isInMap(compId)) return;
        1 => initializedComponents[compId];

        // Initialize color overrides
        ComponentStyleMap.getColorKeys(compType) @=> string colorKeys[];
        for (string key : colorKeys) {
            makeKey(compId, key) => string mapKey;
            UIStyle.color(key, @(0.5, 0.5, 0.5, 1)) => colorOverrides[mapKey];
            0 => colorEnabled[mapKey];
        }

        // Initialize float overrides
        ComponentStyleMap.getFloatKeys(compType) @=> string floatKeys[];
        for (string key : floatKeys) {
            makeKey(compId, key) => string mapKey;
            UIStyle.varFloat(key, 0.0) => floatOverrides[mapKey];
            0 => floatEnabled[mapKey];
        }

        // Initialize vec2 overrides
        ComponentStyleMap.getVec2Keys(compType) @=> string vec2Keys[];
        for (string key : vec2Keys) {
            makeKey(compId, key) => string mapKey;
            UIStyle.varVec2(key, @(0.5, 0.5)) => vec2Overrides[mapKey];
            0 => vec2Enabled[mapKey];
        }

        // Initialize string overrides
        ComponentStyleMap.getStringKeys(compType) @=> string stringKeys[];
        for (string key : stringKeys) {
            makeKey(compId, key) => string mapKey;
            UIStyle.varString(key, "") => stringOverrides[mapKey];
            0 => stringEnabled[mapKey];
        }
    }

    @doc "Check if a component has been initialized."
    fun static int hasComponent(string compId) {
        return initializedComponents.isInMap(compId);
    }

    @doc "Clear all overrides for a component."
    fun static void clearComponent(string compId) {
        // Remove from initialized tracking
        if (initializedComponents.isInMap(compId)) {
            initializedComponents.erase(compId);
        }

        // Get all keys and remove those starting with compId/
        string prefix;
        compId + "/" => prefix;

        // Clear color overrides
        string colorKeys[0];
        colorOverrides.getKeys(colorKeys);
        for (string k : colorKeys) {
            if (k.find(prefix) == 0) {
                colorOverrides.erase(k);
                colorEnabled.erase(k);
            }
        }

        // Clear float overrides
        string floatKeys[0];
        floatOverrides.getKeys(floatKeys);
        for (string k : floatKeys) {
            if (k.find(prefix) == 0) {
                floatOverrides.erase(k);
                floatEnabled.erase(k);
            }
        }

        // Clear vec2 overrides
        string vec2Keys[0];
        vec2Overrides.getKeys(vec2Keys);
        for (string k : vec2Keys) {
            if (k.find(prefix) == 0) {
                vec2Overrides.erase(k);
                vec2Enabled.erase(k);
            }
        }

        // Clear string overrides
        string stringKeys[0];
        stringOverrides.getKeys(stringKeys);
        for (string k : stringKeys) {
            if (k.find(prefix) == 0) {
                stringOverrides.erase(k);
                stringEnabled.erase(k);
            }
        }
    }

    // ==== Applying Overrides ====

    @doc "Apply all enabled overrides for a component onto the UIStyle stack."
    fun static void applyOverrides(string compId) {
        string prefix;
        compId + "/" => prefix;

        // Apply color overrides
        string colorKeys[0];
        colorEnabled.getKeys(colorKeys);
        for (string mapKey : colorKeys) {
            if (mapKey.find(prefix) == 0 && colorEnabled[mapKey]) {
                mapKey.substring(prefix.length()) => string styleKey;
                UIStyle.pushColor(styleKey, colorOverrides[mapKey]);
            }
        }

        // Apply float overrides
        string floatKeys[0];
        floatEnabled.getKeys(floatKeys);
        for (string mapKey : floatKeys) {
            if (mapKey.find(prefix) == 0 && floatEnabled[mapKey]) {
                mapKey.substring(prefix.length()) => string styleKey;
                UIStyle.pushVar(styleKey, floatOverrides[mapKey]);
            }
        }

        // Apply vec2 overrides
        string vec2Keys[0];
        vec2Enabled.getKeys(vec2Keys);
        for (string mapKey : vec2Keys) {
            if (mapKey.find(prefix) == 0 && vec2Enabled[mapKey]) {
                mapKey.substring(prefix.length()) => string styleKey;
                UIStyle.pushVar(styleKey, vec2Overrides[mapKey]);
            }
        }

        // Apply string overrides
        string stringKeys[0];
        stringEnabled.getKeys(stringKeys);
        for (string mapKey : stringKeys) {
            if (mapKey.find(prefix) == 0 && stringEnabled[mapKey]) {
                mapKey.substring(prefix.length()) => string styleKey;
                UIStyle.pushVar(styleKey, stringOverrides[mapKey]);
            }
        }
    }

    @doc "Count total enabled color overrides for a component."
    fun static int countColorOverrides(string compId) {
        0 => int count;
        string prefix;
        compId + "/" => prefix;

        string keys[0];
        colorEnabled.getKeys(keys);
        for (string mapKey : keys) {
            if (mapKey.find(prefix) == 0 && colorEnabled[mapKey]) {
                count++;
            }
        }
        return count;
    }

    @doc "Count total enabled var overrides (float + vec2 + string) for a component."
    fun static int countVarOverrides(string compId) {
        0 => int count;
        string prefix;
        compId + "/" => prefix;

        string floatKeys[0];
        floatEnabled.getKeys(floatKeys);
        for (string mapKey : floatKeys) {
            if (mapKey.find(prefix) == 0 && floatEnabled[mapKey]) {
                count++;
            }
        }

        string vec2Keys[0];
        vec2Enabled.getKeys(vec2Keys);
        for (string mapKey : vec2Keys) {
            if (mapKey.find(prefix) == 0 && vec2Enabled[mapKey]) {
                count++;
            }
        }

        string stringKeys[0];
        stringEnabled.getKeys(stringKeys);
        for (string mapKey : stringKeys) {
            if (mapKey.find(prefix) == 0 && stringEnabled[mapKey]) {
                count++;
            }
        }

        return count;
    }

    @doc "Count total enabled overrides for a component."
    fun static int countOverrides(string compId) {
        return countColorOverrides(compId) + countVarOverrides(compId);
    }

    // ==== Accessors for Colors ====

    fun static vec4 getColor(string compId, string key) {
        makeKey(compId, key) => string mapKey;
        if (colorOverrides.isInMap(mapKey)) {
            return colorOverrides[mapKey];
        }
        return @(0.5, 0.5, 0.5, 1);
    }

    fun static void setColor(string compId, string key, vec4 value) {
        makeKey(compId, key) => string mapKey;
        value => colorOverrides[mapKey];
    }

    fun static int isColorEnabled(string compId, string key) {
        makeKey(compId, key) => string mapKey;
        if (colorEnabled.isInMap(mapKey)) {
            return colorEnabled[mapKey];
        }
        return 0;
    }

    fun static void setColorEnabled(string compId, string key, int enabled) {
        makeKey(compId, key) => string mapKey;
        enabled => colorEnabled[mapKey];
    }

    // ==== Accessors for Floats ====

    fun static float getFloat(string compId, string key) {
        makeKey(compId, key) => string mapKey;
        if (floatOverrides.isInMap(mapKey)) {
            return floatOverrides[mapKey];
        }
        return 0.0;
    }

    fun static void setFloat(string compId, string key, float value) {
        makeKey(compId, key) => string mapKey;
        value => floatOverrides[mapKey];
    }

    fun static int isFloatEnabled(string compId, string key) {
        makeKey(compId, key) => string mapKey;
        if (floatEnabled.isInMap(mapKey)) {
            return floatEnabled[mapKey];
        }
        return 0;
    }

    fun static void setFloatEnabled(string compId, string key, int enabled) {
        makeKey(compId, key) => string mapKey;
        enabled => floatEnabled[mapKey];
    }

    // ==== Accessors for Vec2s ====

    fun static vec2 getVec2(string compId, string key) {
        makeKey(compId, key) => string mapKey;
        if (vec2Overrides.isInMap(mapKey)) {
            return vec2Overrides[mapKey];
        }
        return @(0.5, 0.5);
    }

    fun static void setVec2(string compId, string key, vec2 value) {
        makeKey(compId, key) => string mapKey;
        value => vec2Overrides[mapKey];
    }

    fun static int isVec2Enabled(string compId, string key) {
        makeKey(compId, key) => string mapKey;
        if (vec2Enabled.isInMap(mapKey)) {
            return vec2Enabled[mapKey];
        }
        return 0;
    }

    fun static void setVec2Enabled(string compId, string key, int enabled) {
        makeKey(compId, key) => string mapKey;
        enabled => vec2Enabled[mapKey];
    }

    // ==== Accessors for Strings ====

    fun static string getString(string compId, string key) {
        makeKey(compId, key) => string mapKey;
        if (stringOverrides.isInMap(mapKey)) {
            return stringOverrides[mapKey];
        }
        return "";
    }

    fun static void setString(string compId, string key, string value) {
        makeKey(compId, key) => string mapKey;
        value => stringOverrides[mapKey];
    }

    fun static int isStringEnabled(string compId, string key) {
        makeKey(compId, key) => string mapKey;
        if (stringEnabled.isInMap(mapKey)) {
            return stringEnabled[mapKey];
        }
        return 0;
    }

    fun static void setStringEnabled(string compId, string key, int enabled) {
        makeKey(compId, key) => string mapKey;
        enabled => stringEnabled[mapKey];
    }
}
