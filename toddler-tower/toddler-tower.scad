// Also known as a "learning tower", it's a step stool with a walled
// top step, to let kids stand at counter-top height without worrying
// about them falling off.

use <../common/common.scad>
use <../common/hardware.scad>

$fs = 0.1;
$fa = 5;

include <params.scad>

// COMPUTED PARAMS

// Angle off of vertical that the front slopes at, from the bottom
// front step to the safety rail.
function front_angle() =
    atan((bottom_depth - platform_depth) / (height - front_step_heights[0]));

function front_step_depth() = bottom_depth / 4;

// How far from the front edge a height at (h)cm should be (because of
// the slope to the safety rail).
function front_step_inset(h) =
    max(0, (h - front_step_heights[0] - thickness)) * sin(front_angle());

// How far into the side panels the platform, step, and supports sink.
function recess_depth() = thickness / 4;

// Distance from the bottom of a dado/rabbet/groove in one side panel
// to the bottom of a dado/rabbet/groove in the other.
function inter_recess_span() = width - (thickness - recess_depth()) * 2;

function narrow_support_height() = front_step_heights[0] - thickness;

function wide_support_height() =
    (height - platform_heights[len(platform_heights) - 1]) / 2;

function safety_rail_height() = thickness * 1.5;

function cutout_radius() = handhold_size[1] / 2;

// All upper window measurements align on the centers of the circles
// in the corners.

// How far the edges of the window are from the top and cabinet-side
// edge.
function upper_window_inset() = handhold_size[1] * 3;
function upper_window_height() =
    height - platform_heights[len(platform_heights) - 1]
    - upper_window_inset() * 2;
function upper_window_top_depth() =
    bottom_depth - upper_window_inset() * 2
    - (sin(front_angle())
       * (height - front_step_heights[0] - upper_window_inset()));
function upper_window_bottom_depth() =
    upper_window_top_depth() + sin(front_angle()) * upper_window_height();

// How far the bottom non-cabinet side corner of the window is from
// the non-cabinet side corner of the tower.
function lower_window_inset() =
    // "- sin" - the corner of the window is just a bit underneath the
    // front step
    front_step_depth() - sin(front_angle()) * front_step_heights[0];
function lower_window_height() =
    platform_heights[0] - thickness * 2 - cutout_radius();
// How much closer to the cabinet side the upper non-cabinet side
// corner is than the lower non-cabinet side corner.
function lower_window_upper_corner_offset() =
    sin(front_angle()) * lower_window_height() + cutout_radius();
function lower_window_top_depth() = front_step_depth();
function lower_window_bottom_depth() =
    bottom_depth + cutout_radius() - front_step_depth() - lower_window_inset();

// How far the handhold on the top edge is from the cabinet-side edge.
function top_handhold_offset() =
    (platform_depth - handhold_size[0]) / 2;

// How far the front step bolts are from the non-cabinet-side
// edge. Does not include the slope of the front angle.
function bolt_hole_step_front() = front_step_depth() * 0.2;
function bolt_hole_step_rear() = front_step_depth() * 0.8;

// How far the platform bolts are from the cabinet-side edge.
function bolt_hole_platform_front() = platform_depth * 0.2;
function bolt_hole_platform_rear() = platform_depth * 0.8;

function bolt_length() = thickness + threaded_insert_depth;

// How deep to drill the holes in the platform and front step.
function bolt_hole_depth() =
    max(threaded_insert_depth,
        bolt_length() - (thickness - recess_depth()));

// Inner diameter of the threaded inserts for the platform and front step.
function threaded_insert_id() = threaded_insert_od / 2;

function screw_length() = thickness * 2.5;

// How far each screw is from the upper or lower edge of each
// cross-member support.
function screw_inset() = min(1.5,
                             narrow_support_height() * 0.2,
                             wide_support_height() * 0.2);

// How far from the non-cabinet edge the top of a handhold
// is. Includes the gap of the front angle.
function inset_for_handhold(h) =
    (h - front_step_heights[0]) * sin(front_angle())
    + handhold_size[1] / cos(front_angle());

// COMPONENTS

// Since I want the finall assembly view to just call `assembly`, and
// not do any assembly itself, it's not possible for that view to do
// any color modification. It would only be able to change the color
// of everything, and I'd like the screws and bolts to be a different
// color than the wood.
//
// Instead of threading color choices through the module call stack,
// I've decided to use this "special variable", and the following
// color modules. Special variables retain their value in the call
// stack, so `assembly` can set this when it starts, and everything
// `assembly` calls will see the value it used.
$use_finish_colors = false;

