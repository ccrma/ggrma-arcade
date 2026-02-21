/*
Mr. driller is awesome
So is Motherlode

- press on rythm to get faster resources.
    - I actually hate rhythm stuff because of variable latency with different kboards
    - but maybe we can quantize the mining to music, REZ-style

- ideas:
    - destroying blocks harvests their resource
    - have a "shop" block that very randomly spawns, allow spending resources to buy upgrades
        - high hp, you need to try to path towards it
        - shop items:
            - steel shoes: don't take damage from falling on spikes
            - spring: enables jumping
            - delts: mine faster sideways
            - +long arms: mining hits 2 blocks in same direction
    - level up from mining blocks?
        - upgrades:
            - dmg per hit
            - hit cooldown
    - other block types
        - mine blocks that explode
        - spike traps that kill on contact
            - spawn logic: increase chance if there are more empty blocks above
        - invincible blocks?
        - coin blocks (mine to get coin to spend at shop)
        - obsidian: can't destroy
        - straw: touching makes it break
    - goal: survive XX minutes
    - difficulty curve
        - block hp increases
        - camera moves down faster?
        - camera livable "band" narrows and moves, i.e. top and bottom visible edges
    - contraints
        - no enemies
        - no upward movement. this might change, follow gameplay needs
        - no mouse. kb only


collision:
    - only need to check the 9grid squares immediately around player

following risk-reward model, there needs to be things that encourage players to be in the riskiest areas
    - at very top, near off-screen death zone
    - at very bottom, with minimal visibility of what's further down

Up to flap? like old birb controls

Optimizaitons (if needed)
- only draw a tile if onscreen

Stretch:
- technical flex: on death, lerp camera back to starting pos, 
drawing all previous tile history as it moves back
    - can maybe fake this by drawing random shit, camera might move fast enough to not be able to tell
    - rapidly decrement the depth(m) counter while moving up
    - synchronize a sliding upward sfx 
    - actually think we need this to juice the death sequence

TODO:
- JUICE THE MINING!
    - 
- exp + lvl up system
- obsidian tile
- straw tile
- coin should only spawn every N rows
    - change tile generation to be at tilemap level, not individual tile.
- test flying code
*/

// @import "../lib/g2d/ChuGL.chug"
// @import "../lib/g2d/ChuGL-debug.chug"
@import "lib/g2d/g2d.ck"
@import "lib/M.ck"
@import "lib/T.ck"
@import "lib/b2/b2DebugDraw.ck"
@import "sfx.ck"
@import "sound.ck"
@import "HashMap.chug"
@import "spring.ck"
@import {"Eggscavate_BGM/BGM_Player.ck" }

// game params
UI_Int seconds_per_level(30);

// tile params
UI_Float tile_pull_force(.1);
UI_Float egg_probability(.005);
UI_Bool egg_gatcha(true);


// map params
UI_Int MINE_W(7);
UI_Int MINE_H(20);

// camera params
UI_Float camera_base_speed(.4); // TWEAK
UI_Float camera_speed(camera_base_speed.val()); // TWEAK
UI_Float screen_zeno(.05); // TODO TWEAK
UI_Float player_target_pos(-2.0); // how far the player should be above camera center. TWEAK
UI_Float camera_game_start_pos(2);

// player params
UI_Float2 player_gamestart_pos(@(-5, 10));
UI_Float player_speed(4.0);
UI_Float player_base_size(.66);
UI_Float player_size(player_base_size.val());

// title screen params
UI_Float title_sca(2);

// FlatMaterial title_mat;
// GMesh title(new PlaneGeometry, title_mat) --> GG.scene();
// 5.2 => float title_y;
// title.posY(title_y);
// title.sca(title_sca.val() * @(3.62,1));

G2D g;
g.antialias(true);
GText.defaultFont("chugl:proggy-tiny");

1.5 => float aspect;
GWindow.sizeLimits(0, 0, 0, 0, @(aspect, 1));
GWindow.center();
GWindow.title("EGGSCAVATE");

GG.camera().viewSize(10);

// == load assets ================================================
TextureLoadDesc tex_load_desc;
true => tex_load_desc.flip_y;
false => tex_load_desc.gen_mips;

Texture.load(me.dir() + "./assets/credits.png", tex_load_desc) @=> Texture credits_sprite;

Texture.load(me.dir() + "./assets/firefly.png", tex_load_desc) @=> Texture firefly_sprite;

Texture.load(me.dir() + "./assets/coin.png", tex_load_desc) @=> Texture coin_single_sprite;
Texture.load(me.dir() + "./assets/coin_anim.png", tex_load_desc) @=> Texture coin_sprite; // 100::ms per frame
Texture.load(me.dir() + "./assets/chicken-hat1.png", tex_load_desc) @=> Texture chicken_sprite; // 50::ms per frame

Texture.load(me.dir() + "./assets/dirt.png", tex_load_desc) @=> Texture dirt_sprite_0;
Texture.load(me.dir() + "./assets/dirt1.png", tex_load_desc) @=> Texture dirt_sprite_1;
Texture.load(me.dir() + "./assets/dirt2.png", tex_load_desc) @=> Texture dirt_sprite_2;
Texture.load(me.dir() + "./assets/dirt3.png", tex_load_desc) @=> Texture dirt_sprite_3;
Texture.load(me.dir() + "./assets/dirt4.png", tex_load_desc) @=> Texture dirt_sprite_4;

Texture.load(me.dir() + "./assets/stone.png", tex_load_desc) @=> Texture stone_sprite_0;
Texture.load(me.dir() + "./assets/stone1.png", tex_load_desc) @=> Texture stone_sprite_1;
Texture.load(me.dir() + "./assets/stone2.png", tex_load_desc) @=> Texture stone_sprite_2;
Texture.load(me.dir() + "./assets/stone3.png", tex_load_desc) @=> Texture stone_sprite_3;
Texture.load(me.dir() + "./assets/stone4.png", tex_load_desc) @=> Texture stone_sprite_4;

Texture.load(me.dir() + "./assets/wood.png", tex_load_desc) @=> Texture wood_sprite_0;
Texture.load(me.dir() + "./assets/wood1.png", tex_load_desc) @=> Texture wood_sprite_1;
Texture.load(me.dir() + "./assets/wood2.png", tex_load_desc) @=> Texture wood_sprite_2;
Texture.load(me.dir() + "./assets/wood3.png", tex_load_desc) @=> Texture wood_sprite_3;
Texture.load(me.dir() + "./assets/wood4.png", tex_load_desc) @=> Texture wood_sprite_4;

Texture.load(me.dir() + "./assets/obsidian.png", tex_load_desc) @=> Texture obsidian_sprite;

Texture.load(me.dir() + "./assets/axe.png", tex_load_desc) @=> Texture axe_sprite; // 50::ms per frame
Texture.load(me.dir() + "./assets/pickaxe.png", tex_load_desc) @=> Texture pickaxe_sprite; // 50::ms per frame
Texture.load(me.dir() + "./assets/shovel.png", tex_load_desc) @=> Texture shovel_sprite; // 50::ms per frame

Texture.load(me.dir() + "./assets/smear.png", tex_load_desc) @=> Texture smear_sprite; // 4 frames, 100::ms per frame
Texture.load(me.dir() + "./assets/spike.png", tex_load_desc) @=> Texture spike_sprite; // 11 frames, 75::ms per frame

Texture.load(me.dir() + "./assets/egg_break.png", tex_load_desc) @=> Texture egg_sprite; // 5 frames
Texture.load(me.dir() + "./assets/egg_unlock.png", tex_load_desc) @=> Texture egg_lock_sprite; // 2 frames

// egg art
Texture.load(me.dir() + "./assets/egg_types/egg-spots.png", tex_load_desc) @=> Texture egg_spots_sprite;
Texture.load(me.dir() + "./assets/egg_types/egg-tetris.png", tex_load_desc) @=> Texture egg_tetris_sprite;
Texture.load(me.dir() + "./assets/egg_types/egg-plus.png", tex_load_desc) @=> Texture egg_plus_sprite;
Texture.load(me.dir() + "./assets/egg_types/egg-foot.png", tex_load_desc) @=> Texture egg_foot_sprite;
// Texture.load(me.dir() + "./assets/egg_types/egg-special.png", tex_load_desc) @=> Texture egg_special_sprite;

// start screen art
Texture.load(me.dir() + "./assets/start_screen/title.png", tex_load_desc) @=> Texture title_sprite;
Texture.load(me.dir() + "./assets/start_screen/wasd.png", tex_load_desc) @=> Texture wasd_sprite;
Texture.load(me.dir() + "./assets/start_screen/tab.png", tex_load_desc) @=> Texture tab_sprite;
Texture.load(me.dir() + "./assets/start_screen/signpost.png", tex_load_desc) @=> Texture sign_sprite;
Texture.load(me.dir() + "./assets/start_screen/grass.png", tex_load_desc) @=> Texture grass_sprite;

[
Texture.load(me.dir() + "./assets/start_screen/star1.png", tex_load_desc),
Texture.load(me.dir() + "./assets/start_screen/star2.png", tex_load_desc),
Texture.load(me.dir() + "./assets/start_screen/star3.png", tex_load_desc),
Texture.load(me.dir() + "./assets/start_screen/star4.png", tex_load_desc),
Texture.load(me.dir() + "./assets/start_screen/star5.png", tex_load_desc),
Texture.load(me.dir() + "./assets/start_screen/star6.png", tex_load_desc),
] @=> Texture star_sprites[];

