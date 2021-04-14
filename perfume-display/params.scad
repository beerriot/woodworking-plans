// Diameter and side of vials
//  [diameter, depth, minimum number]
vials = [[0.83, 1.59, 40], // 21/64" x 5/8"
         [1.59, 0.95, 15], // 5/8" x 3/8"
         [1.83, 1.59, 5],  // 23/32"
         [2.06, 1.59, 10]];// 13/16" -- Alt: [2.06, 12, 12] to replace 5+10

// If no other restraints are imposed, put this much space between vial walls.
defaultInterVialDistance = 1.27; // 1/2"

// Minimum distance to be allowed between vial walls.
minInterVialDistance = 0.32; // 1/8"

// Size of the board to drill the holes in.
plankSize = [25.4, 20.32, 2.54]; // 10x8x1"

// Minimum space between edge of vial hole and edge of plank.
border = [0.32, 0.32];

// Bevel around the edge: [angle, depth]
bevel = [30, 0.32];

// Grooves to improve grip when lowering int a drawer.
//    [diameter, length as ratio of plank dimension]
groove = [0.63, 0.5];
