// Third Angle view of Assembly
//cmdline: --projection=o --imgsize=2048,2048

include <params.scad>
use <shoe-rack.scad>
use <../common/labeling.scad>

$vpr=[ 90.00, 0.00, 0.00 ];
$vpt=[ 58.59, -204.62, 43.92 ];
$vpf=22.50;
$vpd=325.80;

module assemblyKey() thirdAngle([length, endDepth, endHeight]) {
    assembly();
    
    sizeLabel(length);
    
    taRightSide(length) {
        sizeLabel(endDepth);
        translate([endDepth, 0]) sizeLabel(endHeight, rotation=-90);
    }
    
    taTopSide(endHeight) {}
}

assemblyKey();
