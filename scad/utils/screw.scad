module screw_cutout(head_rad, head_height, shank_rad, shank_height, thread_buffer=0.1) {
    cylinder(r=head_rad, h=head_height);
    translate([0, 0, -shank_height])
    cylinder(r=shank_rad + thread_buffer, h=shank_height);
}