// == sound ================================
CKFXR sfx => dac;

BGM_Playing bgm_play;
BGM_Opening bgm_open;

Sound snd(128);
snd.syncBeat(now);

// == graphics helpers ================================

vec2 tri_vertices[3];
fun void tri(vec2 pos, float base, float height) {
    @(base/2, 0) => tri_vertices[0];
    @(0, height) => tri_vertices[1];
    @(-base/2, 0) => tri_vertices[2];
    g.polygonFilled(pos, 0, tri_vertices, 0);
}

class AnimationEffect extends Effect {
    int nframes;
    .1 => float secs_per_frame;
    Texture@ sprite;
    vec2 pos;
    vec2 sca;
    float rot;


    // private
    int curr_frame;
	
	fun @construct(vec2 pos, vec2 sca, float rot, int nframes, Texture@ sprite, float secs_per_frame) { 
        pos => this.pos;
        sca => this.sca;
        rot => this.rot;
        nframes => this.nframes;
        sprite @=> this.sprite;
        secs_per_frame => this.secs_per_frame;
    }

	fun int update(G2D g, float dt) {
        (uptime / secs_per_frame) $ int => int frame;
        if (frame >= nframes) return END;

        g.pushLayer(1);
        g.sprite(
            this.sprite, nframes, frame,
            pos, sca, rot, Color.WHITE
        );
        g.popLayer();

		return STILL_GOING;
	}
}

class LevelUpEffect extends Effect {
    string text;
	Texture@ s;
	vec2 pos;
	float max_dur;
	float dy;
	float size;

	fun @construct(string text, Texture@ s, vec2 pos, float max_dur, float dy, float size) {
        text => this.text;
		s @=> this.s;
		pos => this.pos;
		max_dur => this.max_dur;
		dy => this.dy;
		size => this.size;
	}

	fun int update(G2D g, float dt) {
		if (uptime > max_dur) return END;
		uptime / max_dur => float t;

		// quadratic ease
		1 - (1 - t) * (1 - t) => t;
		g.pushLayer(1);
        g.pushColor(Color.WHITE);
		g.text(text, pos + @(-.1, t * dy), .8 * size);
		g.sprite(s, pos + @(.1, t * dy), .4 * size, 0);
        g.popColor();
		g.popLayer();

		return STILL_GOING;
	}
}


fun void smear(vec2 pos, float rot) {
    g.add(new AnimationEffect(pos, .75 * @(1, 1), rot, 4, smear_sprite, .06));
}

fun void starTwinkle(vec2 pos) {
    g.add(new AnimationEffect(pos, .2 * @(1, 1), 0, 5, star_sprites[Math.random2(0, star_sprites.size() -1)], .3));
}

fun void levelUpEffect(string text, Texture@ t, vec2 pos, float dy, float sz) {
    g.add(new LevelUpEffect(text, t, pos, .75, dy, sz));
}

fun void progressBar(
    float percentage, vec2 pos, float width, float height, int draw_chicken
) {
    width * .5 => float hw;
    height * .5 => float hh;

    g.box(pos - @(0, hh), 2 * hw, 2 * hh, Color.WHITE);

    (percentage * 2 * hh) => float end_y;

    pos - @(hw, 0) => vec2 bl;
    pos + @(hw, -end_y) => vec2 tr;

    if (draw_chicken) {
        g.pushLayer(1);
        g.sprite(
            chicken_sprite, 4, 0,
            tr + @(-hw, 0), .3 * @(player.facing, 1), 0, Color.WHITE
        );
        g.popLayer();
    } else {
        g.boxFilled( bl, tr, Color.WHITE);
    }
}


// == physics ================================
class Physics {
    b2WorldDef world_def;
    int b2_world_id;
    int begin_sensor_events[0];
    int begin_touch_events[0];
    int end_touch_events[0];

    UI_Bool draw_b2_debug(false);
    DebugDraw debug_draw;
    debug_draw.layer(10);
    true => debug_draw.drawShapes;
    true => debug_draw.outlines_only;

    @(0, -9.81) => world_def.gravity;
    b2.createWorld(world_def) => b2_world_id;
    b2.world(b2_world_id);


    fun int createBody(vec2 pos, int body_type, int category, float sz, int is_sensor, b2Polygon@ geo) {
        return createBody(pos, body_type, category, sz, is_sensor, geo, 0);
    }

    fun int createBody(vec2 pos, int body_type, int category, float sz, int is_sensor, b2Polygon@ geo, int mask) {
        b2BodyDef player_body_def;
        pos => player_body_def.position;
        body_type => player_body_def.type;
        true => player_body_def.fixedRotation;
        false => player_body_def.enableSleep;

        // entity
        b2.createBody(b2_world_id, player_body_def) => int b2_body_id;

        // filter
        b2Filter player_filter;
        category => player_filter.categoryBits;
        0xFFFFFFF ^ mask => player_filter.maskBits; // disallow player-player collision

        // shape
        b2ShapeDef player_shape_def;
        player_filter @=> player_shape_def.filter;
        if (
            category == EntityType_Player || is_sensor
        ) true => player_shape_def.enableSensorEvents;
        true => player_shape_def.enableContactEvents;
        1 => player_shape_def.density;
        is_sensor => player_shape_def.isSensor;

        // geo
        if (geo == null) b2.makeRoundedBox(.9 * sz, .9 * sz, .05 * sz) @=> geo; // use rounded corners to prevent ghost collisions
        b2.createPolygonShape(b2_body_id, player_shape_def, geo) => int b2_shape_id;

        return b2_body_id;
    }
}
Physics p;

0 => int EntityType_None;
1 => int EntityType_Player;
2 => int EntityType_Tile;
4 => int EntityType_Static;
8 => int EntityType_Spike;

0 => int TileType_None; // empty space
1 => int TileType_Dirt; // shovel
2 => int TileType_Wood; // axe
3 => int TileType_Stone; // pickaxe
4 => int TileType_Coin;
5 => int TileType_Spike;
6 => int TileType_Egg;
7 => int TileType_Obsidian;
8 => int TileType_Count; 

[
    Color.MAGENTA,
    Color.DARKGREEN,
    Color.BROWN,
    Color.GRAY,
] @=> vec3 tile_colors[];

[
    null,
    [
        dirt_sprite_0,
        dirt_sprite_1,
        dirt_sprite_2,
        dirt_sprite_3,
        dirt_sprite_4,
    ],
    [
        wood_sprite_0,
        wood_sprite_1,
        wood_sprite_2,
        wood_sprite_3,
        wood_sprite_4,
    ],
    [
        stone_sprite_0,
        stone_sprite_1,
        stone_sprite_2,
        stone_sprite_3,
        stone_sprite_4,
    ],
    [coin_sprite],
    null,
] @=> Texture tile_textures[][];

[
    null,
    shovel_sprite,
    axe_sprite,
    pickaxe_sprite,
    coin_sprite,
    null,
] @=> Texture tile_tools[];

[
    null, // none
    [snd.SOUND_SOIL1, snd.SOUND_SOIL2], // soil
    [snd.SOUND_WOOD1, snd.SOUND_WOOD2], // wood
    [snd.SOUND_STONE1, snd.SOUND_STONE2, snd.SOUND_STONE3], // stone
    null, // coin
    null, // spike
    [snd.SOUND_EGG]
] @=> int tile_sounds[][];

string eventbox_text[0];
fun void addEventText(string s) {
    if (room != Room_Start) {
        eventbox_text << s;

        spork ~ snd.play(
            snd.SOUND_MESSAGE,
            16.0, // gain
            1.0, // rate
            0, // loop
            4 // gridDivision
        );
    }
}

int depth100;
int depth500;
int depth1000;

[
    200.,
    500.,
    1000.,
    2000.,
    3500.,
    5500.,
    8000.,
    11000.,
    14500.,
    18500.
] @=> float end_depths[];
0 => int end_depth_ix;

[
    "You wonder whether you or the egg came first.",
    "The depths call to you.",
    "You wonder why you are here.",
    "You wonder if Betsy ever did manage to cross the road.",
    "You wonder if you've been here before.",
    "You swear you've seen this place.",
    "The abyss calms you.",
    "You're tired. But you know you must dig.",
    "Your digging fills you with determination.",
    "The price of freedom sure is steep.",

] @=> string random_event_text[];
[
"The abyss has its eyes on me.",
"You feel like you're not alone.",
"You feel like you've crossed a million raods by now.",
"You wonder if a creeper is going to show up soon.",
"You wonder who would set up spikes in a cave.",
"You feel like you're almost there.",
"The strength of those before you empowers you.",
"Your eggs are your power!",
] @=> string deep_random_event_text[];

[
"That was a big fall. You peed a little.",
"If only you had stronger wings to break your fall.",
"You swear chickens normally aren't this heavy.",
"You landed like a bowling ball.",
] @=> string pee_text[];

/*
Egg mechanic: need X coins/keys to open lock. After openning, need to break the egg to get the power
- will become clear what type of egg it is after opening 
*/
0 => int EggType_Spoiled; // dud. does nothing
1 => int EggType_Juggernaut; // become larger. move slower. do more dmg
2 => int EggType_Connection; // damaging a tile damages all tiles of the same time that are connected
3 => int EggType_Foot; // spike immunity
// 4 => int EggType_Special; // last egg
4 => int EggType_Count; // become larger. move slower. do more dmg

