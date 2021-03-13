// Labeling library

function defaultMarkerRadius() = 1.5;

module sizeLabel(distance, over=false, markerRadius=defaultMarkerRadius(), lineRadius=0.1, color="grey") {
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

function keyChildInfo(name, count, spaceAbove, spaceBelow) =
    [name, count, spaceAbove, spaceBelow];

module key(childrenInfo=[], textColor="black") {
    function name(i) = childrenInfo[i][0];
    function count(i) = childrenInfo[i][1];
    function above(i) = childrenInfo[i][2];
    function below(i) = childrenInfo[i][3];

    assert(len(childrenInfo) == $children,
           str("Length of key children (", $children,
               ") and info (", len(childrenInfo), ") do not match."));
    
    // midpoints for each child
    heights = [ for(i = 0, h=below(i);
                    i < $children;
                    i=i+1, h = h + (i < $children ? below(i) : 0) + above(i-1)) h];
    
    textSize = 1.5 * min(concat([for (i=[0:$children-1]) below(i)],
                                [for (i=[0:$children-1]) above(i)]));

    for (i = [0:len(childrenInfo)-1]) {
        translate([0, 0, heights[i]]) {
            translate([-textSize/2, 0]) rotate([90, 0, 0]) color(textColor) text(str(name(i), " (", count(i), ")"), halign="right", valign="center", size=textSize);
            children(i);
        }
    }
}

// test
sizeLabel(50);

key([keyChildInfo("foo", 1, 3, 5), keyChildInfo("bar", 2, 4, 6)]) { translate([0, 0, -0.5]) cube([1,1,1]); translate([0, 0, -1]) cube([2,2,2]); }
