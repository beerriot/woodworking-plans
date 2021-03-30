// Labeling library

defaultMarkerRadius = 1.5;

function sizeLabelHeight(markerRadius=defaultMarkerRadius) = markerRadius*2;

module sizeLabel(distance, over=false, markerRadius=defaultMarkerRadius, lineRadius=0.1, color="grey", sigfig=2, rotation=0) {
    module sizeEnd() {
        cylinder(0.1, markerRadius, markerRadius * 0.75);
    }
    
    rounded = is_num(distance) ? round(pow(10, sigfig) * distance) / pow(10, sigfig) : distance;
    
    rotate([0, rotation, 0]) translate([0, 0, (over ? 1 : -1) * markerRadius + 0.01]) color(color) {
        rotate([0, 90, 0]) {
            sizeEnd();
            // translated in Z, because this is unrotated, and cylinder height is in Z
            translate([0, 0, distance]) mirror([0, 0, 1]) sizeEnd();
            cylinder(distance, r=lineRadius);
        }
        
        assert(abs(rotation) >= 0 && abs(rotation) <= 360,
               str("sizeLabel rotation must be between 0 and 360 (found ",
                   rotation, ")"));
        
        // center text left-to-right at low angles, but move it to the side above 30º
        halign = (abs(rotation) <= 30 ||
                  (abs(rotation) >= 150 && abs(rotation) <= 210) ||
                  abs(rotation) >= 330) ? "center"
                 : ((rotation < -30 && rotation > -150) ||
                    (rotation > 210 && rotation < 330))
                     ? (over ? "right" : "left") : (over ? "left" : "right");
        
        // move the text below or above at low angles, but put it right in the middle above 45º
        valign = (abs(rotation) <= 45 || abs(rotation) >= 315)
                 ? (over ? "bottom" : "top")
                 : (abs(rotation) >= 135 && abs(rotation) <= 225)
                   ? (over ? "top" : "bottom")
                   : "center";

        translate([distance/2, 0, (over ? 1 : -1) * markerRadius/2])
            rotate([90, -rotation, 0])
            text(str(rounded), halign=halign, valign=valign, size=markerRadius);
    }
}

//TODO: currently only works for 0 <= angle <= 180
module angleLabel(angle, referenceAngle, size, color="grey") {
    color(color) {
        rotate([0, -referenceAngle, 0]) {
            cube([size, 0.1, 0.1]);
            difference() {
                rotate([90, 0, 0]) cylinder(h=0.1, r=size*2/3, center=true);
                rotate([90, 0, 0]) cylinder(h=0.12, r=size*2/3 - 0.1, center=true);
                translate([-size, -0.06, -size*2]) cube([size*2, 0.12, size*2]);
                rotate([0, -angle, 0]) translate([-size, -0.06, 0]) cube([size*2, 0.12, size]);
            }
        }
        translate([cos(referenceAngle + angle/2) * size * 7/8, 0, sin(referenceAngle + angle/2) * size *7/8]) rotate([90, 0, 0]) text(str(angle, "º"), halign="center", valign="center", size=sin(angle)*size*0.45);
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
    
    textSize = 0.5 * min([for (i=[0:$children-1]) below(i) + above(i)]);

    for (i = [0:len(childrenInfo)-1]) {
        translate([0, 0, heights[i]]) {
            translate([-textSize/2, 0, (above(i) - below(i)) / 2]) rotate([90, 0, 0]) color(textColor) text(str(name(i), " (", count(i), ")"), halign="right", valign="center", size=textSize);
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

module taRightSide(xSize) {
    translate([xSize, 0, 0]) rotate([0, 0, 90]) children();
}

module taTopSide(zSize) {
    translate([0, 0, zSize]) rotate([-90, 0, 0]) children();
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
    
    taRightSide(5) {
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
    
    taRightSide(5) {
        translate([0, 0, 3]) sizeLabel(2, over=true);
        translate([2, 0]) rotate([0, -90, 0]) sizeLabel(3);
    }
 
    taTopSide(3) {
        translate([1.5, 0, 2]) sizeLabel(2, over=true);
        sizeLabel(5);
    }
}

translate([10, 0]) angleLabel(30, 0, 20);
translate([10, 0]) angleLabel(30, 30, 20);
translate([10, 0]) angleLabel(30, -30, 20);
translate([10, 0]) angleLabel(15, -90, 20);

translate([50, 0, 40]) {
    rotate([90, 0, 0]) text("under, neg", size=2, halign="right");
    translate([0, 0, 15]) rotate([90, 0, 0]) text("under, pos", size=2, halign="right");
    translate([0, 0, 30]) rotate([90, 0, 0]) text("over, neg", size=2, halign="right");
    translate([0, 0, 45]) rotate([90, 0, 0]) text("over, pos", size=2, halign="right");
    
    for (a = [0 : 15 : 360]) {
        translate([a+5, 0, -10]) rotate([90, 0, 0]) text(str(a), size=2, halign="center", valign="top");
        translate([a, 0, 0]) sizeLabel(10, over=false, rotation=-a);
        translate([a, 0, 15]) sizeLabel(10, over=false, rotation=a);
        translate([a, 0, 30]) sizeLabel(10, over=true, rotation=-a);
        translate([a, 0, 45]) sizeLabel(10, over=true, rotation=a);
    }
}
