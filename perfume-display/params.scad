// Diameter and side of vials
//  [diameter, minimum number, maximum number]
vials = [[0.83, 40, 50], // 21/64"
         [1.59, 15, 20], // 5/8"
         [1.83, 5, 5],   // 23/32" \
         [2.06, 10, 10]];// 13/16" -- Alt: [2.06, 12, 12] to replace 5+10

// If no other restraints are imposed, put this much space between vial walls.
defaultInterVialDistance = 1.27; // 1/2"

// Minimum distance to be allowed between vial walls.
minInterVialDistance = 0.32; // 1/8"

// Size of the board to drill the holes in.
plankSize = [26.4, 21.31, 2.54];

// How deep to drill the holes.
vialDepth = 1.59; // 5/8"