[
    "spoiled",
    "jeggernaut",
    "connegg",
    "chickenfoot",
    // "eggo"
] @=> string egg_names[];

[
    egg_spots_sprite,
    egg_plus_sprite,
    egg_tetris_sprite,
    egg_foot_sprite,
    // egg_special_sprite,
] @=> Texture egg_sprites[];
int firstEggSpawned;

class Player {
    int b2_body_id;
    int dead;

    TileType_Dirt => int tool;
    int tool_level[TileType_Count];
    int tool_exp[TileType_Count];

    // tiles touching
    Tile@ tile_left;
    Tile@ tile_right;
    Tile@ tile_down;

    // animation
    float animation_time_secs;
    1 => int facing;
    Spring tool_scale_spring(0, 500, 20);

    vec2 prev_vel;

    // eggs
    int eggs[EggType_Count];


    // preconstructor
    p.createBody(player_gamestart_pos.val(), b2BodyType.dynamicBody, EntityType_Player, player_size.val(), false, null) => b2_body_id;
    // b2Body.disable(b2_body_id);

    fun void remakeCollider() {
        pos() => vec2 old_pos;
        b2.destroyBody(b2_body_id);
        p.createBody(old_pos, b2BodyType.dynamicBody, EntityType_Player, player_size.val() * 16.0/18, false, null, 
        eggs[EggType_Foot] ?  EntityType_Spike : 0
        ) => b2_body_id;
    }

    fun int expToLevel(int tool_type) {
        (tool_level[tool_type] + 3) => int x;
        return x*x;
    }

    fun vec2 pos() { return b2Body.position(this.b2_body_id); }
    fun void pos(vec2 p) { b2Body.position(this.b2_body_id, p); }
    fun void posX(float x) { b2Body.position(this.b2_body_id, @(x, this.pos().y)); }

    fun void vel(vec2 v) {  b2Body.linearVelocity(this.b2_body_id, v); }
    fun vec2 vel() {  return b2Body.linearVelocity(this.b2_body_id); }
}

class Tile {
    int b2_body_id;

    // position in tilemap. currently only used in allConnected().
    // NOT set by default
    int row;
    int col;

    int type;
    int max_hp;
    int hp;

    // egg params
    int egg_type;
    int cost_to_unlock; // init to cost, decremented to 0 on purchase

    Spring translation_spring(0, 4200, 20);
    Spring rotation_spring(0, 1000, 10);
    Spring egg_price_spring(0, 500, 20);

    static HashMap b2body_to_tile_map;
    fun static Tile get(int b2_body_id) {
        return b2body_to_tile_map.getObj(b2_body_id) $ Tile;
    }

    fun void _destroyBody() {
        if (b2_body_id) {
            T.assert(b2Body.isValid(b2_body_id), "Tile empty() b2body not valid");
            b2body_to_tile_map.del(b2_body_id);
            b2.destroyBody(b2_body_id);
            0 => b2_body_id;
        }
    }

    fun void become(vec2 pos, int type, int hp) {
        if (type == TileType_Egg) {
            egg(pos, Math.random2(0, EggType_Count - 1));
            return;
        }

        type => this.type;
        hp => max_hp => this.hp;
        if (type == TileType_None) {
            empty();
            return;
        }

        _destroyBody();
        p.createBody(pos, b2BodyType.staticBody, EntityType_Tile, 1.0, false, null) => b2_body_id;
        b2body_to_tile_map.set(b2_body_id, this);
    }

    fun void empty() {
        TileType_None => type;
        0 => max_hp;
        0 => hp;
        _destroyBody(); 
    }

    fun void coin(vec2 pos) {
        // TODO: should coins also need to be "mined" ?
        TileType_Coin => type;
        0 => max_hp;
        0 => hp;
        _destroyBody();
        p.createBody(pos, b2BodyType.staticBody, EntityType_Tile, .68, true, null) => b2_body_id;
        b2body_to_tile_map.set(b2_body_id, this);
    }

    fun void egg(vec2 pos, int egg_type) {
        T.assert(egg_type < EggType_Count, "invalid egg type");
        egg_type => this.egg_type;
        TileType_Egg => type;
        Math.min(difficulty,7) * 5 => max_hp; // tweak egg hp
        max_hp => hp;
        5 => cost_to_unlock;
        _destroyBody();
        p.createBody(pos, b2BodyType.staticBody, EntityType_Tile, 1.0, false, null) => b2_body_id;
        b2body_to_tile_map.set(b2_body_id, this);
    }

    fun void spike(vec2 pos) {
        TileType_Spike => type;
        100 => max_hp;
        max_hp => hp;
        _destroyBody();
        // hit box is half the tile
        b2.makeOffsetBox(
            .35, // hw
            .25, // hh 
            @(0, -.25),    // center (local space)
            0 // rotation radians
        ) @=> b2Polygon geo;
        p.createBody(pos, b2BodyType.staticBody, EntityType_Spike, 0.0, false, geo) => b2_body_id;
        b2body_to_tile_map.set(b2_body_id, this);
    }
    
    fun void randomize(vec2 pos) {
        // first: have a fixed n% chance of spawning a coin
        if (rows_to_next_coin <= 0 && Math.randomf() < .05) {
            Math.random2(4, 12) => rows_to_next_coin;
            coin(pos);
            return;
        }

        // only spawn egg if we have enough coins
        if (rows_to_next_egg <= 0 && (n_coins > 5) && Math.randomf() < .05) {
            Math.random2(25, 36) => rows_to_next_egg;
            if (!firstEggSpawned) {
                addEventText("You feel like you should break the egg.");
                true => firstEggSpawned;
            }
            egg(pos, Math.random2(0, EggType_Count - 1));
            return;
        }

        Math.random2(0, TileType_Stone) => type;
        Math.random2(0, HP_MAX + difficulty) => max_hp;
        if (type == TileType_None || max_hp == 0) {
            empty();
            return;
        }
        max_hp => hp;

        _destroyBody();
        p.createBody(pos, b2BodyType.staticBody, EntityType_Tile, 1.0, false, null) => b2_body_id;
        b2body_to_tile_map.set(b2_body_id, this);
    }

    fun vec2 pos() { return b2Body.position(this.b2_body_id); }
    fun void pos(vec2 p) { b2Body.position(this.b2_body_id, p); }
}


Tile tilemap[MINE_H.val()][MINE_W.val()];
int base_row; // what #row is tilemap[0]? (increments with every shift)
1.0 => float spawn_dist; // camera distance to spawn next row of blocks
int rows_to_next_coin;
int rows_to_next_egg;
vec3 history[0];


fun vec2 tilepos(int r, int c) {
    base_row +=> r;
    return @(
        -((MINE_W.val()) * .5) + .5 + c,
        // (MINE_H.val() * .5) - .5 - r
        -.5 - r
    );
}

fun vec2 gridpos(vec2 p) {
    vec2 grid;
    Math.floor(-(p.y + base_row)) => grid.x;
    (p.x + MINE_W.val() / 2.0) $ int => grid.y;
    return grid;
}

5 => int HP_MAX;

// player params
Player player; // TODO physics body
null @=> Player @ other;
5 => int n_coins;
int shake_count;

int resources[TileType_Count];

int score;
int highscore;
float start_depth;

0 => int Room_Start;
1 => int Room_Play;
2 => int Room_End;
int room;

int ended;
int playerEgg;
int newChicken;
int newChickenFallen;
int newChickenPlayerCollision;

float gametime;
int difficulty;

Spring camera_shake_spring(0, 4200, 20);

0 => int Dir_None;
1 => int Dir_Left;
2 => int Dir_Right;
3 => int Dir_Down;
4 => int Dir_Up;

// start screen params
Spring wasd_rot_spring(0, 100, 8);
Spring wasd_sca_spring(0, 420, 8);
Spring tab_rot_spring(0, 100, 8);
Spring tab_sca_spring(0, 420, 8);

Spring tool1_rot_spring(0, 100, 8);
Spring tool1_sca_spring(0, 420, 8);
Spring tool2_rot_spring(0, 100, 8);
Spring tool2_sca_spring(0, 420, 8);
Spring tool3_rot_spring(0, 100, 8);
Spring tool3_sca_spring(0, 420, 8);

HashMap visited_tiles;
// optimize: don't recreate array every frame
fun Tile[] allConnected(int row, int col) {
    tilemap[row][col] @=> Tile tile;
    row => tile.row; col => tile.col;
    Tile tiles[0];
    if (tile.hp == 0) return tiles;

    visited_tiles.clear();
    tile.type => int type;
    [tile] @=> Tile bfs_queue[];

    while (bfs_queue.size()) {
        bfs_queue[-1] @=> Tile t;
        bfs_queue.popBack();
        T.assert(t.type == type && t.hp > 0, "invalid bfs tile");

        if (visited_tiles.has(t)) continue;

        tiles << t;
        visited_tiles.set(t, true);

        // add adjacent
        t.row => int r; t.col => int c;
        if (r+1 < MINE_H.val()) { // below
            tilemap[r+1][c] @=> Tile n;
            if (n.type == type && n.hp > 0) {
                r+1 => n.row; c => n.col;
                bfs_queue << n;
            }
        }
        if (r-1 >= 0) { // above
            tilemap[r-1][c] @=> Tile n;
            if (n.type == type && n.hp > 0) {
                r-1 => n.row; c => n.col;
                bfs_queue << n;
            }
        }
        if (c+1 < MINE_W.val()) { // right
            tilemap[r][c+1] @=> Tile n;
            if (n.type == type && n.hp > 0) {
                r => n.row; c+1 => n.col;
                bfs_queue << n;
            }
        }
        if (c-1 >= 0) { // left
            tilemap[r][c-1] @=> Tile n;
            if (n.type == type && n.hp > 0) {
                r => n.row; c-1 => n.col;
                bfs_queue << n;
            }
        }
    }

    T.assert(tiles.size() == visited_tiles.size(), "potential duplicates in allConnected " + tiles.size() + ", " + visited_tiles.size());

    return tiles;
}

