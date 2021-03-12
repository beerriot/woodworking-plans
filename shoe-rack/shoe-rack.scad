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

// avoid face interference when slicing
err=0.01;
derr=err*2;

module endStock(length, addThickness=0, addWidth=0) {
    cube([length, endStockThickness+addThickness, endStockWidth+addWidth]);
}

module slatStock(length, addThickness=0, addWidth=0) {
    cube([length, slatStockThickness+addThickness, slatStockWidth+addWidth]);
}

module endPiece(length) {
    difference() {
        endStock(length);
        // halflap either end
        translate([0, -endStockThickness/2, -err]) {
            translate([-err, 0]) endStock(endStockWidth+err, 0, derr);

            translate([length - endStockWidth, 0])
                endStock(endStockWidth+err, 0, derr);
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
        translate([0, -err, -endStockWidth]) 
        endStock(endStockWidth/cos(shelfAngle)+err, derr, sin(shelfAngle)+err);
        //cut off corner sticking out the back
        translate([shelfDepth, -err])
        rotate([0, 90+shelfAngle, 0]) 
        endStock(endStockWidth/cos(shelfAngle)+err, derr, sin(shelfAngle)+err);
        
        // slots for slats
        for (x = slatPositions) if (x != 0) translate([x, endStockThickness+err, slatStockThickness/2]) rotate([-90, 0, -90]) slat();

        // remove the portion that hangs below the ends
        if (bottom) {
            rotate([0, shelfAngle, 0]) translate([-err, -err, -(endStockWidth-shelfHeights[0]+err)]) endStock(endDepth+derr, derr, err);
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
        translate([0, -err, -err]) 
        slatStock(slatStockWidth/cos(shelfAngle)+err, derr, sin(shelfAngle)+err);
        //cut off corner sticking out the back
        translate([shelfDepth+slatStockThickness, -err, -err])
        rotate([0, 0, 90+shelfAngle]) 
        slatStock(slatStockWidth/cos(shelfAngle)+err, derr, sin(shelfAngle)+err);
        
        // slots for slats
        for (x = slatPositions) if (x != 0) translate([x+slatStockWidth+err, -slatStockThickness/2, -err]) rotate([0, -90, 0]) slatStock(slatStockWidth+derr);

        // remove the portion that hangs below the ends
        if (bottom) {
            rotate([0, 0, shelfAngle]) translate([-err, -err, -err]) slatStock(endDepth+derr, derr, derr);
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
