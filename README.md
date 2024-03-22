# Plans for Woodworking Projects

I'm often asked whether I have plans that I can share for the wood
projects I have built. Until now, the answer has been, "No." There
have always been plans, but they're not at all shareable. They're
sketches on a whiteboard, paper, or scrap. This repository is an
attempt to change that.

Here you'll find my experiments with 3D modeling to create shareable
plans. If you're primarily interested in using these plans as-is to
recreate these projects, you may prefer to browse the associated
[project website](https://woodworking-plans.beerriot.com)
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

You will need [ImageMagick](http://www.imagemagick.org) installed.

You'll also need a scattering of other common command line utilities:
make, grep, sed, most notably.

The entire site can be built with a single command: `make
release`. This will create a directory named `_site/`, and place a
standalone copy of the site in it. To deploy the site publicly, copy
the contents of the _site directory to wherever your webserver wants
them (this could include copying them to the `gh-pages` branch if you
want to deploy on Github Pages).

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

## Further Reading

If you're interested in digging into the models, have a look at
[README-models.md](README-models.md). It discusses the organization
of each project SCAD file.

If you're interested in improving the website, have a look at
[README-website.md](README-website.md). It discusses the organization
of the HTML files.
