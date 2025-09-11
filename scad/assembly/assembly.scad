include <../stand/base.scad>
include <../stand/stand.scad>
include <../utils/laptop.scad>

START_POINT = 25;

module render_base() {
    enclosure_base();
}

module render_lid() {
    translate([0, 0, ENCLOSURE_Z + START_POINT])
    enclosure_lid();
}

module render_stand() {
    translate([0, 0, ENCLOSURE_Z + (2 * START_POINT)])
    stand();
}

module render_all() {
    render_stand();
    render_lid();
    render_base();
}

module render_demo() {
    translate([-LAPTOP_HEIGHT/2, -LAPTOP_WIDTH/2, ENCLOSURE_Z + WALL + 1])
    rotate([90, 0, 90])
    laptop();

    translate([0, 0, ENCLOSURE_Z + 1])
    stand();

    translate([0, 0, ENCLOSURE_Z])
    enclosure_lid();

    enclosure_base();
}