module wood_diagram_color(diagram_color) {
    color($use_finish_colors ? finish_wood_color : diagram_color) children();
}

module screw_diagram_color(diagram_color) {
    color($use_finish_colors ? finish_screw_color : diagram_color) children();
}

module bolt_diagram_color(diagram_color) {
    color($use_finish_colors ? finish_bolt_color : diagram_color) children();
}

// Hardware.

// Origin: center of the shaft, just under the head.
// Orientation: shaft pointing along Z axis.
module bolt() {
    bolt_diagram_color(bolt_color)
        hex_bolt(diameter=threaded_insert_id(),
                 length=bolt_length(),
                 head_diameter=bolt_head_diameter,
                 head_thickness=bolt_head_thickness,
                 hex_size=threaded_insert_id());
}

// Origin: center of the hole, at one end.
// Orientation: hole pointing along Z axis.
module tt_threaded_insert() {
    bolt_diagram_color(threaded_insert_color)
        threaded_insert(id=threaded_insert_id(),
                        od=threaded_insert_od,
                        depth=threaded_insert_depth);
}

// Origin: Center of head, at the top of the head.
// Orientation: shaft pointing along Z axis.
module screw() {
    screw_diagram_color(screw_color) deck_screw(screw_length());
}

// Origin: Center of hole, at the non-wood-side of the washer.
// Orientation: hole pointing along Z axis.
module tt_finish_washer() {
    screw_diagram_color(finish_washer_color) finish_washer();
}

// Origin: Center of shaft, at the wood-side of the washer.
// Orientation: shaft pointing along Z axis.
module screw_with_washer() {
    translate([0, 0, -finish_washer_height()]) {
        translate([0, 0, -0.01]) screw();
        tt_finish_washer();
    }
}

// Wood.

// Convenience function for starting parts. This mainly abstracts
// `thickness`, but also provides the `errs` facility of
// `common/squareStock` to make cuts without rendering conflicts.
//
// Origin: corner.
// Orientation: Length along the +X axis, Width along +Y, thickness
// above the Z=0 plane.
module sheet_stock(length, width, errs=[0,0,0]) {
    squareStock(length, width, thickness, errs);
}

// Side Panel.

// Side panel cut to outer dimensions, with no further
// alterations. It's laying flat, as if you were going to work on it
// at a bench.
//
// Origin: corner.
// Orientation: Tower height along +X, depth along +Y, thickness above Z=0.
module side_panel_blank() {
    wood_diagram_color(side_color) sheet_stock(height, bottom_depth);
}

// The slope on the non-cabinet side of the tower, from the safety
// rail to the lowest front step. It is pre-placed in relation to
// `side_panel_blank` for where it should remove material.
//
// Origin: The point that should be placed at `side_panel_blank`'s
// non-cabinet corner to make the cut.
// Orientation: Angled into +Y from +X.
module front_angle_cut() {
    translate([front_step_heights[0], 0, 0])
        rotate([0, 0, front_angle()])
        translate([0, -bottom_depth, 0])
        wood_diagram_color(side_color)
        sheet_stock(height, bottom_depth, errs=[2,0,2]);
}

// Any sort of cut shaped to fit a bit of sheet_stock turned on
// end. Pre-set to make a `length`cm cut in the X direction in the top
// of any sheet_stock. It's just into the piece on the "front" side,
// so without further adjustment, it would make a rabbet of thickness
// width along the front edge.
//
// Origin: Thickness minus recess_depth below one corner, inset
// rendering-conflict avoidance amount.
// Orientation: Length along +X, recess_depth toward -Z (though above
// Z=0), thickness in +Y.
module recess(length) {
    translate([0, 0, thickness])
        // stand the piece "on end" so we cut a recess that is
        // `thickness` wide
        rotate([-90, 0, 0])
        // [2,2,2] oversizes the cut to avoid rendering conflicts.
        sheet_stock(length, recess_depth(), [2, 2, 2]);
}

// A recess across the grain of the wood, not at the edge of the
// material. This recess sits just off the "left" side of the piece,
// so it will not remove any material without adjustment. Moving it N
// units in +X will result in a cut with one side at x=N and the other
// side at x=N-thickness.
module dado(length) {
    wood_diagram_color(dado_color) rotate([0, 0, 90]) recess(length);
}

