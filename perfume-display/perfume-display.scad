use <../common/common.scad>

$fs = 0.1;
$fa = 5;

// INPUT PARAMS
include <params.scad>

// COMPUTED PARAMS
function minCenterDistanceRequired() =
    minInterVialDistance + max([ for (i = vials) i[0] ]);

function defaultCenterDistanceRequired() =
    defaultInterVialDistance + min([ for (i = vials) i[0] ]);

function vialCenterDistance() =
    max(minCenterDistanceRequired(), defaultCenterDistanceRequired());

function staticBorder() = [border.x, border.y, 0];

function usablePlankSpace() = plankSize - staticBorder() * 2;

function rowOffset(row) =
    [(row % 2) * vialCenterDistance() / 2,
     row * sqrt(3) * vialCenterDistance() / 2,
     0];

function realMaxVials() =
    [usablePlankSpace().x / vialCenterDistance(),
     usablePlankSpace().y / (vialCenterDistance() / 2 * sqrt(3))];

function intMaxVials() =
    [for (d = realMaxVials()) floor(d)];

function equalSizeRows() =
    (realMaxVials().x - intMaxVials().x) >= 0.5;

function dynamicBorder() =
    [(usablePlankSpace().x - (intMaxVials().x - 1) * vialCenterDistance() -
      (equalSizeRows()
       ? 0.5 * vialCenterDistance() // shift left for equal-size rows
       : 0)) / 2,                   // no shift for alternating-size rows
     (usablePlankSpace().y - (intMaxVials().y - 1) * rowOffset(1).y) / 2,
     0];

function vialsInRow(row) =
    intMaxVials().x - (equalSizeRows() ? 0 : (row % 2));

function relativeVialPositions(row) =
    [ for (i = [0 : vialsInRow(row) - 1]) [i * vialCenterDistance(), 0, 0] ];

function vialPositions() =
    [ for (i = [0 : intMaxVials().y - 1])
            for (j = relativeVialPositions(i))
                let (d = diameterAndDepthOfVialsInRow(i))
                    [j + rowOffset(i) + [0, 0, plankSize.z - d[1]], d[0]] ];

function diameterAndDepthOfVialsInRow(i,
                                      countRow=0,
                                      vialsBatch=0,
                                      vialCount=0) =
    (countRow == i) ? [vials[vialsBatch][0], vials[vialsBatch][1]]
    : let (newVialCount = vialCount + vialsInRow(countRow))
    diameterAndDepthOfVialsInRow(i, countRow+1,
                                 (newVialCount > vials[vialsBatch][2])
                                 ? (vialsBatch + 1) % len(vials) : vialsBatch,
                                 (newVialCount > vials[vialsBatch][2])
                                 ? 0 : newVialCount);

// COMPONENTS
module plank() {
    cube(plankSize);
}

module drillHole(diameter) {
    cylinder(r=diameter / 2, h=plankSize.z + 0.1);
}

module bevelCut() {
    thickness = (bevel[1] * sin(bevel[0])) + 0.01;
    height = (bevel[1] / cos(bevel[0])) + 0.02;
    translate([0, 0, bevel[1]])
        rotate([bevel[0], 0, 0])
        translate([-0.01, -thickness, 0.01 - height])
        cube([max(plankSize.x, plankSize.y) + 0.02,
              thickness,
              height]);
}

module grooveCut(plankDimension) {
    radius = groove[0] / 2;
    length = plankDimension * groove[1];
    translate([plankDimension / 2, 0, plankSize.z / 2])
        rotate([0, 90, 0])
        union() {
        cylinder(h=length,
                 r=radius,
                 center=true);
        translate([0, 0, length / 2]) sphere(r=radius);
        translate([0, 0, -length / 2]) sphere(r=radius);
        }
}

// ASSEMBLY

module bevels() {
    // bottom
    bevelCut();

    // top
    translate([0, 0, plankSize.z]) mirror([0,0,1]) bevelCut();
}

module backSide() {
    translate([0, plankSize.y, 0]) mirror([0,1,0]) children();
}

module leftSide() {
    rotate([0, 0, 90]) mirror([0, 1, 0]) children();
}

module rightSide() {
    translate([plankSize.x, 0, 0]) rotate([0, 0, 90]) children();
}

module assembly() {
    difference() {
        plank();

        // vial holes
        translate(staticBorder() + dynamicBorder())
            for (i = vialPositions())
                translate(i[0]) drillHole(i[1]);

        bevels();
        backSide() bevels();
        leftSide() bevels();
        rightSide() bevels();

        grooveCut(plankSize.x);
        backSide() grooveCut(plankSize.x);
        leftSide() grooveCut(plankSize.y);
        rightSide() grooveCut(plankSize.y);
    }
}

assembly();

echo(vialCenterDistance=vialCenterDistance());
echo(staticBorder=staticBorder(), usablePlankSpace=usablePlankSpace());
echo(realMaxVials=realMaxVials(), intMaxVials=intMaxVials());
echo(dynamicBorder=dynamicBorder());
