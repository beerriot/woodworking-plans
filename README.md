# Plans for Woodworking Projects

I'm often asked whether I have plans that I can share for the wood
projects I have built. Until now, the answer has been, "No." There
have always been plans, but they're not at all shareable. They're
sketches on a whiteboard, paper, or scrap. This repository is an
attempt to change that.

Here you'll find my experiments with 3D modeling to create shareable
plans. If you're primarily interested in using these plans as-is to
recreate these projects, you may prefer to browse the associated
[project website](https://beerriot.github.io/woodworking-plans)
instead of this code repository. That site organizes descriptions and
instructions with images to help you build each project.

If you're interested in altering the plans, or helping improve the
instructions, read on to learn what you'll find here.

## Organization

The files in this repository are:

  * `Makefile`: automated build script
  * `Makefile.paths`: file paths for the build script
  * `common/`: resources that the projects share
  * `site/`: support files for the associated project website
  * `release/`: created when building the website
  * other subdirectories: one subdirectory per project

Each project subdirectory contains one or more files:

  * `<project name>.scad`: The 3D model(s) of the project.

  * `view-<description>.scad`: A particular arrangement of project
    pieces and camera positioning, used to export images that will
    appear on the project website.

  * `Makefile`: The automation for creating this project's piece of
    the website.

  * `index.html`: This project's page on the website.

  * `README.md`: Particular details about this project's code or
    webpage build.

## Creating the website

You will need OpenSCAD installed. Once it is installed, edit
`Makefile.paths` to set `OPENSCAD` to the path of your `openscad`
executable.

At the top level of the repo, run `make release`. This will create a
subdirectory named `release/`. The contents of this directory and its
subdirectories are the website. To publish this on github, checkout
the `gh-pages` branch and replace all contents at the toplevel with
the contents of the `release/` directory.

## Model Layout

At no other point in my life have I more subscribed to Hal Abelson's
classic SICP statement, "Programs must be written for people to read,
and only incidentally for machines to execute." The fact that a
computer can transform this model into a picture is a wonderful thing
for prototyping and explaining. But the purpose of these models is to
help a person build the project.

The model is written in human-readable (and hopefully
human-understandable) code. My hope is that it's understandable
enough, that changing the model to meet someone's individual desires
is possible. This is the reason the model is broken into six sections:
input parameters, computed parameters, colors, components, key, and
assembly. Each section is described below.

The entire model is described in a single file (except for the tools
useful for all models, in the `common/` directory). The reason for
this has to do with tooling: when working in the OpenSCAD editor, it's
easiest if only one file needs to be changed, because all effects can
be seen in a single render. This can lead to a busy-looking primary
model file, both from a code perspective, and as a rendered
visual.

Two code practices help keep both views clean:

 1. Keep information about each component near each component. Size
    labels should be created in the same area of the code as the
    component they describe. The existing projects create them in the
    same module, enabled or disabled by a module parameter
    `includeLabels`.

 2. When adding something to the scene, always create a module for it,
    and then call that module. This includes the key and the final
    assembly. This makes it easy to create a rendering of only that
    thing in a separate `.scad` (e.g. `view-assembly.scad`) that calls
    only that module.

### INPUT PARAMETERS

This section captures expected adjustment knobs. For example, when
building a shelving unit, this section should include parameters for
the length, depth, and height of the case, as well as the number
and/or spacing of the shelves. This is also where options for how
thick/wide/long the stock to be used is.

### COMPUTED PARAMETERS

This section captures parameters of the project that are derived from
the input parameters. For example, instead of specifying the height of
each shelf of a bookcase as an input parameter, those heights might be
computed by dividing the input parameters of case height by shelf
count.

The dividing line between input and computed parameters is whether or
not someone should be changing it, if they are only intending to build
the project, and not change the underlying model. In general, someone
only building the project should not edit computed parameters - they
should only change input parameters.

### COLORS

Because this model is intended to guide someone through building the
project, it is often helpful to display different components in
different colors. This section is where those colors should be
specified.

### COMPONENTS

This section is where the specification of the parts of the project
live. In general, components should build on each other, and each of
those components should be a separate OpenSCAD model. An example
progression for a bookcase might be:

 1. Modules defining the general pieces of wood to be used - 2x4s,
    1x8s, etc.
 2. Modules defining each piece of shaped wood - end cap, shelf plank,
    shelf support, shelf rib, etc.

Each component should also include code for rendering itself in a
"key". The purpose of this is described in the KEY section, but it
should include extra objects that illustrate things like sizes and
angles. The tools in `common/labeling.scad` are likely to be useful
here.

### KEY

This section is not necessary to render a 3D model of the completed
project. This section is for displaying each component
individually. This part of the rendering is where it's possible to see
rabbets cut, holes drilled, etc. before assembly. The name and number
of each components is displayed as well.

The additional objects mentioned in the COMPONENTS section are
rendered here. For example, the `sizeLabel` tool from
`common/labeling.scad` can be used to show the dimensions of a
component.

For use outside of OpenSCAD, in a flat image on a website, the
`thirdAngle` tool in `common/labeling.scad` is useful. It renders
three copies of the component, oriented so that it's possible to see
the top of one, the front of another, and the right side of the third
at the same time. When rendered looking in the direction of the
positive Y axis, in orthogonal projection, this has the effect if
creating a [third-angle
projection](https://en.wikipedia.org/wiki/Multiview_projection#Third-angle_projection),
similar to an architectural drawing.

### ASSEMBLY

This is where the project comes together. In this section, components
should be assembled to create the final project.

The line dividing COMPONENTS from ASSEMBLY is a bit fuzzy. A shelf
might be made of slats, but a bookcase is made of shelves. The slats
not assembly, and the bookcase is not components, but what are the
shelves? Use your best judgement as to what is clearest to a
person in context. This organization can evolve.