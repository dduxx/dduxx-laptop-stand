include <../utils/keystone.scad>
include <../utils/const.scad>
include <../utils/screw.scad>
include <../utils/laptop.scad>

CORNER_BLOCK = 15;

NUMBER_OF_JACKS = 6;

CABLE_HOLE_X = 15;
CABLE_HOLE_Y = 30;

AIRFLOW_HOLE_RAD = 4;
AIRFLOW_HOLE_FACES = 6;
AIRFLOW_HOLE_BUFFER = 2;

ARM_HEIGHT = 60;
ARM_WIDTH_FACTOR = 6;
ARM_DEPTH = 25;
ARM_EDGE_OFFSET = 30;

ARM_BASE_WIDTH = 36;

STAND_ARM_POINTS = [
    [0, 0],
    [ARM_BASE_WIDTH, 0],
    [ARM_BASE_WIDTH - (ARM_BASE_WIDTH/ARM_WIDTH_FACTOR), ARM_HEIGHT],
    [(ARM_BASE_WIDTH/ARM_WIDTH_FACTOR), ARM_HEIGHT]
];

module corner_block() {
    difference() {
        linear_extrude(ENCLOSURE_Z)
        minkowski() {
            square([CORNER_BLOCK - (2*FILLET_RAD), CORNER_BLOCK - (2*FILLET_RAD)], center=true);

            circle(r=FILLET_RAD);
        }

        cylinder(h=ENCLOSURE_Z, r=1.6);
    }
}

module airflow() {
    max_distance = (ENCLOSURE_Y - (2* CORNER_BLOCK));
    num_holes = floor(max_distance / ((AIRFLOW_HOLE_RAD * 2) + AIRFLOW_HOLE_BUFFER));
    
    translate([0, -(max_distance / 2) + (2 * AIRFLOW_HOLE_BUFFER) + (AIRFLOW_HOLE_BUFFER/2), AIRFLOW_HOLE_RAD])
    rotate([90, 0, 90])
    for (i = [0 : 2]) {
        for (j = [0 : i % 2 ? num_holes - 2 : num_holes - 1]) {
            additional_offset = i % 2 ? AIRFLOW_HOLE_RAD : 0;
            translate([
                j * ((2*AIRFLOW_HOLE_RAD) + AIRFLOW_HOLE_BUFFER) + additional_offset, 
                i * ((2*AIRFLOW_HOLE_RAD) + AIRFLOW_HOLE_BUFFER), 
                0
            ])
            cylinder(r1=AIRFLOW_HOLE_RAD, r2=AIRFLOW_HOLE_RAD, h=WALL, $fn=AIRFLOW_HOLE_FACES);
        }
    }

}

module enclosure_base() {
    difference() {
        linear_extrude(ENCLOSURE_Z)
        minkowski() {
            square([ENCLOSURE_X - (2*FILLET_RAD), ENCLOSURE_Y - (2*FILLET_RAD)], center=true);

            circle(r=FILLET_RAD);
        }

        translate([0, 0, WALL])
        linear_extrude(ENCLOSURE_Z - WALL)
        minkowski() {
            square([ENCLOSURE_X - (2*FILLET_RAD) - (2 * WALL), ENCLOSURE_Y - (2*FILLET_RAD) - (2 * WALL)], center=true);

            circle(r=FILLET_RAD);
        }

        translate([0, (ENCLOSURE_Y/2) - WALL, WALL + 5])
        keystone_panel_cutout(NUMBER_OF_JACKS,  WALL + WALL);

        translate([-ENCLOSURE_X/2, 0, WALL + AIRFLOW_HOLE_BUFFER])
        airflow();

        translate([(ENCLOSURE_X/2) - WALL, 0, WALL + AIRFLOW_HOLE_BUFFER])
        airflow();
    }

    translate([0, (ENCLOSURE_Y/2) - KEYSTONE_CUTOUT_Z, WALL + 5])
    keystone_panel(NUMBER_OF_JACKS);

    translate([ENCLOSURE_X/2 - CORNER_BLOCK/2 , ENCLOSURE_Y/2 - CORNER_BLOCK/2, 0])
    corner_block();

