// Shoe Rack
use <../common/common.scad>
use <../common/labeling.scad>

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

reduceUniqueParts=false;

// COMPUTED PARAMS
slatLength = length - endStockThickness*2;

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

// default errs must be specified, or the call to squareStock will pass `undefined`, overriding the default there
module endStock(length, errs=[0,0,0]) {
    squareStock(length, endStockThickness, endStockWidth, errs);
}

module slatStock(length, errs=[0,0,0]) {
    squareStock(length, slatStockThickness, slatStockWidth, errs);
}

// `render()` is necessary to prevent z-index conflicts
// on the ends of the half-laps when put together
module endPiece(length, pieceColor="red")
    color(pieceColor) render() difference() {
        endStock(length);
        // halflap either end
        translate([0, -endStockThickness/2]) {
            endStock(endStockWidth, [-1, 0, 2]);
            translate([length - endStockWidth, 0])
                endStock(endStockWidth, [1, 0, 2]);
        }
    }
    
module endPieceKey(length)
    thirdAngle([length, endStockThickness, endStockWidth],
               topLabels=[0,1,1]) {
        children();
        
        sizeLabel(length);
        
        taRightSide(length) {
            translate([endStockThickness, 0])
                sizeLabel(endStockWidth, rotation=-90);
            sizeLabel(endStockThickness);
        }

        taTopSide(endStockWidth) {
            translate([length, 0, 0])
                sizeLabel(endStockThickness/2, rotation=-90);
            translate([length - endStockWidth, 0, 0])
                sizeLabel(endStockWidth);
        }
    }
function endPieceKeySize(length) =
    thirdAngleSize([length, endStockThickness, endStockWidth],
                   topLabels=[0,1,1]);

module endTopBottom() {
    endPiece(endDepth, pieceColor=endTopBottomColor);
}

module endFrontBack() {
    endPiece(endHeight, pieceColor=endFrontBackColor);
}

module shelfSupportOrCenterKey(shelfAngle, height, thickness) {
    cutAngle = shelfCutAngle(shelfAngle);
    depth = shelfDepth(shelfAngle);

    cutDistance = height * tan(cutAngle);

    thirdAngle([depth, thickness, height],
               frontLabels=[1,0,1],
               topLabels=(cutAngle == 0 ? undef : [1,0,0])) {
        children();
    
        union() {
            translate([cutDistance, 0]) sizeLabel(depth - cutDistance*2);
    
            sp = [ for (x = slatPositions(shelfAngle)) x ];
            for (x = [1:len(sp)-1]) {
                translate([sp[x-1], 0, height]) sizeLabel(sp[x]-sp[x-1], over=true);
            }
        
            translate([sp[len(sp)-1], 0, height]) sizeLabel(slatStockWidth, over=true);
            if (cutAngle > 0) translate([0, 0, height]) angleLabel(cutAngle, -90, height);
        }

        taRightSide(depth) {
            sizeLabel(thickness);
            translate([thickness, 0]) sizeLabel(height, rotation=-90);
        }

        // TODO: this generates a fourth child, even if cutAngle == 0
        if (cutAngle != 0) translate([0, thickness, height]) rotate([-90, 0, 0]) sizeLabel(depth, over=true);
    }
}

function shelfSupportOrCenterKeySize(shelfAngle, height, thickness) =
    thirdAngleSize([shelfDepth(shelfAngle), thickness, height], frontLabels=[1,0,1], topLabels=[1,0,0]);

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
        for (x = slatPositions(shelfAngle)) if (x != 0 || (x == 0 && shelfAngle < raisedFrontSlatMinAngle)) translate([x, endStockThickness, slatStockThickness/2]) rotate([-90, 0, -90]) slatStock(endStockThickness, [2, 0, 0]);

        // remove the portion that hangs below the ends
        if (bottom) {
            rotate([0, shelfAngle, 0]) translate([0, 0, -(endStockWidth-shelfHeightsAndAngles[0][0])]) endStock(endDepth, [2, 2, -1]);
        }
    }
}
module shelfSupportKey(shelfAngle)
    shelfSupportOrCenterKey(shelfAngle, endStockWidth, endStockThickness)
        shelfSupport(shelfAngle);
function shelfSupportKeySize(shelfAngle) =
    shelfSupportOrCenterKeySize(shelfAngle, endStockWidth, endStockThickness);

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
module shelfCenterKey(shelfAngle)
    shelfSupportOrCenterKey(shelfAngle, slatStockThickness, slatStockWidth)
        translate([0, 0, slatStockThickness])
        shelfCenter(shelfAngle);
