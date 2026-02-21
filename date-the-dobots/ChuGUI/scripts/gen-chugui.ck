@import "../src/ChuGUI.ck"
@import "../src/UIStyle.ck"

// instantiate a CKDoc object
CKDoc doc; // documentation orchestra
// set the examples root
"../src/examples/" => doc.examplesRoot;

// add group
doc.addGroup(
    // class names
    [
        "ChuGUI"
    ],
    // group name
    "Components",
    // file name
    "components",
    // group description
    "ChuGUI's components."
);

// add group
doc.addGroup(
    // class names
    [
        "UIStyle"
    ],
    // group name
    "Styling",
    // file name
    "styling", 
    // group description
    "ChuGUI's styling system."
);

// sort for now until order is preserved by CKDoc
doc.sort(true);

// generate
doc.outputToDir("../../../ccrma/home/Web/ChuGUI/api/", "ChuGUI API Reference (v" + ChuGUI.version + ")");