// A recess along the grain of the wood, not at the edge of the
// material. Same origin and orientation as `recess`.
module groove(length) {
    wood_diagram_color(groove_color) recess(length);
}

// A recess in either grain direction, at the edge of the material.
// Same origin and orientation as `recess`.
module rabbet(length) {
    wood_diagram_color(rabbet_color) recess(length);
}

// A recess form to cut the dado for any of the front steps. It is
// made long enough to cut the highest one (which is furthest along
// the front angle slope) from the front of the side panel blank. This
// means that it over-cuts the dados for the lowest step, but the
// overcut will be removed by the lower window.
//
// Origin: The "top" corner at the non-cabinet side.
// Orientation: Same as `dado`.
module front_step_dado() {
    deepest_inset =
        front_step_inset(front_step_heights[len(front_step_heights)-1]);
    translate([0, -deepest_inset, 0])
        dado(front_step_depth() + deepest_inset);
}

// A recess form to cut the dado for each platform height. Origin and
// orientation are the same as dado, so in addition to being moved to
// the right height, it also needs to be shifted in to put the far end
// at the cabinet-side of the tower to cut in the right place.
module platform_dado() {
    dado(platform_depth);
}

// A rabbet for the narrow cross-member supports.
module narrow_support_rabbet() {
    rabbet(narrow_support_height());
}

// A groove for the narrow cross-member supports.
module narrow_support_groove() {
    groove(narrow_support_height());
}

// A rabbet for the wide cross-member support.
module wide_support_rabbet() {
    rabbet(wide_support_height());
}

// A groove for the safety rail.
module safety_rail_groove() {
    groove(safety_rail_height());
}

// Handholds and windows are composed of circular cuts that are then
// connected with tangents. This module is the circular cut.
//
// Origin: center of the circle, just inside the bottom edge to
// prevent rendering conflicts.
// Orientation: center of cylinder along Z axis.
module cutout_end() {
    translate([0, 0, -0.01])
        wood_diagram_color(side_color)
        cylinder(h=thickness + 0.02, r=cutout_radius());
}

// Two cutout_ends spaced for either end of a handhold.
//
// Origin: One circle's center.
// Orientation: Other circle is the correct distance along -X.
module handhold_cutout_circles() {
    cutout_end();
    translate([-(handhold_size[0] - handhold_size[1]), 0, 0])
        cutout_end();
}

// The full handhold cut.
//
// Origin: center of "upper" cutout radius.
// Orientation: cutout extends down -X.
module handhold_cutout() {
    wood_diagram_color(side_color) hull() handhold_cutout_circles();
}

// Four cutout_ends spaced for the fourth corners of the window above
// the platform.
//
// Origin: the center of the circle at the upper counter-side corner.
// Orientation: counter-side edge along -X, top edge along -Y.
module upper_window_cutout_circles() {
        // upper counter-side corner is centered on origin
        cutout_end();

        // lower counter-side corner
        translate([-upper_window_height(), 0, 0])
            cutout_end();

        // upper non-counter-side corner
        translate([0, -upper_window_top_depth(), 0])
            cutout_end();

        // lower non-counter-side corner
        translate([-upper_window_height(), -upper_window_bottom_depth(), 0])
            cutout_end();
}

// The full upper window cutout.
//
// Origin and orientation ar the same as upper_window_cutout_circles.
module upper_window_cutout() {
    wood_diagram_color(side_color) hull() upper_window_cutout_circles();
}

// The circles at the upper corners of the window below the
// platform. (The bottom corners are not radiused.) The cutout needs
// to be moved in +Y the appropriate amount to leave space for the
// front steps.
//
// Origin: the point at which the non-counter-side edge of the window
// reaches the floor
// Orientation: circles are moved along +X toward the platform, and +Y
// toward the cabinet-side edge.
module lower_window_cutout_circles() {
    // upper non-counter-side corner
    translate([lower_window_height(),
               lower_window_upper_corner_offset(),
               0])
        cutout_end();

    // upper counter-side corner
    translate([lower_window_height(),
               lower_window_upper_corner_offset() + lower_window_top_depth(),
               0])
        cutout_end();
}