function shelfCenterKeySize(shelfAngle) =
    shelfSupportOrCenterKeySize(shelfAngle, slatStockThickness, slatStockWidth);

module slat() {
    color(slatColor) translate([0, 0, slatStockThickness]) rotate([-90, 0, 0]) slatStock(slatLength);
}

module slatKey() thirdAngle([slatLength, slatStockWidth, slatStockThickness]) {
    slat();
    
    sizeLabel(slatLength);

    taRightSide(slatLength) {
        sizeLabel(slatStockWidth);
        translate([slatStockWidth, 0])
            sizeLabel(slatStockThickness, rotation=-90);
    }
}
function slatKeySize() =
    thirdAngleSize([slatLength, slatStockWidth, slatStockThickness],
                   topLabels=undef);

// KEY
module partsKey() {
    function totalSlats(i=0, total=0) =
        (i == len(shelfHeightsAndAngles)) ? total : totalSlats(i+1, total + slatCount(i));
    
    function rest(list, fromi) =
        (fromi > len(list)-1) ? [] : [ for (j=[(fromi+1):(len(list)-1)]) list[j] ];
    function addShelfAngle(angle, angles, i=0) =
        (i == len(angles) ? [[angle, 1]] :
            (angle == angles[i][0] ?
                concat([[angle, angles[i][1]+1]], rest(angles, i+1)) :
                concat([angles[0]], addShelfAngle(angle, angles, i+1))));
    function uniqueShelfAngles(i=0, angles=[]) =
        (i == len(shelfHeightsAndAngles)) ? angles :
            uniqueShelfAngles(i+1,
                addShelfAngle(shelfHeightsAndAngles[i][1], angles));
    shelfAngles=reduceUniqueParts ? [[maxShelfAngle, len(shelfHeightsAndAngles)]] : uniqueShelfAngles();
        
    module labeledShelfPiece(i, height, thickness) {
        function distanceTo(i) = i == 0 ? 0 : shelfSupportOrCenterKeySize(shelfAngles[i-1][0], height, thickness).x+endStockWidth*1.5+distanceTo(i-1);
        translate([distanceTo(i),  0, 0]) {
            children();
            translate([shelfSupportOrCenterKeySize(shelfAngles[i][0], height, thickness).x+1, 0, height/2+sizeLabelHeight()]) rotate([90, 0, 0]) text(str("(", shelfAngles[i][1]*2, ")"), size=endStockWidth/2, valign="center");
        }
    }
    
    key([keyChildInfo("END FRONT/BACK", 4, endPieceKeySize(endDepth)),
         keyChildInfo("END TOP/BOTTOM", 4, endPieceKeySize(endHeight)),
         keyChildInfo("SHELF SLAT", totalSlats(), slatKeySize()),
         keyChildInfo("SHELF SUPPORT", len(shelfHeightsAndAngles)*2, shelfSupportKeySize(0)),
         keyChildInfo("SHELF CENTER", len(shelfHeightsAndAngles)*2, shelfCenterKeySize(0))]) {
             endPieceKey(endDepth) endTopBottom();
             endPieceKey(endHeight) endFrontBack();
             slatKey();
        for (i=[0:len(shelfAngles)-1]) labeledShelfPiece(i, endStockWidth, endStockThickness) shelfSupportKey(shelfAngles[i][0]);
        for (i=[0:len(shelfAngles)-1]) labeledShelfPiece(i, slatStockThickness, slatStockWidth) translate([0, 0, slatStockThickness]) shelfCenterKey(shelfAngles[i][0]);
    }
}

translate([0, 0, endHeight * 1.5]) {
    translate([length/2, 0])
    rotate([90, 0, 0])
    color("black")
    text("KEY", halign="center", valign="top", size=endStockWidth*2);
        
    partsKey();
}

// ASSEMBLY

module assembly(includeLabels=false) {
    module whole() {
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
                    translate([0, y, endStockWidth - sink]) slat();
            }
        }

        end();
        translate([length, 0]) mirror([1, 0,0]) end();

        for (i = [0:len(shelfHeightsAndAngles)-1],
             h=shelfHeightsAndAngles[i][0],
             a=shelfHeightsAndAngles[i][1]) {
            translate([endStockThickness, 0, h]) shelf(a, i == 0);
        }
    }
    
    if (includeLabels) {
        thirdAngle([length, endDepth, endHeight]) {
            whole();
            
            sizeLabel(length);
            
            taRightSide(length) {
                sizeLabel(endDepth);
                translate([endDepth, 0]) sizeLabel(endHeight, rotation=-90);
            }
            
            union() {}
        }
    } else {
        whole();
    }
}
assembly();

translate([length*1.5, 0]) assembly(includeLabels=true);
