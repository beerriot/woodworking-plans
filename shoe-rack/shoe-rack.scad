// Shoe Rack

// INPUT PARAMS
length=84;
endHeight=76;

shelfHeights=[0,15,30,45,55,65];
shelfDepth=31;
shelfAngle=15;

endStockWidth=5;
endStockThickness=1.9;

slatStockWidth=1.9;
slatStockThickness=1;
minSlatSpacing=1.9;
maxSlats=6;

// COMPUTED PARAMS
endDepth=shelfDepth*cos(shelfAngle);

slatCount = min(maxSlats, floor(shelfDepth / (slatStockWidth+minSlatSpacing)));
slatSpace = (shelfDepth - slatStockWidth*slatCount) / (slatCount-1);
slatPositions = [0 : (slatStockWidth + slatSpace) : shelfDepth];

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

module shelfSupport(bottom=false) {
    color(shelfSupportColor)
    render()
    translate([0, 0, endStockWidth])
    difference() {
        translate([0, 0, -endStockWidth]) endStock(shelfDepth);
        //cut off corner sticking out the front
        rotate([0, 90-shelfAngle, 0]) 
        translate([0, 0, -endStockWidth]) 
        endStock(endStockWidth/cos(shelfAngle), [1, 2, 1]);
        //cut off corner sticking out the back
        translate([shelfDepth, 0])
        rotate([0, 90+shelfAngle, 0]) 
        endStock(endStockWidth/cos(shelfAngle), [1, 2, 1]);
        
        // slots for slats
        for (x = slatPositions) if (x != 0) translate([x, endStockThickness, slatStockThickness/2]) rotate([-90, 0, -90]) slatStock(endStockThickness, [2, 0, 0]);

        // remove the portion that hangs below the ends
        if (bottom) {
            rotate([0, shelfAngle, 0]) translate([0, 0, -(endStockWidth-shelfHeights[0])]) endStock(endDepth, [2, 2, -1]);
        }
    }    

}

module shelfCenter(bottom=false) {
    color(slatColor)
    rotate([-90, 0, 0])
    difference() {
        slatStock(shelfDepth);
        //cut off corner sticking out the front
        rotate([0, 0, 90-shelfAngle]) 
        slatStock(slatStockWidth/cos(shelfAngle), [1, -1, 2]);
        //cut off corner sticking out the back
        translate([shelfDepth+slatStockThickness, 0])
        rotate([0, 0, 90+shelfAngle]) 
        slatStock(slatStockWidth/cos(shelfAngle), [1, 1, 2]);
        
        // slots for slats
        for (x = slatPositions) if (x != 0) translate([x+slatStockWidth, -slatStockThickness/2]) rotate([0, -90, 0]) slatStock(slatStockWidth, [2, 0, 2]);

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

module shelf(bottom=false) {
    rotate([shelfAngle, 0, 0]) translate([0, 0, -endStockWidth]) {
        translate([endStockThickness, 0]) rotate([0, 0, 90]) shelfSupport(bottom);
        translate([(length - endStockThickness*2), 0]) rotate([0, 0, 90]) shelfSupport(bottom);
        
        translate([(slatStockThickness + length)/2, 0, endStockWidth]) rotate([0, 0, 90]) shelfCenter(bottom);
    
        // front slat sits higher than other slats, to provide a little ledge for heels/toes to rest against
        for (y = slatPositions) translate([0, y, endStockWidth - (y == 0 ? 0 : slatStockThickness/2)]) rotate([-90, 0, 0]) translate([0, -slatStockThickness]) slat();
    }
}

end();
translate([length, 0]) mirror([1, 0,0]) end();

for (i = [0:len(shelfHeights)-1], h=shelfHeights[i]) {
    translate([endStockThickness, 0, h]) shelf(i == 0);
}
