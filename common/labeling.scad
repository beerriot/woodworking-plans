// Labeling library

defaultMarkerRadius = 1.5;

function sizeLabelHeight(markerRadius=defaultMarkerRadius) = markerRadius*2;

module sizeLabel(distance, over=false, markerRadius=defaultMarkerRadius, lineRadius=0.1, color="grey", sigfig=2) {
    module sizeEnd() {
        cylinder(0.1, markerRadius, markerRadius * 0.75);
    }
    
    rounded = is_num(distance) ? round(pow(10, sigfig) * distance) / pow(10, sigfig) : distance;
    
    translate([0, 0, (over ? 1 : -1) * markerRadius + 0.01]) color(color) {
        rotate([0, 90, 0]) {
            sizeEnd();
            // translated in Z, because this is unrotated, and cylinder height is in Z
            translate([0, 0, distance]) mirror([0, 0, 1]) sizeEnd();
            cylinder(distance, r=lineRadius);
        }
        translate([distance/2, 0, (over ? 1 : -1) * markerRadius/2])
            rotate([90, 0, 0])
            text(str(rounded), halign="center", valign=(over ? "bottom" : "top"), size=markerRadius);
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

// Create a third-angle projection of the piece, when viewed from the front
// (looking in the positive-Y direction).
//
// The first three module arguments are the rough size of the object. The
// second three are vec3 denoting [N, E, S] how many sizeLabels are
// stacked on that side. These are used to determine how far to move each
// projected view.
//
// The module expects either 3 or 4 children. They are:
//    1: The object to be projected
//    2: Additional elements (e.g. sizes) to be shown in the front projection
//    3: Additional elements for the right-side projection
//    4: Additional elements for the top projection. If omitted, no top
//       projection will be created.
//
// All additional elements should be created around the object, oriented such that they would display correctly if the view were simply rotated. This module will rotate them to face forward as it creates each projection view.
//
// The resulting third-angle projection should be viewed in Orthogonal mode.
module thirdAngle(xSize, ySize, zSize,
                  frontLabels=[0, 0, 1],
                  rightLabels=[0, 1, 1],
                  topLabels=[0, 1, 0]) {
    assert($children >= 3 && $children <=4,
           str("thirdAngle requires 3 or 4 children ",
               "- object, front, right [top] - but passed ", $children))

    // Front view
    children([0:1]);
    
    // Right view
    translate([1 + xSize + sizeLabelHeight() * frontLabels[1], 0, 0])
    rotate([0, 0, -90])
    translate([-xSize, 0, 0]) {
        children(0);
        children(2);
    }
    
    if ($children > 3) {
        // Top view
        translate([0, 0, 1 + zSize + sizeLabelHeight() * (frontLabels[0] + topLabels[2])])
        rotate([90, 0, 0])
        translate([0, 0, -zSize]) {
            children(0);
            children(3);
        }
    }
}

function thirdAngleKeyChildInfoSpace(xSize, ySize, zSize,
                                     frontLabels=[0, 0, 1],
                                     rightLabels=[0, 1, 1],
                                     topLabels=[0, 1, 0]) =
    let (height = 1 + zSize + ySize + sizeLabelHeight() * (1 + frontLabels[0] + frontLabels[2] + topLabels[0] + topLabels[2])) [height/2, height/2];

function thirdAngleWidth(xSize, ySize,
                         frontLabels=[0, 0, 1],
                         rightLabels=[0, 1, 1]) =
    xSize + ySize + sizeLabelHeight() * (frontLabels[2] + rightLabels[2]);

// test
sizeLabel(50);

key([keyChildInfo("foo", 1, 3, 5), keyChildInfo("bar", 2, 4, 6)]) { translate([0, 0, -0.5]) cube([1,1,1]); translate([0, 0, -1]) cube([2,2,2]); }

translate([0, 0, 50]) thirdAngle(5, 2, 3) {
    cube([5, 2, 3]);
    
    sizeLabel(5);
    
    translate([5, 0]) rotate([0, 0, 90]) {
        sizeLabel(2);
        translate([2, 0]) rotate([0, -90, 0]) sizeLabel(3);
    }
        
}

translate([0, 0, 70]) thirdAngle(5, 2, 3, topLabels=[1, 0, 1]) {
    difference() {
        cube([5, 2, 3]);
        translate([2.5, 2, -0.01]) cylinder(3.02, r=1);
    }
    
    sizeLabel(5);
    
    translate([5, 0]) rotate([0, 0, 90]) {
        translate([0, 0, 3]) sizeLabel(2, over=true);
        translate([2, 0]) rotate([0, -90, 0]) sizeLabel(3);
    }
 
    translate([0, 0, 3]) {
        translate([1.5, 2, 0]) rotate([-90, 0, 0]) sizeLabel(2, over=true);
        rotate([-90, 0, 0]) sizeLabel(5);
    }
}
