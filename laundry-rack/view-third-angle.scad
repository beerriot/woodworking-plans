// Third-angle view of assembly
//cmdline: --projection=o --imgsize=2048,1536
include <../common/echo-camera-arg.scad>

use <../common/labeling.scad>

include <params.scad>
use <laundry-rack.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 103.69, -137.37, 118.04 ];
$vpf=22.50;
$vpd=620.12;

module assemblyKey()
thirdAngle([legShift() + armLength(), longDowelLength * 1.25, hangingHeight],
           frontLabels=[1, 1, 1],
           topLabels=[0,1,1]) {
    assembly();
    
    union() {
        // top length
        translate([endOfLeftArm(), 0, hangingHeight + squareStockWidth / 2])
            sizeLabel(armLength() * 2 - squareStockWidth, over=true);

        // hanging height
        translate([endOfLeftArm(), 0])
            sizeLabel(hangingHeight, rotation=-90, over=true);

        // paracord length
        translate([legShift(), 0, hangingHeight - pivotVerticalSpan()])
            sizeLabel(pivotVerticalSpan(), rotation=-90);
        
        // bottom length
        sizeLabel(legShift() * 2);
    }
    
    // total depth
    taRightSide(legShift() + armLength())
        translate([0, 0, hangingHeight + squareStockWidth / 2])
        sizeLabel(longDowelLength, over=true);

    
    taTopSide(hangingHeight + squareStockWidth / 2) {
        // long inner dowel length
        translate([endOfLeftArm(), 0, squareStockThickness])
            sizeLabel(longDowelLength - squareStockThickness * 2,
                      over=true, rotation=-90);
        
        // short inner dowel length
        translate([legShift() + armLength() - squareStockWidth / 2,
                   0,
                   squareStockThickness * 2])
            sizeLabel(shortDowelLength() - squareStockThickness * 2,
                      rotation=-90);
    }
}

assemblyKey();