// The full lower window cutout.
//
// Origin and orientation are the same as lower_window_cutout_circles.
module lower_window_cutout() {
    wood_diagram_color(side_color) hull() {
        // lower non-counter-side edge is origin
        rotate([0, 0, front_angle()])
            // translated left to avoid rendering conflicts
            translate([-0.5, 0, 0])
            sheet_stock(1, 1, [0,0,2]);

        lower_window_cutout_circles();

        // lower counter-side edge
        translate([0, lower_window_bottom_depth(), 0])
            // the numerator here is the amount the bottom corner
            // of the window sticks past the top corner
            rotate([0, 0, -atan((lower_window_bottom_depth()
                                 - lower_window_top_depth()
                                 - lower_window_upper_corner_offset())
                                / lower_window_height())])
            translate([-0.5, -1, 0])
            sheet_stock(1, 1, [0,0,2]);
    }
}

// A module that positions an instance of its children at each
// platform "height", platform_depth away from the cabinet side. Since
// this is used for the side panel construction, the "heights" are set
// along the X axis, under the assumption that the side panel is
// laying flat.
module at_platform_positions() {
    for (h = platform_heights)
        translate([h, bottom_depth - platform_depth, 0])
            children();
}

// Creates dado nodes at every platform position. Subtract these from
// the side panel to create the dados.
module all_platform_dados() {
    at_platform_positions()
        platform_dado();
}

// Creates bolt hole nodes at every platform position. Subtract these
// from the side panel to create the holes.
module all_platform_bolt_holes() {
    at_platform_positions()
        platform_bolt_holes(thickness + 0.02);
}

// A module that positions an instance of its children at each front
// step "height", inset from the non-cabinet-side edge to match the
// front angle slope. Since this is used in the construction of the
// side panel, the "heights" are set along the X axis, as the side
// panel is laying flat.
module at_front_step_heights() {
    for (h = front_step_heights)
        translate([h, front_step_inset(h), 0]) children();
}

// Creates dado nodes at every front step position.
module all_front_step_dados() {
    at_front_step_heights() front_step_dado();
}

// Creates bolt hole nodes at every front step position.
module all_front_step_bolt_holes() {
    at_front_step_heights() front_step_bolt_holes(thickness + 0.02);
}

// Creates nodes for all cross-member rabbets and grooves.
module all_rabbets_and_grooves() {
    // under the front steps
    translate([0, (front_step_depth() - thickness) / 2, 0])
        narrow_support_groove();

    // on the bottom against the cabinets
    translate([thickness, bottom_depth - thickness, 0])
        narrow_support_rabbet();

    translate([height - narrow_support_height(),
               bottom_depth - thickness,
               0]) {
        // at the top against the counter
        narrow_support_rabbet();

        // between the platforms and the top support, against the
        // cabinets
        translate([-wide_support_height() * 1.25, 0, 0])
            wide_support_rabbet();
    }

    translate([height - safety_rail_height(),
               bottom_depth - platform_depth,
               0])
        safety_rail_groove();
}

function upper_handhold_position() =
    [height - handhold_size[1],
     bottom_depth - top_handhold_offset(),
     0];
module upper_handhold_position() {
    translate(upper_handhold_position()) children();
}

module upper_handhold_rotation() {
    rotate([0, 0, 90]) children();
}

module climbing_handhold_positions() {
    for (h = handhold_heights)
        translate([h, inset_for_handhold(h), 0])
            children();
}

module climbing_handhold_rotation() {
    rotate([0, 0, front_angle()]) children();
}

// Creates nodes for all handhold cutouts.
module all_handholds() {
    climbing_handhold_positions()
        climbing_handhold_rotation()
        handhold_cutout();

    // one more along the top edge
    upper_handhold_position()
        upper_handhold_rotation()
        handhold_cutout();
}

function upper_window_position() =
    [height - upper_window_inset(),
     bottom_depth - upper_window_inset(),
     0];

// Move the upper_window_cutout into position.
module upper_window_position() {
    translate(upper_window_position())
        children();
}

// Move the lower_window_cutout into position.
module lower_window_position() {
    translate([0, lower_window_inset(), 0])
        children();
}

// Creates nodes for all window cutouts.
module all_windows() {
    upper_window_position() upper_window_cutout();
    lower_window_position() lower_window_cutout();
}