fun void wait(dur duration) {
    now => time start;
    while(now - start < duration) {
        GG.nextFrame() => now;
    }
}
fun static float lerp(float a, float b, float t) {
    return a + (b - a) * t;
}
int lastEggFrame;
fun void endingAnimation() {
    // turn chicken into egg
    1::second => dur duration;
    now => time start;
    while (now - start < duration) {
        GG.nextFrame() => now;
        player.pos() + @(0, 0.05) => player.pos;
    }
    true => playerEgg;
    eventbox_text.clear();

    addEventText("Wait, what's going on?");

    // spawn chicken to mine you
    wait(5::second);

    Player p @=> other;
    true => newChicken;
    other.pos(g.n2w(-0.25, 1.2));

    while (!newChickenFallen) {
        GG.nextFrame() => now;
    }

    bgm_open.play();
    snd.syncBeat(now);
    camera_shake_spring.pull(8 * .05);
    spork ~ snd.play(
        Math.random2(snd.SOUND_BAWK0, snd.SOUND_BAWK4),
        2.0, // gain
        1.0, // rate
        0, // loop
        4 // gridDivision
    );

    wait(2::second);

    // move towards player egg
    while (other.pos().x < player.pos().x && !newChickenPlayerCollision) {
        GG.nextFrame() => now;
        GG.dt() => float dt;
        dt +=> other.animation_time_secs;
        @(lerp(other.pos().x, player.pos().x, 0.01), other.pos().y) => other.pos;
    }

    // open player egg

    for (int i; i<31; i++) {
        wait((0.1 + 1.5 / (i + 1))::second);
        spork ~ snd.play(
            tile_sounds[TileType_Egg][Math.random2(0, tile_sounds[TileType_Egg].size() - 1)], // path
            0.75, // gain
            1.0, // rate
            0, // loop
            4 // gridDivision
        );
        // attack anim
        other.pos() => vec2 smear_pos;
        float smear_rot;
        .5*player_base_size.val() +=> smear_pos.x;
        g.explode(smear_pos, .3, .3::second, Color.WHITE, smear_rot + Math.pi, Math.pi, ExplodeEffect.Shape_Squares);
        
        if (i % 10 == 0) {
            (lastEggFrame + 1) % 5 => lastEggFrame;
        }
    }

    player.pos(other.pos());
    other.facing => player.facing;
    false => playerEgg;
    b2.destroyBody(other.b2_body_id);
    null @=> other;
    false => ended;
    false => newChicken;
    false => newChickenFallen;
    false => newChickenPlayerCollision;
    0 => lastEggFrame;
    Room_Play => room;
    end_depth_ix++;

    // shift new tiles in
    repeat(5) shift();

    bgm_open.stop();
    bgm_play.play();
    snd.syncBeat(now);
}

fun void mine(Tile tile, int row, int col, int dir) { // returns true if tile was originally empty
    if (tile.hp <= 0) {
        T.err("mining an empty tile");
        return;
    }

    if (ended && tile.type != TileType_Egg) {
        return;
    }

    if (tile.type == TileType_Egg && tile.cost_to_unlock > 0) {
        if (n_coins == 0) {
            // u a broke boi
            // TODO sound effect
            // TODO flavor text: "u r a poor chicken"
            if (maybe) addEventText("You don't have enough coins brokie.");
            else addEventText("If only Colonel S. gave you more allowance.");
        
            spork ~ snd.play(
                snd.SOUND_WRONG_TOOL,
                8.0, // gain
                1.0, // rate
                0, // loop
                4 // gridDivision
            );
            return;
        }

        n_coins--;
        tile.cost_to_unlock--;

        spork ~ snd.play(
            snd.SOUND_INSERT_COIN, // path
            2.0, // gain
            1.0, // rate
            0, // loop
            4 // gridDivision
        );



        // TODO unlock juice
        levelUpEffect("-", coin_single_sprite, player.pos() + .5*g.UP, .3, .6);
        tile.egg_price_spring.pull(.3);

        // unlcokde the egg!
        // if (tile.cost_to_unlock == 0) {
        //     // TODO unlock sfx
        //     g.add(new AnimationEffect(tile.pos(), 1.0 * @(1, 1), 0, 4, smear_sprite, .06));
        // }

        return;
    }

    // attack anim
    player.pos() => vec2 smear_pos;
    float smear_rot;
    if (dir == Dir_Right) {
        .5*player_size.val() +=> smear_pos.x;
    }
    if (dir == Dir_Left) {
        .5*player_size.val() -=> smear_pos.x;
        Math.pi => smear_rot;
    }
    if (dir == Dir_Down) {
        .5*player_size.val() -=> smear_pos.y;
        -Math.pi/2 => smear_rot;
    }
    // smear(smear_pos, smear_rot);
    g.explode(smear_pos, .3, .3::second, Color.WHITE, smear_rot + Math.pi, Math.pi, ExplodeEffect.Shape_Squares);

    // only do dmg if tool matches
    // <<< player.tool, tile.type >>>;
    if (player.tool == tile.type || tile.type == TileType_Egg) {
        if (tile.type == TileType_Egg) {
            T.assert(tile.cost_to_unlock == 0, "egg should only be damaged if unlocked");
        }

        1.0 => float dmg_modifier;
        player.tool_level[tile.type] => int base_dmg;
        if (player.eggs[EggType_Juggernaut]) 2.0 *=> dmg_modifier;
        (base_dmg * dmg_modifier) $ int => int dmg;

        [tile] @=> Tile connected_tiles[];
        if (player.eggs[EggType_Connection]) allConnected(row, col) @=> connected_tiles;

        spork ~ snd.play(
            tile_sounds[tile.type][Math.random2(0, tile_sounds[tile.type].size() - 1)], // path
            0.75, // gain
            1.0, // rate
            0, // loop
            4 // gridDivision
        );

        for (auto tile : connected_tiles) {
            Math.max(0, tile.hp - dmg) => tile.hp;
            (tile.hp == 0) => int destroyed;

            // juice
            if (destroyed) {
                tile.max_hp +=> resources[tile.type];
                // g.score("+" + tile.max_hp, tile.pos(), .5::second, .5,  0.6);
                g.explode(tile.pos(), 1, 1::second, Color.WHITE, 0, Math.two_pi, ExplodeEffect.Shape_Squares);

                // add exp to tool
                tile.max_hp +=> player.tool_exp[tile.type];
                if (player.tool_exp[tile.type] >= player.expToLevel(tile.type)) {
                    player.expToLevel(tile.type) -=> player.tool_exp[tile.type];
                    ++player.tool_level[tile.type];


                    spork ~ snd.play(
                        snd.SOUND_POWERUP,
                        6.0, // gain
                        1.0, // rate
                        0, // loop
                        4 // gridDivision
                    );
                    levelUpEffect("+", tile_tools[player.tool], player.pos() + .5*g.UP, .3, .6);
                }

                if (Math.randomf() < .002) addEventText("YOU MINED A TILE HUEHUEH...");

                // acquire egg
                if (tile.type == TileType_Egg) {
                    if (ended) {
                        tile.empty();
                        spork ~ endingAnimation();
                        return;
                    }

                    true => player.eggs[tile.egg_type];

                    // TODO add egg acquire juice

                    // on acquire egg logic
                    if (tile.egg_type == EggType_Spoiled) {
                        "You feel disappointed." => string spoiled_text;
                        if (Math.random2(0, 1)) {
                            "You knew something smelled off." => spoiled_text;
                        }
                        if (maybe) "You want your money back." => spoiled_text;
                        addEventText(spoiled_text);

                        spork ~ snd.play(
                            snd.SOUND_SPOILED_EGG_UPGRADE,
                            6.0, // gain
                            1.0, // rate
                            0, // loop
                            4 // gridDivision
                        );

                    } else {
                        "You feel ashamed... But stronger." => string non_spoiled_text;
                        if (Math.random2(0, 1)) {
                            "Why did you do that????" => non_spoiled_text;
                        }
                        addEventText(non_spoiled_text);

                        spork ~ snd.play(
                            snd.SOUND_EGG_UPGRADE,
                            6.0, // gain
                            1.0, // rate
                            0, // loop
                            4 // gridDivision
                        );
                    }

                    if (tile.egg_type == EggType_Juggernaut) {
                        .9 => player_size.val;
                        player.remakeCollider();
                        addEventText("You obtained jeggernaut! You feel stronger, bigger, and heavier.");
                    }

                    if (tile.egg_type == EggType_Connection) {
                        addEventText("You obtained connegg! You feel like you can reach farther.");
                    }

                    if (tile.egg_type == EggType_Foot) {
                        addEventText("You obtained chickenfoot! Your feet feel stronger.");
                        player.remakeCollider();
                    }
                }
                tile.empty();
            } else {
                if (tile.type != TileType_Egg) g.hitFlash((1/62.0)::second, 1.0, tile.pos(), Color.WHITE);
                tile.rotation_spring.pull(tile_pull_force.val());
                tile.translation_spring.pull(tile_pull_force.val());
            }
        }
    } else {
        spork ~ snd.play(
            snd.SOUND_WRONG_TOOL,
            8.0, // gain
            1.0, // rate
            0, // loop
            4 // gridDivision
        );
    }
}

