// Labeling library

module sizeLabel(distance, over=false, markerRadius=1.5, lineRadius=0.1, color="grey") {
    module sizeEnd() {
        cylinder(0.1, markerRadius, markerRadius * 0.75);
    }
    
    color(color) {
        rotate([0, 90, 0]) {
            sizeEnd();
            // translated in Z, because this is unrotated, and cylinder height is in Z
            translate([0, 0, distance]) mirror([0, 0, 1]) sizeEnd();
            cylinder(distance, r=lineRadius);
        }
        translate([distance/2, 0, (over ? 1 : -1) * markerRadius/2])
            rotate([90, 0, 0])
            text(str(distance), halign="center", valign=(over ? "bottom" : "top"), size=markerRadius);
    }
}

// test
sizeLabel(50);