// Construct the right side panel.
module right_side() {
    difference() {
        // Start with a blank.
        side_panel_blank();

        // Cut everything out of the blank.

        front_angle_cut();

        all_platform_dados();
        all_platform_bolt_holes();

        all_front_step_dados();
        all_front_step_bolt_holes();

        // Non-step/platform cross-members
        all_rabbets_and_grooves();

        all_handholds();

        all_windows();
    }
}

// The left side is a mirror of the right side.
module left_side() {
    // The mirror is along Z because the right side is constructed laying down.
    mirror([0, 0, 1]) right_side();
}

// Step and Platform.

// The platform has a convex curve and the front step has a concave
// one. They're supposed to match, so that both curves can be cut at
// once. This module is an ellipse defining that curve.
//
// The ellipse is shifted slightly along the Y axis, to remove the
// orthogonal ends from the cut. The `move_direction` parameter is a
// multiplier to adjust the amount and direction of this
// shift. Positive values shift the ellipse toward +Y, and negative
// values shift toward -Y.
//
// Since this module is used to cut, an "err" multiplier is also
// provided to help avoid rendering conflicts. This should generally
// be 1 or 0, with 1 providing 0.01 additional thickness above and
// below the elipse, and 0 profiding none.
//
// Origin: To the left of the ellipse, such that the center of the
// ellipse is in the center of the uninstalled step or platform
// width. Center is shifted off the Y axis to align the addition or
// cut on the X=0 plane. The bottom rests on Z=0 (or just below for
// err > 0).
// Orientation: wide axis along +X, narrow axis along Y. Thickness in
// +Z.
module step_platform_curve(move_direction, err=0) {
    // a ratio of the curve depth to be moved out of the cut or
    // addition to provide a more graceful curve
    ortho_shift = 0.25;
    translate([inter_recess_span() / 2,
               // cut out the orthogonal pointy ends of the ellipse
               move_direction * thickness * ortho_shift,
               -0.01 * err])
        // Scaling a cylinder is how you make an ellipse. The long
        // axis is the width of the platform, minus the amount it
        // sticks into the dados on either end. The short axis is just
        // a bit more than the thickness of the stock, so that
        // shifting it out (see above) leaves a curve with a depth
        // equal to the thickness of the stock.
        scale([(inter_recess_span() - recess_depth()) / 2,
               thickness * (1 + ortho_shift),
               1])
        cylinder(h=thickness + 0.02 * err, r=1);
}

// The movable front step.
//
// Origin: The bottom of the left-hand non-cabinet side corner. Note
// this means that the curve on the front is in -Y.
// Orientation: Installation direction.
module front_step() {
    difference() {
        // The basic step: rectangle plus front curve.
        wood_diagram_color(front_step_color) union() {
            sheet_stock(inter_recess_span(), front_step_depth());

            step_platform_curve(1);
        }

        // Holes for the threaded inserts, plus space for the bolt to
        // turn in past them if necessary.
        translate([0, 0, thickness])
            rotate([0, -90, 0])
            front_step_bolt_holes(bolt_hole_depth());

        translate([inter_recess_span(), 0, thickness])
            rotate([0, -90, 0])
            front_step_bolt_holes(bolt_hole_depth());
    }
}

// The movable platform.
//
// Origin: the bottom of the left-hand non-cabinet side corner.
// Orientation: Installation direction.
module platform() {
    difference() {
        // the basic rectangle of the step ...
        wood_diagram_color(platform_color)
            sheet_stock(inter_recess_span(), platform_depth);

        // ... without the material in the front curve
        wood_diagram_color(platform_color)
            step_platform_curve(-1, 1);

        // ... or the material in the bolt/insert holes
        translate([0, 0, thickness])
            rotate([0, -90, 0])
            platform_bolt_holes(bolt_hole_depth());

        translate([inter_recess_span(), 0, thickness])
            rotate([0, -90, 0])
            platform_bolt_holes(bolt_hole_depth());
    }
}

// The holes for bolts and threaded inserts. The hole for the bolt
// doesn't have to be this big, but it gives some wiggle room to make
// installation easier.
//
// Origin and orientation put the hole in the correct place for
// drilling through the side panels, relative to the top side of each
// dado.
//
// Origin: Hole centered on Y=0 plane, but shifted along -X half the
// thickness of the wood stock, and a tiny amount down -Z to prevent
// rendering conflicts.
// Orientation: Hole along the +Z axis.
module bolt_hole(depth) {
    wood_diagram_color(bolt_hole_color)
        // move half-way into the dado, or into the stock when rotated
        // around the Y axis
        translate([-thickness / 2, 0, -0.01])
        cylinder(h=depth, d=threaded_insert_od);
}