fun void shift() {
    // shift everything up (can easily optimize)
    tilemap[0] @=> Tile bottom_row[];
    for (int row; row < MINE_H.val() - 1; row++) {
        tilemap[row+1] @=> tilemap[row];
    }

    // copy history
    for (int col; col < MINE_W.val(); col++) {
        tilepos(0, col) => vec2 pos;
        history << @(pos.x, pos.y, bottom_row[col].type);
    }

    // shift bottom to top
    bottom_row @=> tilemap[-1];
    base_row++;

    Math.max(0, rows_to_next_coin-1) => rows_to_next_coin;
    Math.max(0, rows_to_next_egg-1) => rows_to_next_egg;

    // randomize new row
    for (int col; col < MINE_W.val(); col++) {
        bottom_row[col] @=> Tile tile;
        
        tilepos(tilemap.size() - 1, col) => vec2 pos;

        (tilemap[tilemap.size() - 2][col].hp == 0) => int tile_above_is_empty;
        (tilemap[tilemap.size() - 2][col].type == TileType_Spike) => int tile_above_is_spike;
        (tilemap[tilemap.size() - 2][col].type == TileType_Egg) => int tile_above_is_egg;
        // 10% chance to spawn a spike when tile above is empty
        if (tile_above_is_empty && Math.randomf() < .1) {
            tile.spike(pos);
            continue;
        }

        // 100% chance to spawn obsidian below spike and egg
        if (tile_above_is_spike || tile_above_is_egg) {
            tile.become(pos, TileType_Obsidian, Math.INT_MAX);
            continue;
        }

        tile.randomize(tilepos(tilemap.size() - 1, col));
    }
}

fun void shiftEmpty() {
    // shift everything up (can easily optimize)
    tilemap[0] @=> Tile bottom_row[];
    for (int row; row < MINE_H.val() - 1; row++) {
        tilemap[row+1] @=> tilemap[row];
    }
    // shift bottom to top
    bottom_row @=> tilemap[-1];
    base_row++;

    // empty new row
    for (int col; col < MINE_W.val(); col++) {
        bottom_row[col] @=> Tile tile;
        tile.empty();
    }
}

fun void shiftEggMiddle() {
    // shift everything up (can easily optimize)
    tilemap[0] @=> Tile bottom_row[];
    for (int row; row < MINE_H.val() - 1; row++) {
        tilemap[row+1] @=> tilemap[row];
    }
    // shift bottom to top
    bottom_row @=> tilemap[-1];
    base_row++;

    // set new row
    for (int col; col < MINE_W.val(); col++) {
        bottom_row[col] @=> Tile tile;
        if (col == MINE_W.val() / 2) {
            tilepos(tilemap.size() - 1, col) => vec2 pos;
            tile.become(pos, TileType_Egg, 0);
            0 => tile.cost_to_unlock;
        } else {
            tile.empty();
        }
    }
}

fun void shiftAllType(int type) {
    // shift everything up (can easily optimize)
    tilemap[0] @=> Tile bottom_row[];
    for (int row; row < MINE_H.val() - 1; row++) {
        tilemap[row+1] @=> tilemap[row];
    }
    // shift bottom to top
    bottom_row @=> tilemap[-1];
    base_row++;

    // set new row
    for (int col; col < MINE_W.val(); col++) {
        bottom_row[col] @=> Tile tile;
        tilepos(tilemap.size() - 1, col) => vec2 pos;
        tile.become(pos, type, 1);
    }
}

int death_sequence;
int death_shake_count;
float death_time;
int player_exploded;

fun void die() {
    true => death_sequence;
    gametime => death_time;
    shake_count => death_shake_count;
}

vec4 grass[0];
vec4 stars[0];

int init_count;
fun void init() {
    // randomize grass
    if (init_count == 0) {
        grass.clear();
        g.screen_min.x => float x;
        while (x < g.screen_max.x) {
            if (!(x > -.6 && x < .6)) {
                grass << @(
                    x,
                    .1,
                    maybe ? -1 : 1,
                    Math.random2(0, 1)
                );
            }
            Math.random2f(0.2,3.2) +=> x;
        }
        
        stars.size(Math.random2(10, 20));
        for (int i; i < stars.size(); ++i) {
            Math.random2(0, star_sprites.size() - 1) => int which_star;
            Math.random2f(g.screen_min.x, g.screen_max.x) => float x;
            Math.random2f(1, 7) => float y;
            Math.random2f(0, 2) => float offset;
            @(
                x, y, which_star, offset
            ) => stars[i];
        }
    }

    history.clear();
    if (true) {
        0 => gametime;
        0 => score;

        0 => base_row;
        1.0 => spawn_dist;

        Math.random2(1, 3) => rows_to_next_coin;
        Math.random2(25, 40) => rows_to_next_egg;

        // init tiles
        for (int row; row < MINE_H.val(); row++) {
            for (int col; col < MINE_W.val(); col++) {
                    // first few rows empty
                    if (row < 15) tilemap[row][col].empty();
                else tilemap[row][col].randomize(tilepos(row, col));
            }
        }

        // fill in the first 3 blocks of tutorial
        if (init_count == 0) {
            tilemap[0][3].become(tilepos(0, 3), TileType_Dirt, 5);
            tilemap[1][3].become(tilepos(1, 3), TileType_Wood, 5);
            tilemap[2][3].become(tilepos(2, 3), TileType_Stone, 5);
        }

        // init camera
        GG.camera().posY(camera_game_start_pos.val());
        0 => start_depth; 

        // init player
        false => player.dead;
        player_gamestart_pos.val() => player.pos;
        player_base_size.val() => player_size.val;
        player.remakeCollider();
        TileType_Dirt => player.tool;
        b2Body.enable(player.b2_body_id);
        0 => player.animation_time_secs;
        for (int i; i < player.tool_level.size(); ++i) 1 => player.tool_level[i];
        player.tool_exp.zero();
        false => player_exploded;

        player.eggs.zero();
        // true => player.eggs[1];
        // true => player.eggs[EggType_Foot];
        // player.remakeCollider();

        0 => n_coins;

        0 => shake_count;
        0 => death_shake_count;
    }

    eventbox_text.clear();

    init_count++;
}

int draw_all;
int do_ui;

init();

fun void makeBody(vec2 bot_left, vec2 top_right) {
    (top_right.x - bot_left.x) => float w;
    (top_right.y - bot_left.y) => float h;
    (bot_left + top_right) * .5 => vec2 pos;
    p.createBody(
        pos,
        b2BodyType.staticBody, EntityType_Static, 0.0, false, 
        b2.makeBox(w, h)) => int b2_body_id;
    
}

// make start room geometry
makeBody(@(-100, -4), @(-.5, 0));
makeBody(@(.5, -4), @(100, 0));

fun int legal(int r, int c) {
    return (r >= 0 && r < MINE_H.val()) && (c >= 0 && c < MINE_W.val());
}


// wait for init... super jank
repeat(5) GG.nextFrame() => now;

