// Shoe Rack

// INPUT PARAMS
length=84;
endHeight=60;
endDepth=30;

shelfHeightsAndAngles=[[0,15],[15,15],[30,15],[45,0]];

endStockWidth=5;
endStockThickness=1.9;

slatStockWidth=1.9;
slatStockThickness=1;

minSlatSpacing=1.9;
maxSlats=6;

raisedFrontSlatMinAngle=5;

reduceUniqueParts=true;

// COMPUTED PARAMS

minShelfAngle = min([ for (ha = shelfHeightsAndAngles) ha[1] ]);
maxShelfAngle = max([ for (ha = shelfHeightsAndAngles) ha[1] ]);

function shelfDepth(shelfAngle) =
    endDepth/cos(reduceUniqueParts ? minShelfAngle : shelfAngle);

function shelfCutAngle(shelfAngle) =
    reduceUniqueParts ? maxShelfAngle : shelfAngle;

function slatCount(shelfAngle) =
    min(maxSlats, floor(shelfDepth(shelfAngle) / (slatStockWidth+minSlatSpacing)));
    
function slatSpace(shelfAngle) =
    let (slats = slatCount(shelfAngle))
    (shelfDepth(shelfAngle) - slatStockWidth*slats) / (slats-1);
    
function slatPositions(shelfAngle) =
    let (depth = shelfDepth(shelfAngle), space = slatSpace(shelfAngle))
    [0 : (slatStockWidth + space) : depth];

// COLORS
endTopBottomColor=[0.8, 0.8, 1];
endFrontBackColor=[0.8, 1, 0.8];
slatColor=[0.8, 0.8, 0.6];
shelfSupportColor=[0.6, 0.8, 0.8];

// COMPONENTS

// This is "cube" with two features:
//   1. length=x, thickness=y, width=z
//   2. errs vec for less noisy slicing
//
// Use errs to make pieces for slicing out of other pieces. The elements of the
// vector apply to [length, thickness, width]. Each value should be 0, 1, -1, or 2.
//   0: make the dimension exactly as specified
//   1: add `err` to the dimension
//  -1: add `err` to the dimension, but also shift the object -err
//      (i.e. add err to the zero end of that dimension)
//   2: add `2*err` to the dimension, but also shift the object -err
//      (i.e. add err to each end)
// Using errs prevents the need for +/-err to appear in object creation code.
module squareStock(length, thickness, width, errs=[0,0,0]) {
    err = 0.01;
    translate([errs.x == 2 || errs.x == -1 ? -err : 0,
               errs.y == 2 || errs.y == -1 ? -err : 0,
               errs.z == 2 || errs.z == -1 ? -err : 0])
        cube([length + (err * abs(errs.x)),
              thickness + (err * abs(errs.y)),
              width + (err * abs(errs.z))]);
}

// default errs must be specified, or the call to squareStock will pass `undefined`, overriding the default there
module endStock(length, errs=[0,0,0]) {
    squareStock(length, endStockThickness, endStockWidth, errs);
}

module slatStock(length, errs=[0,0,0]) {
    squareStock(length, slatStockThickness, slatStockWidth, errs);
}

module endPiece(length) {
    difference() {
        endStock(length);
        // halflap either end
        translate([0, -endStockThickness/2]) {
            endStock(endStockWidth, [-1, 0, 2]);
            translate([length - endStockWidth, 0])
                endStock(endStockWidth, [1, 0, 2]);
        }
    }
}

// these `render()` calls are necessary to prevent z-index conflicts
// on the ends of the half-laps when put together
module endTopBottom() {
    color(endTopBottomColor) endPiece(endDepth);
}

module endFrontBack() {
    color(endFrontBackColor) render() endPiece(endHeight);
}

module shelfSupport(shelfAngle, bottom=false) {
    cutAngle = shelfCutAngle(shelfAngle);
    depth = shelfDepth(shelfAngle);
    