// Place one instance of whatever children are passed at an offset
// equal to each bolt hole offset in the front step (two instances
// total).
module front_step_bolt_positions() {
    translate([0, bolt_hole_step_front(), 0])
        children();
    translate([0, bolt_hole_step_rear(), 0])
        children();
}

// Two holes spaced for bolts at the front step.
module front_step_bolt_holes(depth) {
    front_step_bolt_positions() bolt_hole(depth);
}

// Two bolts spaced for securing the front step.
module front_step_bolts() {
    front_step_bolt_positions() bolt();
}

// Place one instance of whatever children are passed at an offset
// equal to each bolt hole offset in the platform (two instances
// total).
module platform_bolt_positions() {
    translate([0, bolt_hole_platform_front(), 0])
        children();
    translate([0, bolt_hole_platform_rear(), 0])
        children();
}

// Two holes space for bolts at the platform.
module platform_bolt_holes(depth) {
    platform_bolt_positions() bolt_hole(depth);
}

// Two bolts spaced for securing the platform.
module platform_bolts() {
    platform_bolt_positions() bolt();
}

// Permanently fixed cross-members.

// The size of support that goes at the bottom in the front and back,
// and at the top on the cabinet side. The orientation is as if it had
// just been cut to length on a table saw (i.e. laying flat).
//
// Origin: Corner.
// Orientation: Tower-width in +X, support height in +Y, stock
// thickness in +Z.
module narrow_support() {
    wood_diagram_color(narrow_support_color)
        sheet_stock(inter_recess_span(), narrow_support_height());
}

// The support that goes just above the platform on the cabinet side.
//
// Origin: Corner.
// Orientation: Tower-width in +X, support height in +Y, stock
// thickness in +Z.
module wide_support() {
    wood_diagram_color(wide_support_color)
        sheet_stock(inter_recess_span(), wide_support_height());
}

// Two screws, with washers, spaced for one end of a support of the
// given height.
module support_screws(support_height) {
    translate([0, screw_inset(), 0]) screw_with_washer();
    translate([0, support_height - screw_inset(), 0]) screw_with_washer();
}

// Two screws for one end of the narrow supports.
module narrow_support_screws() {
    support_screws(narrow_support_height());
}

// Two screws for one end of the wide support.
module wide_support_screws() {
    support_screws(wide_support_height());
}

// The stick at the top on the non-cabinet side, to prevent the person
// standing on the platform from falling off.
//
// Origin: Bottom left, non-cabinet-side corner.
// Orientation: tower width along +X, height of the rail along +Y,
// thickness in +Z.
module safety_rail() {
    wood_diagram_color(safety_rail_color)
        sheet_stock(inter_recess_span(), safety_rail_height());
}

// ASSEMBLY

// Animation timeline:
// major sections [start, end]
anim_platform_start = 0;
anim_step_start = 0.5;

// subsections [relative start, duration]
anim_remove_bolts = [0, 0.1];
anim_slide_out = [0.1, 0.1];
anim_change_height = [0.2, 0.1];
anim_slide_in = [0.3, 0.1];
anim_replace_bolts = [0.4, 0.1];

// Compute the amount of `distance` that should be applied based on
// the current time. This animation cycles: wait, out, wait, in.
//
// Starting at `$t = base_t+out_t[0]`, larger percentages of
// `distance` will be returned until 100% of `distance` is returned at
// `$t = base_t+out_t[0]+out_t[1]`.
//
// 100% of distance will continue to be returned until `$t =
// base_t+in_t[0]`, at which point smaller percentages will be
// returned, until 0 is returned at `$t = base_t+in_t[0]+in_t[1]`.
function out_in_anim(base_t, out_t, in_t, distance) =
    let (out_rel_t = $t - base_t - out_t[0],
         in_rel_t = $t - base_t - in_t[0])
    ((out_rel_t < 0) || (in_rel_t > in_t[1]))
    ? 0                                    // before out, or after in
    : ((out_rel_t < out_t[1])
       ? (distance * out_rel_t / out_t[1]) // moving out
       : ((in_rel_t > 0)
          ? (distance * (in_t[1] - in_rel_t) / in_t[1])  // moving in
          : distance));               // moved out, not yet moving in