    translate([-ENCLOSURE_X/2 + CORNER_BLOCK/2 , ENCLOSURE_Y/2 - CORNER_BLOCK/2, 0])
    corner_block();

    translate([-ENCLOSURE_X/2 + CORNER_BLOCK/2 , -ENCLOSURE_Y/2 + CORNER_BLOCK/2, 0])
    corner_block();

    translate([ENCLOSURE_X/2 - CORNER_BLOCK/2 , -ENCLOSURE_Y/2 + CORNER_BLOCK/2, 0])
    corner_block();
}

module stand_arms() {
    cutout_width = LAPTOP_HEIGHT * (1 + (LAPTOP_THICKNESS_BUFFER_PERCENT/100));
    
    translate([0, ARM_DEPTH/2, 0])
    rotate([90, 0, 0])
    linear_extrude(ARM_DEPTH)
    difference() {
        translate([-ARM_BASE_WIDTH/2, 0, 0])
        polygon(STAND_ARM_POINTS);

        translate([-cutout_width/2, 0, 0])
        square([cutout_width, ARM_HEIGHT]);
    }
}

module enclosure_lid() {
    difference() {
        linear_extrude(WALL)
        minkowski() {
            square([ENCLOSURE_X - (2*FILLET_RAD), ENCLOSURE_Y - (2*FILLET_RAD)], center=true);

            circle(r=FILLET_RAD);
        }

        translate([ENCLOSURE_X/2 - CORNER_BLOCK/2 , ENCLOSURE_Y/2 - CORNER_BLOCK/2, 2])
        screw_cutout(SCREW_HEAD_RAD, SCREW_HEAD_HEIGHT, SCREW_M3_RAD, SCREW_SHANK_HEIGHT);

        translate([-ENCLOSURE_X/2 + CORNER_BLOCK/2 , ENCLOSURE_Y/2 - CORNER_BLOCK/2, 2])
        screw_cutout(SCREW_HEAD_RAD, SCREW_HEAD_HEIGHT, SCREW_M3_RAD, SCREW_SHANK_HEIGHT);

        translate([-ENCLOSURE_X/2 + CORNER_BLOCK/2 , -ENCLOSURE_Y/2 + CORNER_BLOCK/2, 2])
        screw_cutout(SCREW_HEAD_RAD, SCREW_HEAD_HEIGHT, SCREW_M3_RAD, SCREW_SHANK_HEIGHT);

        translate([ENCLOSURE_X/2 - CORNER_BLOCK/2 , -ENCLOSURE_Y/2 + CORNER_BLOCK/2, 2])
        screw_cutout(SCREW_HEAD_RAD, SCREW_HEAD_HEIGHT, SCREW_M3_RAD, SCREW_SHANK_HEIGHT);

        translate([(ARM_BASE_WIDTH/2) + CABLE_HOLE_X/2 + WALL, (-ENCLOSURE_Y/2) + (CABLE_HOLE_Y/2) + WALL, 0])
        linear_extrude(WALL)
        minkowski() {
            square([CABLE_HOLE_X - (2*FILLET_RAD), CABLE_HOLE_Y - (2*FILLET_RAD)], center=true);

            circle(FILLET_RAD);
        }

        translate([(ARM_BASE_WIDTH/2) + CABLE_HOLE_X/2 + WALL, (ENCLOSURE_Y/2) - (CABLE_HOLE_Y/2) - WALL, 0])
        linear_extrude(WALL)
        minkowski() {
            square([CABLE_HOLE_X - (2*FILLET_RAD), CABLE_HOLE_Y - (2*FILLET_RAD)], center=true);

            circle(FILLET_RAD);
        }
    }

    translate([0, -ENCLOSURE_Y/2 + ARM_DEPTH/2 + ARM_EDGE_OFFSET, WALL])
    stand_arms();
    translate([0, ENCLOSURE_Y/2 - ARM_DEPTH/2 - ARM_EDGE_OFFSET, WALL])
    stand_arms();
}