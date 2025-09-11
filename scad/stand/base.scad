include <./stand.scad>
include <../utils/keystone.scad>
include <../utils/const.scad>

CORNER_BLOCK = 15;

NUMBER_OF_JACKS = 6;

CABLE_HOLE_X = 15;
CABLE_HOLE_Y = 30;

AIRFLOW_HOLE_RAD = 4;
AIRFLOW_HOLE_FACES = 6;
AIRFLOW_HOLE_BUFFER = 2;

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

module enclosure_lid() {
    difference() {
        linear_extrude(WALL)
        minkowski() {
            square([ENCLOSURE_X - (2*FILLET_RAD), ENCLOSURE_Y - (2*FILLET_RAD)], center=true);

            circle(r=FILLET_RAD);
        }

        translate([0, 0, WALL/2])
        linear_extrude(WALL)
        minkowski() {
            square(
                [
                    STAND_BASE_X - (2*FILLET_RAD) + 1, 
                    ENCLOSURE_Y - (2*FILLET_RAD) + 1
                ], 
                center=true
            );

            circle(FILLET_RAD);
        }

        translate([0, 0, 3])
        rotate([0, 180, 0])
        union() {
            translate([-(STAND_BASE_X/2) + SCREW_EDGE_OFFSET, -ENCLOSURE_Y/2 + SCREW_EDGE_OFFSET, 2])
            screw_cutout(SCREW_HEAD_RAD, SCREW_HEAD_HEIGHT, SCREW_M3_RAD, SCREW_SHANK_HEIGHT);

            translate([(STAND_BASE_X/2) - SCREW_EDGE_OFFSET, -ENCLOSURE_Y/2 + SCREW_EDGE_OFFSET, 2])
            screw_cutout(SCREW_HEAD_RAD, SCREW_HEAD_HEIGHT, SCREW_M3_RAD, SCREW_SHANK_HEIGHT);

            translate([-(STAND_BASE_X/2) + SCREW_EDGE_OFFSET, ENCLOSURE_Y/2 - SCREW_EDGE_OFFSET, 2])
            screw_cutout(SCREW_HEAD_RAD, SCREW_HEAD_HEIGHT, SCREW_M3_RAD, SCREW_SHANK_HEIGHT);

            translate([(STAND_BASE_X/2) - SCREW_EDGE_OFFSET, ENCLOSURE_Y/2 - SCREW_EDGE_OFFSET, 2])
            screw_cutout(SCREW_HEAD_RAD, SCREW_HEAD_HEIGHT, SCREW_M3_RAD, SCREW_SHANK_HEIGHT);
        }

        translate([ENCLOSURE_X/2 - CORNER_BLOCK/2 , ENCLOSURE_Y/2 - CORNER_BLOCK/2, 2])
        screw_cutout(SCREW_HEAD_RAD, SCREW_HEAD_HEIGHT, SCREW_M3_RAD, SCREW_SHANK_HEIGHT);

        translate([-ENCLOSURE_X/2 + CORNER_BLOCK/2 , ENCLOSURE_Y/2 - CORNER_BLOCK/2, 2])
        screw_cutout(SCREW_HEAD_RAD, SCREW_HEAD_HEIGHT, SCREW_M3_RAD, SCREW_SHANK_HEIGHT);

        translate([-ENCLOSURE_X/2 + CORNER_BLOCK/2 , -ENCLOSURE_Y/2 + CORNER_BLOCK/2, 2])
        screw_cutout(SCREW_HEAD_RAD, SCREW_HEAD_HEIGHT, SCREW_M3_RAD, SCREW_SHANK_HEIGHT);

        translate([ENCLOSURE_X/2 - CORNER_BLOCK/2 , -ENCLOSURE_Y/2 + CORNER_BLOCK/2, 2])
        screw_cutout(SCREW_HEAD_RAD, SCREW_HEAD_HEIGHT, SCREW_M3_RAD, SCREW_SHANK_HEIGHT);

        translate([(STAND_BASE_X/2) + CABLE_HOLE_X/2 + WALL, (-ENCLOSURE_Y/2) + (CABLE_HOLE_Y/2) + WALL, 0])
        linear_extrude(WALL)
        minkowski() {
            square([CABLE_HOLE_X - (2*FILLET_RAD), CABLE_HOLE_Y - (2*FILLET_RAD)], center=true);

            circle(FILLET_RAD);
        }

        translate([(STAND_BASE_X/2) + CABLE_HOLE_X/2 + WALL, (ENCLOSURE_Y/2) - (CABLE_HOLE_Y/2) - WALL, 0])
        linear_extrude(WALL)
        minkowski() {
            square([CABLE_HOLE_X - (2*FILLET_RAD), CABLE_HOLE_Y - (2*FILLET_RAD)], center=true);

            circle(FILLET_RAD);
        }
    }
}