// Do an out-in animation based on the slide_out and slide_in times.
function slide_anim(base_t, distance) =
    out_in_anim(base_t, anim_slide_out, anim_slide_in, distance);

// Do an out-in animation based on the remove_bolt and replace_bolt
// times.
function bolt_anim(base_t) =
    out_in_anim(base_t,
                anim_remove_bolts,
                anim_replace_bolts,
                bolt_length() * 1.25);

// Compute the amount of distance between `height1` and `height2` that
// should be applied, based on the current time. This animation is
// does not cycle: wait, move, wait. It is also based only on
// `anim_change_height`.
//
// Abbreviating: `ach` == `anim_change_height`
//               `diff` = `height2 - height1`
//
// Starting at `$t = base_t+ach[0]`, larger percentages of `diff` are
// returned, until 100% is returned at `$t = base_t+ach[0]+ach[1]`.
function height_anim(base_t, height1, height2) =
    let (height_diff = height2 - height1,
         rel_t = $t - base_t - anim_change_height[0])
    (rel_t < 0)
    ? 0                                 // before anim_change_height
    : ((rel_t < anim_change_height[1])
       ? (height_diff * rel_t / anim_change_height[1]) // during ach
       : height_diff);                   // after anim_change_height

// Compute where to place the front step, based on the current
// time. It will be at `position` from `$t = 0` until `$t =
// anim_step_start[0]+anim_slide_out[0]`, when it will begin moving
// until it reaches its final destination at `$t =
// anim_step_start[0]+anim_slide_in[0]+anim_slide_in[1]`, when it will
// be at `position2`.
//
// The `slide_scale` parameter allows this function to compute
// positions for the bolts as well. They do not move back and forth
// with the step (except to realign with the front angle slope), but
// they do move up and down. Setting `slide_scale` to 0 cancels the
// back and forth motion.
module place_front_step_at(position, position2, slide_scale=1) {
    translate([0,

               // basic out-in
               slide_anim(anim_step_start, -front_step_depth() * 1.25)
               * slide_scale
               // plus the change in offset, due to the front angle.
               // note that this component is not canceled by
               // slide_scale, because the bolts do have to move to
               // the new step offset
               + height_anim(anim_step_start,
                             front_step_inset(front_step_heights[position]),
                             front_step_inset(front_step_heights[position2])),

               // base height
               front_step_heights[position] - thickness
               // plus change
               + height_anim(anim_step_start,
                             front_step_heights[position],
                             front_step_heights[position2])])
        children();
}

// Compute where to place the platform, based on the current time. It
// will be at `position` from `$t = 0` until `$t =
// anim_platform_start[0]+anim_slide_out[0]`, when it will begin
// moving until it reaches its final destination at `$t =
// anim_platform_start[0]+anim_slide_in[0]+anim_slide_in[1]`, when it
// will be at `position2`.
//
// The `slide_scale` parameter allows this function to compute
// positions for the bolts as well. They do not move back and forth
// with the platform, but they do move up and down. Setting
// `slide_scale` to 0 cancels the back and forth motion.
module place_platform_at(position, position2, slide_scale=1) {
    translate([0,

               // base depth
               bottom_depth - platform_depth
               // plus the animation distance
               + slide_anim(anim_platform_start, platform_depth * 1.25)
               * slide_scale,

               // base height
               platform_heights[position] - thickness
               // plus the animation difference
               + height_anim(anim_platform_start,
                             platform_heights[position],
                             platform_heights[position2])])
        children();
}

// Stand up a left and right side panel, the corrent distance appart.
//
// Origin: Bottom, outside, non-cabinet-side corner of the left panel.
// Orientation: Panels stand parallel to the X=0 plane, in the
// positive-axes quadrant.
module assembly_side_panels() {
    rotate([0, -90, 0]) left_side();

    translate([width, 0, 0]) rotate([0, -90, 0]) right_side();
}

// All permanently fixed cross member supports, in their correct
// places, relative to assembly_side_panels. Screws and washers
// included.
module assembly_cross_members() {
    // under step
    translate([0, front_step_depth() / 2, 0]) {
        translate([// support is created against X=0. move it in the
                   // thickness of the side panel at the groove
                   thickness - recess_depth(),
                   // outer translation is to the middle of the
                   // rabbet. have to move the platform another half
                   // thickness to align its edges with the rabbet.
                   thickness / 2,
                   0])
            // component is created laying flat - stand it up
            rotate([90, 0, 0])
            narrow_support();
        // left side screws
        rotate([90, 0, 90]) narrow_support_screws();
        // right side screws
        translate([width, 0, 0])
            rotate([90, 0, -90])
            narrow_support_screws();
    }

