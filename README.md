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
  * `assets/` and `_layouts`: support files for the associated project
    website (built with Jeykyll)
  * `Gemfile`, `Gemfile.lock`, and `_config.yaml`: configuration for
    Jekyll
  * other subdirectories: one subdirectory per project

Each project subdirectory contains at least three files:

  * `Makefile`: Automation for building this project's piece of the
    website.

  * `<project name>.scad`: The 3D model of the project.

  * `params.scad`: The base input parameters from which the model's
    measurements are derived.

  * `view-assembly.scad`: The view of the project to show at the top
    of its page. (Only required if using `common/Makefile.common` and
    the `common/project.html`.)

Each project subdirectory may also contain any of the following file:

  * `index.html`: This project's page on the website.

  * `view-<description>.scad`: A particular arrangement of project
    pieces and camera positioning, used to export images that will
    appear on the project website.

  * `README.md`: Particular details about this project's code or
    webpage build.

## Creating the website

You will need [OpenSCAD](https://openscad.org) installed. Once it is
installed, edit `Makefile.paths` to set `OPENSCAD` to the path of your
`openscad` executable.

You will need [Jekyll](https://jekyllrb.com/) installed. If you have
Ruby and Bundler already installed, running `bundler install` in this
directory will install the tested version of Jekyll and other
associated gems for you.

You'll also need a scattering of other common command line utilities:
make, grep, sed, most notably.

The entire site can be built with a single command: `make
release`. This will create a directory named `_site/`, and place a
standalone copy of the site in it. To deploy the site publicly,
checkout the `gh-pages` branch of the repo, and replace its contents
with the contents of the fully-built `_site/` directory.

The release build runs two stages.

 1. First, openscad converts all `view-*.scad` files to `view-*.png`
    files. It also processes `<project>.scad` and `params.scad` to
    produce `_data/<project>.yaml`. The resulting PNG files and data
    variables can be referenced from the HTML files.

 2. Second, Jekyll renders all HTML files and copy other static files
    to the `_site/` directory.

When developing, running each stage independently may be more useful.
Running `make` (without `release`) or `make all` will run the
SCAD-to-PNG-and-YAML convesion. Running `jekyll serve` after that will
process the HTML files and set up a local webserver. With `jekyll
serve` running, you can browse the locally-built site at
http://localhost:4000/ (or whatever URL `jekyll serve` prints). This
running server will also watch for changes to the files and reprocess
them, so you can see the changes in your browser by reloading the
page.

## Model Layout

At no other point in my life have I more subscribed to Hal Abelson's
classic SICP statement, "Programs must be written for people to read,
and only incidentally for machines to execute." The fact that a
computer can transform this model into a picture is a wonderful thing
for prototyping and explaining. But the purpose of these models is to
help a person build the project.

The projects here are simple enough that all of their components can
be defined in one file, along with the assembly of those components
into the final project. This may not be the case in the future, but
for now it keeps the basic model together in one place.

Models are divided into three sections: parameters, components, and
assembly.

### PARAMETERS

The parameters section should define all measurements of the
project. There are two kinds of parameters to consider: those that are
inputs from someone planning to build the project, and those that are
derived from the first set. For example, a bookshelf might expect
inputs of the width of the unit, and the thickness of its end pieces,
and then might derive the length of the shelves from those numbers.

Input parameters break the rule of everything being defined in the
model file. They should instead be defined in `params.scad`, and they
should be defined as simple variables. Defining them as variables
makes them easy to override at the commandline
(`-Dparameter=value`). Placing them in a separate file makes it easier
for view files to use them (`include <params.scad>`) while still
allowing the main model file to render objects in the scene.

Derived, or computed, parameters should be the first entries in the
main model file, and they should be derived as functions. Defining
them as functions allows view files to use them (`use <project.scad>`)
while still allowing the main model file to render objects in the
scene.

That bookshelf project mentioned earlier might have a `params.scad`
like so:

```
width=100
endThickness=10
```

And a main `bookshelf.scad` like so:

```
function shelfLength() = width - endThickness * 2;
```

If `common/Makefile.common` is used as the project's Makefile,
arranging parameters in this way has an additional benefit: their
values can be inserted into the project's `index.html` by surrounding
the parameter name with two opening and closing curly braces, and
prefixing them with `site.data.<project name>`,
e.g. `{{site.data.bookshelf.width}}` or
`{{site.data.bookshelf.shelfLength}}`.

In general, it makes sense to define parameters for nearly every value
used to construct the model and its components. It makes it possible
to create views and instructions that all update automatically to show
the correct values.

### COMPONENTS

This section is where the specification of the parts of the project
live. In general, components should build on each other, and each of
those components should be a separate OpenSCAD module. An example
progression for a bookcase might be:

 1. Modules defining the general pieces of wood to be used - 2x4s,
    1x8s, etc.
 2. Modules defining each piece of shaped wood - end cap, shelf plank,
    shelf support, shelf rib, etc.

For documenting the build later, I've found that it's useful to think
of component modules in terms of the steps needed to build them. Being
able to show a view of a component only partially finished can be
useful.

### ASSEMBLY

This is where the project comes together. In this section, components
should be assembled to create the final project.

The line dividing COMPONENTS from ASSEMBLY is a bit fuzzy. A shelf
might be made of slats, but a bookcase is made of shelves. The slats
not assembly, and the bookcase is not components, but what are the
shelves? So far, I've erred on the side of modules in components are
subtractive (cutting shapes, drilling holes, etc.), while modules in
assembly are additive (gluing or otherwise joining). This won't hold
for projects that glue to pieces together, and then cut the assembly,
but we'll figure out what that should look like when we have some of
those.

As with component modules, it's useful to think of assembly modules in
terms of the steps needed to build them. The laundry rack project, for
example, shows the arm assembly without one side attached in several
views.

## Views

Only one view is required in a project, and ony if it's using the
common Makefile and project page template (which it should). That is
`view-assembly.scad`. This view should be a 3D perspective view of the
finished object, that would allow someone to get a basic idea of what
the project is.

All other views are up to you. Any `view-*.scad` file will be rendered
into a `view-*.png` during the common build process.

A view file can specify commandline arguments that should be passed to
openscad when building it, by including a comment that starts
"//cmdline:". One comment only is allowed, and all arguments must be
on that one line of the file. Most views use this to specify the
projection type and final image size.

To avoid warnings that will stop the build process, if you set the
viewpoint of the scene using `$vpt`, `$vpr`, and `$vpd`, also add
`include <../common/echo-camera-arg.scad>` to the file. This will
allow the common Makefile to append a `--camera` commandline argument
to the openscad execution, which silences the warning.

### Key

I've found it useful for one of the views to be a "key". Like a key on
a map, this shows an example of each component. The components name,
the number of instances of that component, and some information about
its size are displayed as well. This can be a great aid for debugging:
looking at a component on its own, with some notes around it, often
makes problems clearer.

Tools for creating the key, and adding measurements can be found in
`common/labeling.scad`. The `sizeLabel`, `angleLabel` modules add
markers and text numbers to the scene to display lengths and
angles. The `thirdAngle` tool renders three copies of the component,
oriented so that it's possible to see the top of one, the front of
another, and the right side of the third at the same time. When
rendered looking in the direction of the positive Y axis, in
orthogonal projection, this has the effect if creating a [third-angle
projection](https://en.wikipedia.org/wiki/Multiview_projection#Third-angle_projection),
similar to an architectural drawing.

### Third-Angle

In addition to rendering components in the key as third-angle
drawings, adding a view of the assembled project in third-angle
projection can also be useful. It gives a good place to label
assembled sizes, as well as distances between pieces.
