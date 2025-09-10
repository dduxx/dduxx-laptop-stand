include <../utils/laptop.scad>
include <../utils/screw.scad>
include <../utils/const.scad>

LAPTOP_THICKNESS_BUFFER_PERCENT = 5;

STAND_BASE_X = 36;

ARM_HEIGHT = 60;
ARM_WIDTH_FACTOR = 6;
ARM_DEPTH = 25;
ARM_EDGE_OFFSET = 30;

STAND_ARM_POINTS = [
    [0, 0],
    [STAND_BASE_X, 0],
    [STAND_BASE_X - (STAND_BASE_X/ARM_WIDTH_FACTOR), ARM_HEIGHT],
    [(STAND_BASE_X/ARM_WIDTH_FACTOR), ARM_HEIGHT]
];

function scale_factor(percent) = 1 + (percent / 100);
function scaled_amount(height, percent) = height * scale_factor(percent);

module stand_arms() {
    cutout_width = scaled_amount(LAPTOP_HEIGHT, LAPTOP_THICKNESS_BUFFER_PERCENT);
    
    translate([0, ARM_DEPTH/2, 0])
    rotate([90, 0, 0])
    linear_extrude(ARM_DEPTH)
    difference() {
        translate([-STAND_BASE_X/2, 0, 0])
        polygon(STAND_ARM_POINTS);

        translate([-cutout_width/2, 0, 0])
        square([cutout_width, ARM_HEIGHT]);
    }
}

module stand_base() {
    translate([-STAND_BASE_X/2, -ENCLOSURE_Y/2, 0])
    translate([FILLET_RAD, FILLET_RAD, 0])
    linear_extrude(WALL)
    minkowski() {
        square([
            STAND_BASE_X - (2 * FILLET_RAD),
            ENCLOSURE_Y - (2 * FILLET_RAD)
        ]);

        circle(FILLET_RAD);
    }
}

module stand() {
    difference() {
        union() {
            translate([0, -ENCLOSURE_Y/2 + ARM_DEPTH/2 + ARM_EDGE_OFFSET, WALL])
            stand_arms();
            translate([0, ENCLOSURE_Y/2 - ARM_DEPTH/2 - ARM_EDGE_OFFSET, WALL])
            stand_arms();
            stand_base();
        }

        translate([-(STAND_BASE_X/2) + SCREW_EDGE_OFFSET, -ENCLOSURE_Y/2 + SCREW_EDGE_OFFSET, 2])
        screw_cutout(SCREW_HEAD_RAD, SCREW_HEAD_HEIGHT, SCREW_M3_RAD, SCREW_SHANK_HEIGHT);

        translate([(STAND_BASE_X/2) - SCREW_EDGE_OFFSET, -ENCLOSURE_Y/2 + SCREW_EDGE_OFFSET, 2])
        screw_cutout(SCREW_HEAD_RAD, SCREW_HEAD_HEIGHT, SCREW_M3_RAD, SCREW_SHANK_HEIGHT);

        translate([-(STAND_BASE_X/2) + SCREW_EDGE_OFFSET, ENCLOSURE_Y/2 - SCREW_EDGE_OFFSET, 2])
        screw_cutout(SCREW_HEAD_RAD, SCREW_HEAD_HEIGHT, SCREW_M3_RAD, SCREW_SHANK_HEIGHT);

        translate([(STAND_BASE_X/2) - SCREW_EDGE_OFFSET, ENCLOSURE_Y/2 - SCREW_EDGE_OFFSET, 2])
        screw_cutout(SCREW_HEAD_RAD, SCREW_HEAD_HEIGHT, SCREW_M3_RAD, SCREW_SHANK_HEIGHT);
    }
}
