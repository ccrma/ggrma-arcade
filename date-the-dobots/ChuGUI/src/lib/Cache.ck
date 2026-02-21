public class IconCache {
    static Texture cache[0];

    fun static void set(string key, Texture tex) {
        tex @=> cache[key];
    }

    fun static Texture get(string key) {
        return cache[key];
    }

    fun static void remove(string key) {
        cache.erase(key);
    }
}