    // bottom cabinet-side
    translate([0, bottom_depth, thickness]) {
        translate([thickness - recess_depth(), 0, 0])
            rotate([90, 0, 0])
            narrow_support();
        translate([0, -thickness / 2, 0]) {
            rotate([90, 0, 90]) narrow_support_screws();
            translate([width, 0, 0])
                rotate([90, 0, -90])
                narrow_support_screws();
        }
    }

    // top cabinet-side
    translate([0, bottom_depth, height - narrow_support_height()]) {
        translate([thickness - recess_depth(), 0, 0])
            rotate([90, 0, 0])
            narrow_support();
        translate([0, -thickness / 2, 0]) {
            rotate([90, 0, 90]) narrow_support_screws();
            translate([width, 0, 0])
                rotate([90, 0, -90])
                narrow_support_screws();
        }
    }

    // mid cabinet-side
    translate([0,
               bottom_depth,
               height - narrow_support_height()
               - wide_support_height() * 1.25]) {
        translate([thickness - recess_depth(), 0, 0])
            rotate([90, 0, 0])
            wide_support();
        translate([0, -thickness / 2, 0]) {
            rotate([90, 0, 90]) wide_support_screws();
            translate([width, 0, 0])
                rotate([90, 0, -90])
                wide_support_screws();
        }
    }

    // safety rail
    translate([0,
               bottom_depth - platform_depth + thickness,
               height - safety_rail_height()]) {
        translate([thickness - recess_depth(), 0, 0])
            rotate([90, 0, 0])
            safety_rail();
        translate([0, -thickness / 2, safety_rail_height() / 2]) {
            rotate([90, 0, 90]) screw_with_washer();
            translate([width, 0, 0]) rotate([90, 0, -90]) screw_with_washer();
        }
    }
}

// The front step, at its correct position, with bolts in place.
module assembly_front_step(position, position2=undef) {
    // Attempting to hide some of the animation mess. If animation
    // isn't relevant to the view, omit position2, and this just sets
    // it equal to position.
    def_pos2 = (position2 == undef) ? position : position2;
    place_front_step_at(position, def_pos2)
        translate([thickness - recess_depth(), 0, 0])
        front_step();
    place_front_step_at(position, def_pos2, slide_scale=0) {
        translate([-bolt_anim(anim_step_start), 0, thickness / 2])
            rotate([0, 90, 0])
            front_step_bolts();
        translate([width + bolt_anim(anim_step_start), 0, thickness / 2])
            rotate([0, -90, 0])
            front_step_bolts();
    }
}

// The platform, at its correct position, with bolts in place.
module assembly_platform(position, position2=undef) {
    // Attempting to hide some of the animation mess. If animation
    // isn't relevant to the view, omit position2, and this just sets
    // it equal to position.
    def_pos2 = (position2 == undef) ? position : position2;
    place_platform_at(position, def_pos2)
        translate([thickness - recess_depth(), 0, 0])
        platform();
    place_platform_at(position, def_pos2, slide_scale=0) {
        translate([-bolt_anim(anim_platform_start), 0, thickness / 2])
            rotate([0, 90, 0])
            platform_bolts();
        translate([width + bolt_anim(anim_platform_start), 0, thickness / 2])
            rotate([0, -90, 0])
            platform_bolts();
    }
}

// The whole assembly. Step and platform will be placed in "position",
// and animate to "position2" if animation is enabled. Set
// `use_finish_colors` to true to color all wood one (wood-like)
// color, bolts a second color, and screws and washers a third - as
// opposed to the rainbow colors used to differentiate the parts in
// construction descriptions.
module assembly(front_step_position=0, platform_position=1,
                front_step_position2=1, platform_position2=2,
                use_finish_colors=false) {
    $use_finish_colors = use_finish_colors;

    assembly_side_panels();

    assembly_cross_members();

    assembly_platform(platform_position, platform_position2);

    assembly_front_step(front_step_position, front_step_position2);
}

// Put an assembly in the scene. All views should `use` this SCAD, so
// this expression won't be evaluated.
assembly();
