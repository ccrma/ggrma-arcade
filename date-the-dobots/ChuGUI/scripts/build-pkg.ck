@import "Chumpinate"
@import "../src/ChuGUI.ck"

// instantiate a Chumpinate package
Package pkg("ChuGUI");

// add our metadata here
["Ben Hoang"] => pkg.authors;

"https://ccrma.stanford.edu/~hoangben/ChuGUI/" => pkg.homepage;
"https://github.com/Oran2009/ChuGUI/" => pkg.repository;

"ChuGUI is a flexible immediate-mode 2D GUI toolkit for ChuGL." => pkg.description;
"MIT" => pkg.license;

["GUI", "immediate-mode", "2D", "UI", "ChuGL", "ChuGUI"] => pkg.keywords;

"./" => pkg.generatePackageDefinition;

PackageVersion ver("ChuGUI", ChuGUI.version);

"1.5.5.0" => ver.languageVersionMin;

"any" => ver.os;
"all" => ver.arch;

ver.addFile("../src/assets/icons/arrow-down.png", "assets/icons");
ver.addFile("../src/assets/icons/arrow-left.png", "assets/icons");
ver.addFile("../src/assets/icons/arrow-right.png", "assets/icons");
ver.addFile("../src/assets/icons/arrow-up.png", "assets/icons");
ver.addFile("../src/assets/icons/check.png", "assets/icons");
ver.addFile("../src/assets/icons/gear.png", "assets/icons");
ver.addFile("../src/assets/icons/magnifying-glass.png", "assets/icons");
ver.addFile("../src/assets/icons/minus.png", "assets/icons");
ver.addFile("../src/assets/icons/plus.png", "assets/icons");
ver.addFile("../src/assets/icons/user.png", "assets/icons");
ver.addFile("../src/assets/icons/x.png", "assets/icons");

ver.addFile("../src/components/Button.ck", "components");
ver.addFile("../src/components/Checkbox.ck", "components");
ver.addFile("../src/components/ColorPicker.ck", "components");
ver.addFile("../src/components/Dropdown.ck", "components");
ver.addFile("../src/components/Icon.ck", "components");
ver.addFile("../src/components/Input.ck", "components");
ver.addFile("../src/components/Knob.ck", "components");
ver.addFile("../src/components/Label.ck", "components");
ver.addFile("../src/components/Meter.ck", "components");
ver.addFile("../src/components/Radio.ck", "components");
ver.addFile("../src/components/Rect.ck", "components");
ver.addFile("../src/components/Slider.ck", "components");
ver.addFile("../src/components/Spinner.ck", "components");

ver.addFile("../src/gmeshes/GIcon.ck", "gmeshes");
ver.addFile("../src/gmeshes/GRect.ck", "gmeshes");

ver.addFile("../src/lib/Cache.ck", "lib");
ver.addFile("../src/lib/GComponent.ck", "lib");
ver.addFile("../src/lib/MouseState.ck", "lib");
ver.addFile("../src/lib/UIGlobals.ck", "lib");
ver.addFile("../src/lib/UIUtil.ck", "lib");
ver.addFile("../src/lib/ComponentStyleMap.ck", "lib");
ver.addFile("../src/lib/DebugStyles.ck", "lib");

ver.addFile("../src/materials/RectMaterial.ck", "materials");

ver.addFile("../src/ChuGUI.ck");
ver.addFile("../src/UIStyle.ck");

ver.addExampleFile("../src/examples/components/button/basic.ck", "components/button");
ver.addExampleFile("../src/examples/components/button/style.ck", "components/button");
ver.addExampleFile("../src/examples/components/checkbox/basic.ck", "components/checkbox");
ver.addExampleFile("../src/examples/components/checkbox/style.ck", "components/checkbox");
ver.addExampleFile("../src/examples/components/colorpicker/basic.ck", "components/colorpicker");
ver.addExampleFile("../src/examples/components/dropdown/basic.ck", "components/dropdown");
ver.addExampleFile("../src/examples/components/input/basic.ck", "components/input");
ver.addExampleFile("../src/examples/components/input/style.ck", "components/input");
ver.addExampleFile("../src/examples/components/knob/basic.ck", "components/knob");
ver.addExampleFile("../src/examples/components/knob/style.ck", "components/knob");
ver.addExampleFile("../src/examples/components/meter/basic.ck", "components/meter");
ver.addExampleFile("../src/examples/components/meter/style.ck", "components/meter");
ver.addExampleFile("../src/examples/components/radio/basic.ck", "components/radio");
ver.addExampleFile("../src/examples/components/slider/basic.ck", "components/slider");
ver.addExampleFile("../src/examples/components/slider/style.ck", "components/slider");
ver.addExampleFile("../src/examples/components/spinner/basic.ck", "components/spinner");

ver.addExampleFile("../src/examples/components/icon/basic.ck", "components/icon");
ver.addExampleFile("../src/examples/components/icon/icons/acorn.png", "components/icon/icons");
ver.addExampleFile("../src/examples/components/icon/icons/bell.png", "components/icon/icons");
ver.addExampleFile("../src/examples/components/icon/icons/chuck.png", "components/icon/icons");
ver.addExampleFile("../src/examples/components/icon/icons/cookie.png", "components/icon/icons");
ver.addExampleFile("../src/examples/components/icon/icons/heart.png", "components/icon/icons");
ver.addExampleFile("../src/examples/components/icon/icons/music-note.png", "components/icon/icons");
ver.addExampleFile("../src/examples/components/icon/icons/smiley.png", "components/icon/icons");
ver.addExampleFile("../src/examples/components/icon/icons/star.png", "components/icon/icons");

ver.addExampleFile("../src/examples/hud/hud.ck", "hud");
ver.addExampleFile("../src/examples/hud/assets/bed.png", "hud/assets");
ver.addExampleFile("../src/examples/hud/assets/cloud-lightning.png", "hud/assets");
ver.addExampleFile("../src/examples/hud/assets/fire.png", "hud/assets");
ver.addExampleFile("../src/examples/hud/assets/hand-fist.png", "hud/assets");
ver.addExampleFile("../src/examples/hud/assets/heartbeat.png", "hud/assets");
ver.addExampleFile("../src/examples/hud/assets/paw-print.png", "hud/assets");
ver.addExampleFile("../src/examples/hud/assets/sword.png", "hud/assets");
ver.addExampleFile("../src/examples/hud/assets/syringe.png", "hud/assets");
ver.addExampleFile("../src/examples/hud/assets/tornado.png", "hud/assets");

ver.addExampleFile("../src/examples/debug/debug_test.ck", "debug");

// wrap up all our files into a zip file, and tell Chumpinate what URL
// this zip file will be located at.
ver.generateVersion("../releases/" + ver.version(), "ChuGUI", "https://ccrma.stanford.edu/~hoangben/ChuGUI/releases/" + ver.version() + "/ChuGUI.zip");

ver.generateVersionDefinition("ChuGUI", "./");