while (1) {
    GG.nextFrame() => now;
    GG.dt() => float dt;
    start_depth - GG.camera().posY() => float depth;

    if (room == Room_Play || room == Room_End) dt +=> gametime;

    if (GWindow.keyDown(GWindow.KEY_GRAVEACCENT)) !do_ui => do_ui;

    // difficulty scaling
    // difficulty incr every N seconds
    (1 + (gametime / seconds_per_level.val())) $ int => difficulty; 

    if (false && do_ui) { // ui
        UI.text("difficulty: " + difficulty);
        UI.text("gametime: " + gametime);
        UI.slider("screen zeno", screen_zeno, 0, 1);
        UI.slider("zeno pos", player_target_pos, -10, 10);

        UI.slider("player speed", player_speed, 0, 10);
        UI.checkbox("draw b2 debug", p.draw_b2_debug);

        UI.checkbox("egg gatcha (show egg type art)", egg_gatcha);

        UI.slider("title size", title_sca, 0, 10);
    }

    // always grass to stop flickering glitch
    g.sprite( grass_sprite, @(0, 20), @(3.62,1), 0 );
    g.sprite( grass_sprite, @(0, 20), @(3.62,1), 0 );
    g.sprite( grass_sprite, @(0, 20), @(3.62,1), 0 );

    if (GG.camera().posY() > - 10) {
        if (GWindow.keyDown(GWindow.KEY_TAB)) {
            tab_rot_spring.pull(.1);
            tab_sca_spring.pull(.1);

            if (player.tool == TileType_Stone) {
                tool1_rot_spring.pull(0.2);
                tool1_sca_spring.pull(0.2);
            }
            if (player.tool == TileType_Dirt) {
                tool2_rot_spring.pull(0.2);
                tool2_sca_spring.pull(0.2);
            }
            if (player.tool == TileType_Wood) {
                tool3_rot_spring.pull(0.2);
                tool3_sca_spring.pull(0.2);
            }
        }

        if (
            GWindow.keyDown(GWindow.KEY_LEFT) ||
            GWindow.keyDown(GWindow.KEY_RIGHT) ||
            GWindow.keyDown(GWindow.KEY_DOWN) ||
            GWindow.keyDown(GWindow.KEY_UP)
        ) {
            wasd_rot_spring.pull(.1);
            wasd_sca_spring.pull(.1);
        }

        wasd_rot_spring.update(dt);
        wasd_sca_spring.update(dt);
        tab_rot_spring.update(dt);
        tab_sca_spring.update(dt);
        
        tool1_rot_spring.update(dt);
        tool1_sca_spring.update(dt);
        tool2_rot_spring.update(dt);
        tool2_sca_spring.update(dt);
        tool3_rot_spring.update(dt);
        tool3_sca_spring.update(dt);



        (now/second) => float t;
        .05 * @( Math.cos(1.7 * t), Math.sin(2.1 * t)) => vec2 delta;
        (2 * (now / second))$int % 2 => int curr_frame;
        g.sprite(
            firefly_sprite, 2, curr_frame,
            delta + @(-4.3, .5), .5 * @(1, 1), 0, Color.WHITE
        );
        if (
            !player.dead && player.pos().x > -4.5 && player.pos().x < -4
            &&
            player.pos().y < 1
        ) { // credits
            1 + .02 * Math.sin(now/second * 1.5) => float credits_sca;
            g.sprite(credits_sprite, @(-4.3, -1.45), 3.0* @(2, 1) * credits_sca, 0);
        }
        
        5 + .03 * Math.sin(now/second * 1.5) => float title_y;
        // 5.2 => float title_y;
        // title.posY(title_y);
        // title.sca(title_sca.val() * @(3.62,1));
        g.sprite( title_sprite, @(0, title_y), title_sca.val() * @(3.62,1), 0 );

        1 + wasd_sca_spring.x => float wasd_sca;
        g.text("move/mine", @(-1.5, 3.4), .5 * wasd_sca, wasd_rot_spring.x);
        g.sprite( wasd_sprite, @(-1.5, 2.5), 1.5 * wasd_sca, wasd_rot_spring.x);

        1 + tab_sca_spring.x => float tab_sca;
        tab_rot_spring.x => float tab_rot;
        g.text("change tool", @(1.5, 3.4), .5 * tab_sca, tab_rot);
        g.text("tab", @(1.5, 2.5), .5 * tab_sca, tab_rot);
        g.sprite( tab_sprite, @(1.5, 2.5), 1.5 * tab_sca, tab_rot);

        1.4 => float spost_sca;
        g.sprite( sign_sprite, @(1, spost_sca * .49 ), spost_sca, 0 );

        // grass
        for (auto gr : grass) {
            g.sprite(
                grass_sprite, 
                gr$vec2, .2 * @(gr.z, 1), 0, Color.WHITE
            );
        }

        // stars
        for (auto star : stars) {
            if (Math.randomf() < .0035) {
                Math.random2f(g.screen_min.x, g.screen_max.x) => float x;
                Math.random2f(2, 7) => float y;
                starTwinkle(@(x, y));
            }
        }

        g.boxFilled(@(0, 0), g.screen_w, .05, Color.WHITE);

        g.pushLayer(.11);
        g.boxFilled(@(.5, -2), .05, 4.025, Color.WHITE);
        g.boxFilled(@(-.5, -2), .05, 4.025, Color.WHITE);
        g.popLayer();

        // cover the worm grass AND the line
        g.pushLayer(.1);
        g.boxFilled(@(0, 0), 1, .25, Color.BLACK);
        g.popLayer();

        // draw mining symbols
        0.5 + .05 * Math.sin(now/second * 1.5) => float tool_sca;
        1 + tool1_sca_spring.x => float tool1_sca;
        1 + tool2_sca_spring.x => float tool2_sca;
        1 + tool3_sca_spring.x => float tool3_sca;
        tool1_rot_spring.x => float tool1_rot;
        tool2_rot_spring.x => float tool2_rot;
        tool3_rot_spring.x => float tool3_rot;
        g.sprite( shovel_sprite, @(1, -.5), tool_sca * tool1_sca, tool1_rot );
        g.sprite( axe_sprite, @(1, -1.5), tool_sca * tool2_sca, tool2_rot );
        g.sprite( pickaxe_sprite, @(1, -2.5), tool_sca * tool3_sca, tool3_rot );

        // lerp camera towards target (after breaking block)
        if (room == Room_Start && player.pos().y < -4) {
            Room_Play => room;
            -12 => GG.camera().posY;
            // g.screenFlash(.5::second);
        }
    }

    // score
    if (room != Room_Start && !player.dead) {
        // g.n2w(.9, 1-(.1*aspect)) => vec2 pos;
        // g.pushTextControlPoint(@(1, 1));
        // g.text("HI " + highscore, pos, .5);
        // g.popTextControlPoint();

        g.n2w(-.9, 1-(.1*aspect)) => vec2 pos;
        g.pushTextControlPoint(@(0, 1));
        g.text(Std.ftoa(depth, 0) + "m", pos - @(.25, 0), .5);
        // .5 -=> pos.y;
        // g.text("L" + difficulty, pos - @(.25, 0), .5);
        g.popTextControlPoint();

        .2 -=> pos.x;
        1 -=> pos.y;
        (gametime / .1)$int % 6 => int curr_frame;
        g.sprite(
            coin_sprite, 6, curr_frame,
            pos, .5 * @(1, 1), 0, Color.WHITE
        );
        g.text(n_coins + "", pos + @(.4, 0), .45);


        // tool exp progress
        progressBar(
            1.0 *  player.tool_exp[player.tool] / player.expToLevel(player.tool),
            pos + @(1.0, .25),
            .1,
            2.0,
            false
        );

        // tool levels
        .5 -=> pos.y;

        .4 + .025 * Math.sin(5 * (now/second)) => float active_tool_sz;

        g.sprite( shovel_sprite, pos, .3, 0 );
        g.text(" L" + player.tool_level[TileType_Dirt], pos + @(.4, 0), .45);
        if (player.tool == TileType_Dirt) g.square(pos, 0, active_tool_sz, Color.WHITE);
        .5 -=> pos.y;
        g.sprite( axe_sprite, pos, .3, 0 );
        g.text(" L" + player.tool_level[TileType_Wood], pos + @(.4, 0), .45);
        if (player.tool == TileType_Wood) g.square(pos, 0, active_tool_sz, Color.WHITE);
        .5 -=> pos.y;
        g.sprite( pickaxe_sprite, pos, .3, 0 );
        g.text(" L" + player.tool_level[TileType_Stone], pos + @(.4, 0), .45);
        if (player.tool == TileType_Stone) g.square(pos, 0, active_tool_sz, Color.WHITE);
    
        // event box
        g.n2w(-.95, 1-(1*aspect)) => pos;

        g.pushLayer(1);
        g.box(pos - @(-1.5, -0.5), 3, 5, Color.WHITE);
        g.popLayer();

        g.pushLayer(0.5);
        g.boxFilled(pos - @(-1.5, 4.375), 3, 5, Color.BLACK);
        g.popLayer();

        g.pushTextControlPoint(@(0, 1));
        g.pushTextMaxWidth(2.75);
        for (int i; i < eventbox_text.size(); ++i) {
            g.text(eventbox_text[i], pos - @(-0.175, -2.85 + 0.75 * (eventbox_text.size() - 1 - i)), .3);
        }
        g.popTextMaxWidth();
        g.popTextControlPoint();

        if (depth < 100 && Math.randomf() < .0003 && random_event_text.size() > 0) {
            Math.random2(0, random_event_text.size()-1) => int randIx;
            addEventText(random_event_text[randIx]);
            random_event_text.erase(randIx);
        }
        if (depth > 100 && Math.randomf() < .0003 && deep_random_event_text.size() > 0) {
            Math.random2(0, deep_random_event_text.size()-1) => int randIx;
            addEventText(deep_random_event_text[randIx]);
            deep_random_event_text.erase(randIx);
        }
    }

    { // egg list
        g.n2w(.92, 1-(.08*aspect)) => vec2 pos;

        // right border
        // .03 => float border_w;
        // .5 * (g.screen_max.y + g.screen_min.y) => float center_y;
        // g.boxFilled(@(MINE_W.val() * .5 + border_w * .5, center_y), 
        // border_w, 1.1 * (g.screen_max.y - g.screen_min.y), Color.WHITE);

        if (!player.dead && room == Room_Play) {
            g.pushTextControlPoint(1, .5);
            for (int egg_type; egg_type < EggType_Count; ++egg_type) {
                if (player.eggs[egg_type]) {
                    g.text(egg_names[egg_type], pos - @(.3, .05), .4);
                    g.sprite( egg_sprites[egg_type], pos, .4, 0 );
                    .5 -=> pos.y;
                }
            }
            g.popTextControlPoint();

            // progress bar
            end_depths[end_depth_ix] => float end_depth;

            .75 * (g.screen_max.y - g.screen_min.y) + g.screen_min.y => pos.y;
            g.text("start", pos, .4);
            .2 -=> pos.y;
            progressBar(
                depth / end_depth,
                pos,
                .1,
                .5 * g.screen_h,
                true
            );
            (.5 * g.screen_h) + .2 -=> pos.y;
            g.text("???", pos, .4);
        }

        // depth markers
        20 => int depth_ival;

        M.nextMult(Math.fabs(depth) $ int, depth_ival) => int next_depth;
        next_depth - depth_ival => int prev_depth;
        @(
            MINE_W.val() * .5,
            start_depth - next_depth
        ) => vec2 depth_marker_pos;
        g.pushTextControlPoint(0, .5);
        g.text(" - "+next_depth+"m -", depth_marker_pos, .5);
        if (prev_depth > 0) g.text(" - "+prev_depth+"m -", depth_marker_pos + @(0, depth_ival), .5);
        g.popTextControlPoint();
    }

    // collision
    player.pos() => vec2 player_pos;
    b2World.contactEvents(p.b2_world_id, p.begin_touch_events, p.end_touch_events, null);
    for (int i; i < p.begin_touch_events.size(); 2 +=> i) {
        p.begin_touch_events[i] => int touch_shape_a;
        p.begin_touch_events[i+1] => int touch_shape_b;
        if (!b2Shape.isValid(touch_shape_a) || !b2Shape.isValid(touch_shape_b)) continue;
        b2Shape.body(touch_shape_a) => int touch_body_id_a;
        b2Shape.body(touch_shape_b) => int touch_body_id_b;
        if (!b2Body.isValid(touch_body_id_a) || !b2Body.isValid(touch_body_id_b)) continue;

        T.assert(
            touch_body_id_a == player.b2_body_id
            ||
            touch_body_id_b == player.b2_body_id,
            "non-player collision"
        ); 

        if (other != null && (touch_body_id_a == other.b2_body_id || touch_body_id_b == other.b2_body_id)) {
            true => newChickenFallen;
        }
        if (other != null && 
            ((touch_body_id_a == other.b2_body_id && touch_body_id_b == player.b2_body_id) || 
            ((touch_body_id_a == player.b2_body_id && touch_body_id_b == other.b2_body_id))) 
        ) {
            true => newChickenPlayerCollision;
        }

        touch_body_id_b => int contact_body_id;
        if (touch_body_id_b == player.b2_body_id) touch_body_id_a => contact_body_id;

        Tile.get(contact_body_id) @=> Tile tile;
        if (tile == null) continue;

        tile.pos() => vec2 tile_pos;

        if (tile.type == TileType_Spike && !player.eggs[EggType_Foot]) {
            die();
            continue;
        }
    }

    b2World.sensorEvents(p.b2_world_id, p.begin_sensor_events, null);
    for (int i; i < p.begin_sensor_events.size(); 2 +=> i) {
        p.begin_sensor_events[i] => int sensor_shape_id;
        p.begin_sensor_events[i+1] => int visitor_shape_id;
        if (!b2Shape.isValid(sensor_shape_id) || !b2Shape.isValid(visitor_shape_id)) continue;
        b2Shape.body(sensor_shape_id) => int sensor_body_id;
        b2Shape.body(visitor_shape_id) => int visitor_body_id;
        if (!b2Body.isValid(sensor_body_id) || !b2Body.isValid(visitor_body_id)) continue;
        T.assert(visitor_body_id == player.b2_body_id, "sensor event with non-player");
        Tile.get(sensor_body_id) @=> Tile tile;

        if (tile.type == TileType_Coin) {
            // TODO: b2 functions should print ck error if passed an invalid body id
            g.score("+" + 1, tile.pos(), .5::second, .5,  0.6);
            n_coins++;

            spork ~ snd.play(
                snd.SOUND_COIN,
                2.0, // gain
                1.0, // rate
                0, // loop
                4 // gridDivision
            );

            tile.empty();
            if (Math.randomf() < .2) addEventText("Your pockets feel heavier.");
        }
    }

    // controls
    if (!player.dead) { 
        if (GWindow.keyDown(GWindow.KEY_UP) || GWindow.keyDown(GWindow.KEY_TAB)) {
            // cycle tools
            if (player.tool == TileType_Stone) TileType_Dirt => player.tool;
            else ++player.tool;

            player.tool_scale_spring.pull(.3);

            spork ~ snd.play(
                snd.SOUND_TOOL_CHANGE,
                2.0, // gain
                1.0, // rate
                0, // loop
                4 // gridDivision
            );
        }

        if (GWindow.key(GWindow.KEY_RIGHT) || GWindow.key(GWindow.KEY_LEFT)) dt +=> player.animation_time_secs;
        if (GWindow.keyDown(GWindow.KEY_RIGHT)) 1 => player.facing;
        if (GWindow.keyDown(GWindow.KEY_LEFT)) -1 => player.facing;

        1.0 => float speed_modifier;
        if (playerEgg) 0 => speed_modifier;
        if (player.eggs[EggType_Juggernaut]) .5 *=> speed_modifier;
        @(
            speed_modifier * player_speed.val() * (
                GWindow.key(GWindow.KEY_RIGHT) - GWindow.key(GWindow.KEY_LEFT)
            ),
            player.vel().y
        ) => player.vel;

        // clamp position to screen
        if (player.pos().y > -3) {
            Math.clampf(player.pos().x, g.screen_min.x, g.screen_max.x) => player.posX;
        } else {
        Math.clampf(player.pos().x, -.5 * MINE_W.val(), .5 * MINE_W.val()) => player.posX;
        }

        // determine grid pos of player
        gridpos(player.pos()) => vec2 gridpos;
        tilepos(gridpos.x $ int, gridpos.y $ int) => vec2 player_tile_pos;

        if (p.draw_b2_debug.val()) g.square(player_tile_pos, 0, 1.0, Color.GREEN);

        // calculate touching tiles
        gridpos.x $ int => int row;
        gridpos.y $ int => int col;


        if (GWindow.keyDown(GWindow.Key_Down) && legal(row+1, col)) {
            tilemap[row+1][col] @=> Tile tile_below;
            M.fract(player.pos().y) => float y;
            if (y < 0) 1 +=> y;
            (y < (.5 * player_size.val())) => int player_on_ground;
            // <<< "here", gridpos, tile_below.hp, player_on_ground, y, player_size.val() >>>;
            if (
                (tile_below.hp > 0) && player_on_ground
            ) {
                // <<< "mining" >>>;
                mine(tile_below, row+1, col, Dir_Down);
            }
        }

        if (GWindow.keyDown(GWindow.Key_Right) && legal(row, col+1)) {
            (player.pos().x - player_tile_pos.x) > (.5 - .5*player_size.val() - .01) => int touching_side;
            tilemap[row][col+1] @=> Tile tile_right;
            if ( (tile_right.hp > 0) && touching_side) {
                mine(tile_right, row, col+1, Dir_Right);
            }
        }

        if (GWindow.keyDown(GWindow.Key_Left) && legal(row, col-1)) {
            (player.pos().x - player_tile_pos.x) < (-.5  + .5 * player_size.val() + .01) => int touching_side;
            // <<< row, col >>>;
            tilemap[row][col-1] @=> Tile tile_left;
            if ((tile_left.hp > 0) && touching_side) {
                mine(tile_left, row, col-1, Dir_Left);
            }
        }
    }

    // shake on falling a large distance (TODO maybe remove this)
    player.vel().y - player.prev_vel.y => float delta;
    if (delta > 8) {
        camera_shake_spring.pull(delta * .05);
        addEventText(pee_text[Math.random2(0, pee_text.size()-1)]);

        spork ~ snd.play(
            Math.random2(snd.SOUND_BAWK0, snd.SOUND_BAWK4),
            4.0, // gain
            1.0, // rate
            0, // loop
            4 // gridDivision
        );

        shake_count++;

        if (shake_count == 1 || shake_count == death_shake_count + 1) {
            bgm_open.play();
        }
        if (shake_count == 2 || shake_count == death_shake_count + 2) {
            bgm_open.stop();
            bgm_play.play();
            snd.syncBeat(now);
        }
        if (ended) {
            bgm_play.stop();
            bgm_open.stop();
            snd.syncBeat(now);
        }
    }

    if (depth >= 100 && !depth100) {
        true => depth100;
        addEventText("100m travelled. It's getting darker.");
    }
    if (depth >= 500 && !depth500) {
        true => depth500;
        addEventText("500m travelled. You're feeling colder.");
    }
    if (depth >= 1000 && !depth1000) {
        true => depth1000;
        addEventText("1000m travelled.");
    }
    
    if (depth > end_depths[end_depth_ix] && room != Room_End) {
        // init room end
        Room_End => room;
    }

    if (room == Room_Play) {
        if (!player.dead) {
            // update camera
            Math.min(.7, camera_speed.val() + .08 * difficulty) => float cam_scroll_speed;
            Math.min(2.25, player_target_pos.val() + .6 * difficulty) => float threshold_pos;

            dt * cam_scroll_speed => float scroll_dist;
            threshold_pos + GG.camera().posY() - player.pos().y => float distance_from_threshold; 
            Math.max(0, distance_from_threshold) * screen_zeno.val() +=> scroll_dist;
            GG.camera().translateY(-scroll_dist);

            // death condition
            if (gametime > 3 && room == Room_Play && player.pos().y > GG.camera().posY() + 5) {
                die();
            }

            // spawn more blocks 
            scroll_dist -=> spawn_dist;
            while (spawn_dist < 0) {
                shift();
                1.0 +=> spawn_dist;
            }
        } 
        // game end camera
        else {
            if (gametime - death_time > 1.0 && !player_exploded) {
                true => player_exploded;

                spork ~ snd.play(
                    snd.SOUND_DEATH,
                    16.0, // gain
                    1.0, // rate
                    0, // loop
                    4 // gridDivision
                );

                g.explode(player.pos(), 5, 3::second, Color.WHITE, 0, Math.two_pi, ExplodeEffect.Shape_Squares);
            }

            if (gametime - death_time > 2.0) {
                camera_game_start_pos.val() - GG.camera().posY() => float distance_from_start; 
                distance_from_start * screen_zeno.val() * .6 => float scroll_amt;
                GG.camera().translateY(scroll_amt);

                // reverse!
                bgm_play.buffy.gain(.9);
                bgm_play.buffy.rate(-2 * scroll_amt);

                // if close to start, revert to start.
                if (distance_from_start < .01) {
                    Room_Start => room;
                    init();
                }

                // draw tile history (incomplete, doesn't draw egg)
                for (auto h : history) {
                    h $ vec2 => vec2 pos;
                    h.z $ int => int type;

                    // skip if offscreen
                    if (
                        h.y > g.screen_max.y + .5
                        ||
                        h.y < g.screen_min.y - .5
                    ) continue;


                    if (type == TileType_Coin) {
                        (gametime / .1)$int % 6 => int curr_frame; 
                        g.sprite(
                            coin_sprite, 6, curr_frame,
                            pos, .9 * @(1, 1), 0, Color.WHITE
                        );
                    }
                    else if (type == TileType_Spike) {
                        (gametime / .075) $ int % 12 => int curr_frame; 
                        g.sprite(
                            spike_sprite, 12, curr_frame,
                            pos, @(1,1), 0, Color.WHITE
                        );
                    }
                    else if (type == TileType_Obsidian) {
                        g.sprite( obsidian_sprite, pos, (15.0/16), 0);
                    }
                    else if (type >= TileType_Dirt && type <= TileType_Stone) {
                        g.sprite( tile_textures[type][0], pos, 15.0/16.0, 0 );
                    }
                }
            }
        }
    } 
    else if (room == Room_End) { // if end screen
        player_target_pos.val() + GG.camera().posY() - player.pos().y => float distance_from_threshold; 
        Math.max(0, distance_from_threshold) * screen_zeno.val() => float scroll_dist;
        GG.camera().translateY(-scroll_dist);

        if (player.pos().y <= g.screen_min.y && !ended) {
            true => ended;
            repeat(9) {
                shiftEmpty();
            }
            shiftEggMiddle();
            repeat(3) {
                shiftAllType(TileType_Dirt);
            }
        }

        // star in da cave
        if (ended) {
            for (auto star : stars) {
                if (Math.randomf() < .005) {
                    Math.random2f(g.screen_min.x, g.screen_max.x) => float x;
                    Math.random2f(g.screen_min.y + 5, g.screen_max.y) => float y;
                    starTwinkle(@(x, y));
                }
            }
        }
    }


    g.pushLayer(1); if (!player_exploded) { // draw player
        (player.animation_time_secs / .05) $ int % 4 => int curr_frame;
        if (!playerEgg) {
            g.sprite(
                chicken_sprite, 4, curr_frame,
                player.pos(), player_size.val() * @(player.facing, 1), 0, Color.WHITE
            );

            // g.circleFilled(player.pos(), .25, tile_colors[player.tool]);
        
            // debug draw neighbording
            if (p.draw_b2_debug.val()) {
                if (player.tile_left != null) g.circle(player.tile_left.pos(), .1, Color.WHITE);
                if (player.tile_right != null) g.circle(player.tile_right.pos(), .1, Color.WHITE);
                if (player.tile_down != null) g.circle(player.tile_down.pos(), .1, Color.WHITE);
            }

            // draw tool
            player.tool_scale_spring.x + 1 => float tool_sca;
            g.sprite( tile_tools[player.tool], player.pos() + @(0,.0), tool_sca * .5 * @(-player.facing, 1), 0, Color.WHITE);
        } else {
            // gridpos.x $ int => int row;
            // gridpos.y $ int => int col;
            // tilemap[row][col+1] @=> Tile tile_right;
            // tilemap[row][col-1] @=> Tile tile_left;
            // tilemap[row+1][col] @=> Tile tile_down;

            // Tile @ tile;
            // if (tile_left != null && tile_left.type == TileType_Egg) tile_left @=> tile;
            // if (tile_right != null && tile_right.type == TileType_Egg) tile_right @=> tile;
            // if (tile_down != null && tile_down.type == TileType_Egg) tile_down @=> tile;
            g.sprite(
                egg_sprite, 5, lastEggFrame,
                player.pos(), (15.0/16) * @(1,1), 0, Color.WHITE
            );
            
            if (newChicken) {
                (other.animation_time_secs / .05) $ int % 4 => int curr_frame;
                g.sprite(
                    chicken_sprite, 4, curr_frame,
                    other.pos(), player_base_size.val() * @(other.facing, 1), 0, Color.WHITE
                );
                other.tool_scale_spring.x + 1 => float tool_sca;
                g.sprite( tile_tools[other.tool], other.pos() + @(0,.0), tool_sca * .5 * @(-other.facing, 1), 0, Color.WHITE);
            }
        }
    } g.popLayer();

    // update and draw tiles
    for (int row; row < MINE_H.val(); row++) {
        for (int col; col < MINE_W.val(); col++) {
            tilemap[row][col] @=> Tile tile;
            tilepos(row, col) => vec2 pos;

            // update springs
            tile.rotation_spring.update(dt);
            tile.translation_spring.update(dt);
            tile.egg_price_spring.update(dt);

            // g.square(pos, 0, 1.0, Color.WHITE);
            if (tile.type == TileType_Coin) {
                (gametime / .1)$int % 6 => int curr_frame; 
                g.sprite(
                    coin_sprite, 6, curr_frame,
                    tile.pos(), .9 * @(1, 1), 0, Color.WHITE
                );
            }
            else if (tile.type == TileType_Spike) {
                // old spike programmer art
                // pos - @(.5, .5) => vec2 p;
                // .33 / 2 +=> p.x;
                // repeat (3) {
                //     tri(p, .33, .5);
                //     .33 +=> p.x;
                // }

                (gametime / .075) $ int % 12 => int curr_frame; 
                g.sprite(
                    spike_sprite, 12, curr_frame,
                    tile.pos(), @(1,1), 0, Color.WHITE
                );
            }
            else if (tile.type == TileType_Obsidian) {
                g.sprite( obsidian_sprite, pos, (15.0/16), 0);
            }
            else if (tile.type == TileType_Egg) {
                // .05 * M.rot2vec(gametime * 3) => vec2 delta;
                @(0,0) => vec2 delta;
                tile.pos() + delta => vec2 pos;
                if (tile.cost_to_unlock > 0) { // still not bought
                    g.sprite(
                        egg_lock_sprite, 2, 0,
                        pos, 1.0 * @(1,1), 0, Color.WHITE
                    );

                    .5 * tile.egg_price_spring.x => float sca;

                    (gametime / .1)$int % 6 => int curr_frame; 
                    g.sprite(
                        coin_sprite, 6, curr_frame,
                        pos - @(-.08, .1), (.16 + 0) * @(1, 1), 0, Color.WHITE
                    );
                    g.pushColor(Color.WHITE);
                    g.text(tile.cost_to_unlock + "", pos - @(.08, .1), (.3 - sca));
                    g.popColor();
                } 
                else if (tile.cost_to_unlock == 0 && tile.hp == tile.max_hp) {
                    g.sprite(
                        egg_lock_sprite, 2, 1,
                        pos, 1.0 * @(1,1), 0, Color.WHITE
                    );
                } else {
                    1.0 * tile.hp / tile.max_hp => float perc_health;
                    ((1 - perc_health) * 4) $ int => int frame;

                    0.8 * tile.rotation_spring.x => float rot;
                    @(0, 1.5 * tile.translation_spring.x) + tile.pos() => vec2 pos;
                    g.sprite(
                        egg_sprite, 5, frame,
                        pos, (15.0/16) * @(1,1), rot, Color.WHITE
                    );

                    // egg type mask
                    if (!egg_gatcha.val() && egg_sprites[tile.egg_type] != null) {
                        g.pushLayer(.5); g.pushBlend(g.BLEND_MULT);
                        g.sprite( egg_sprites[tile.egg_type], pos, 15.0/16.0, rot );
                        g.popBlend(); g.popLayer();
                    }
                }
            }
            else if (tilemap[row][col].hp != 0 || draw_all) {
                // display hp
                // g.pushColor(Color.WHITE);
                // g.text("" + tilemap[row][col].hp, pos, .5);
                // g.popColor();

                0.8 * tile.rotation_spring.x => float rot;
                1.5 * tile.translation_spring.x +=> pos.y;

                1.0 * tile.hp / tile.max_hp => float perc_health;

                ((1 - perc_health) * tile_textures[tile.type].size()) $ int => int tex_idx;

                // g.sprite( tile_textures[tile.type][0], pos, 16/16.0, rot );
                g.sprite( tile_textures[tile.type][tex_idx], pos, 15.0/16.0, rot );
            //    g.square( pos, 0, 1.0, Color.WHITE);
            //    g.squareFilled( pos, 0, 1.0, Color.WHITE);
            }

        }
    }

    { // cleanup
        // physics debug draw
        if (p.draw_b2_debug.val()) b2World.draw(p.b2_world_id, p.debug_draw);
        p.debug_draw.update();

        // springs
        camera_shake_spring.update(dt);
        camera_shake_spring.x => GG.camera().posX;

        // player
        player.vel() => player.prev_vel;
        player.tool_scale_spring.update(dt);
    }

    if (death_sequence) { // death
        false => death_sequence;
        bgm_play.stop();
        bgm_open.stop();
        true => player.dead;
        b2Body.disable(player.b2_body_id);

        // Math.max(score, highscore) => highscore;
        // GG.camera().posY(0);
    }
}