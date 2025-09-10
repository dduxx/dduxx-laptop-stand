KEYSTONE_CUTOUT_X = 17.7;
KEYSTONE_CUTOUT_Y = 25;
KEYSTONE_CUTOUT_Z = 11.5;

function calculate_keystone_panel_width(jacks) = jacks * KEYSTONE_CUTOUT_X;

module keystone_panel(jacks) {
    translate([0, KEYSTONE_CUTOUT_Z, KEYSTONE_CUTOUT_Y/2])
    rotate([90, 0, 0])
    union() {
        for (i = [0 : jacks-1]) {
            translate([-(calculate_keystone_panel_width(jacks)/2) + (KEYSTONE_CUTOUT_X/2) + (KEYSTONE_CUTOUT_X * i), 0, 0])
            keystone_mount();
        }
    }
    
}

module keystone_panel_cutout(jacks, thickness) {
    translate([0, thickness/2, KEYSTONE_CUTOUT_Y/2])
    cube([calculate_keystone_panel_width(jacks), thickness, KEYSTONE_CUTOUT_Y], center=true);
}

module keystone_mount() {
    translate([0, 0, KEYSTONE_CUTOUT_Z/2])
    difference() {
        translate([0, -1.3, 0])
        // all credit for this model goes to Starkadder. model can be found here: https://www.thingiverse.com/thing:2668816
        import("../../fixtures/Small_Single_Keystone_Jack_Faceplate.stl", center=true);

        difference() {
            cube([30, 100, KEYSTONE_CUTOUT_Z], center=true);
            
            cube([KEYSTONE_CUTOUT_X, KEYSTONE_CUTOUT_Y, KEYSTONE_CUTOUT_Z], center=true);
        }
    }
}