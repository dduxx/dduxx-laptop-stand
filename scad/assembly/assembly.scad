include <../stand/base.scad>
include <../stand/stand.scad>

RENDER_FUNCTION="render_all";
START_POINT = 25;

module render_base() {
    enclosure_base();
}

module render_lid() {
    translate([0, 0, ENCLOSURE_Z + START_POINT])
    enclosure_lid();
}

module render_stand() {
    translate([0, 0, ENCLOSURE_Z + (2 * START_POINT) + 2])
    stand();
}

module render_all() {
    render_stand();
    render_lid();
    render_base();
}

if (RENDER_FUNCTION == "render_all") {
    render_all();
} else if (RENDER_FUNCTION == "render_stand") {
    render_stand();
} else if (RENDER_FUNCTION == "render_lid") {
    render_lid();
} else if (RENDER_FUNCTION == "render_base") {
    render_base();
} else {
    echo(RENDER_FUNCTION, "is not a supported render function");
}