    color(shelfSupportColor)
    render()
    translate([0, 0, endStockWidth])
    difference() {
        translate([0, 0, -endStockWidth]) endStock(depth);
        //cut off corner sticking out the front
        rotate([0, 90-cutAngle, 0]) 
        translate([0, 0, -endStockWidth]) 
        endStock(endStockWidth/cos(cutAngle), [1, 2, 1]);
        //cut off corner sticking out the back
        translate([depth, 0])
        rotate([0, 90+cutAngle, 0]) 
        endStock(endStockWidth/cos(cutAngle), [1, 2, 1]);
        
        // slots for slats
        for (x = slatPositions(shelfAngle)) if (x != 0|| (x == 0 && shelfAngle < raisedFrontSlatMinAngle)) translate([x, endStockThickness, slatStockThickness/2]) rotate([-90, 0, -90]) slatStock(endStockThickness, [2, 0, 0]);

        // remove the portion that hangs below the ends
        if (bottom) {
            rotate([0, shelfAngle, 0]) translate([0, 0, -(endStockWidth-shelfHeightsAndAngles[0][0])]) endStock(endDepth, [2, 2, -1]);
        }
    }    

}

module shelfCenter(shelfAngle, bottom=false) {
    cutAngle = shelfCutAngle(shelfAngle);
    depth = shelfDepth(shelfAngle);
    
    color(slatColor)
    rotate([-90, 0, 0])
    difference() {
        slatStock(depth);
        //cut off corner sticking out the front
        rotate([0, 0, 90-cutAngle]) 
        slatStock(slatStockWidth/cos(cutAngle), [1, -1, 2]);
        //cut off corner sticking out the back
        translate([depth+slatStockThickness, 0])
        rotate([0, 0, 90+cutAngle]) 
        slatStock(slatStockWidth/cos(cutAngle), [1, 1, 2]);
        
        // slots for slats
        for (x = slatPositions(shelfAngle)) if (x != 0 || (x == 0 && shelfAngle < raisedFrontSlatMinAngle)) translate([x+slatStockWidth, -slatStockThickness/2]) rotate([0, -90, 0]) slatStock(slatStockWidth, [2, 0, 2]);

        // remove the portion that hangs below the ends
        if (bottom) {
            rotate([0, 0, shelfAngle]) slatStock(endDepth, [2, -1, 2]);
        }
    } 
}

module slat() {
    color(slatColor) slatStock(length - endStockThickness*2);
}

// ASSEMBLY

module end() {
    translate([endStockThickness, 0]) rotate([0, 0, 90]) {
        endTopBottom();
        translate([0, 0, endHeight-endStockWidth]) endTopBottom();
        translate([0, endStockThickness]) rotate([180, -90, 0]) endFrontBack();
        translate([endDepth-endStockWidth, endStockThickness]) rotate([180, -90, 0]) endFrontBack();
    }
}

module shelf(shelfAngle, bottom=false) {
    rotate([shelfAngle, 0, 0]) translate([0, 0, -endStockWidth]) {
        translate([endStockThickness, 0]) rotate([0, 0, 90]) shelfSupport(shelfAngle, bottom);
        translate([(length - endStockThickness*2), 0]) rotate([0, 0, 90]) shelfSupport(shelfAngle, bottom);
        
        translate([(slatStockThickness + length)/2, 0, endStockWidth]) rotate([0, 0, 90]) shelfCenter(shelfAngle, bottom);
    
        for (y = slatPositions(shelfAngle),
             // do not sink the front slat if the shelf angle is low;
             // keep it raised to provide a leg for heels/toes to rest against
             sink = (y == 0 && shelfAngle >= raisedFrontSlatMinAngle ? 0 : slatStockThickness/2))
            translate([0, y, endStockWidth - sink]) rotate([-90, 0, 0])
            translate([0, -slatStockThickness]) slat();
    }
}

end();
translate([length, 0]) mirror([1, 0,0]) end();

for (i = [0:len(shelfHeightsAndAngles)-1],
     h=shelfHeightsAndAngles[i][0],
     a=shelfHeightsAndAngles[i][1]) {
    translate([endStockThickness, 0, h]) shelf(a, i == 0);
}
