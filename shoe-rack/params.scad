// The full width of the unit, outer edge of one end to outer edge of
// the other.
length = 84;

// The height of the end piece.
endHeight = 60;

// The depth of the end piece.
endDepth = 30;

// The height of the front of each shelf, and the angle it rises from
// there. List of [height, angle] pairs. Note that the height is of
// the top of the support - the tops of the slats are half their
// thickness above that.
shelfHeightsAndAngles = [[0,15],[15,15],[30,15],[45,0]];

// How wide the pieces used to make the end of the unit are.
endStockWidth = 5;

// How thick the pieces used to make the end of the unit are.
endStockThickness = 1.9;

// How wide the slats of the shelves are.
slatStockWidth = 1.9;

// How thick the slats of the shelves are.
slatStockThickness = 1;

// The minimum space to allow between shelf slats.
minSlatSpacing = 1.9;

// The maximum number of slats to use per shelf.
maxSlats = 6;

// Shelves at or above this angle should have their front slat raised
// to full height, instead of recessed into the shelf support, to
// provide a lip to keep shoes from sliding off.
raisedFrontSlatMinAngle = 5;

// If all shelves are at very similar angles, and/or it's not
// necessary for every shelf to span the full depth of the unit,
// setting this value to `true` will choose one shelf support depth
// and cut angle for all shelves, regardless of their mounting angle.
reduceUniqueParts = false;

// Color of the top and bottom components (the horizontal components)
// of the end assembly.
endTopBottomColor = "#ccccff";

// Color of the frontand back components (the vertical components) of
// the end assembly.
endFrontBackColor = "#ccffcc";

// Color of the shelf slats.
slatColor = "#cccc99";

// Color of the supports connecting the slats to the ends.
shelfSupportColor = "#99cccc";
