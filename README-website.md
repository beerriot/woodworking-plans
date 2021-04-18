The website is built using Jekyll. While this means learning an
additional tool on top of HTML, it provides some useful benefits to
increasing the site's usability.

The layout of the site is controlled with
[Pure.css](https://purecss.io). This mostly defines a responsive
column layout, so that pages render well on both desktop and mobile
devices.

## Page Layouts

There are two main page layout templates in the `_layouts/`
folder. The `default` template includes everything that appears on
every page, like the navigation bar and copyright/license note. This
is where the top-level `pure-g` div lives, in which all page-specific
content should go.

The `project` template builds on the `default` template. Currently it
only adds an assembly preview to the top of the page. Other things
that every project should have (model downloads?) should be added to
this template.

## Project Pages

Each project should have an `index.html` in its directory. That file
should start like this:

```
---
title: [Insert title of project here]
layout: project
copyright: [year] [Author]
project: true
---
```

The `layout: project` line chooses the project template mentioned
earlier. The `project: true` line is used to determine where the link
to the project goes in the navigation bar. The contents of the `title`
and `copyright` lines will be inserted into the correct places in the
template.

Any number of additional preview images, and a short description
should follow. These will be shown immediately below the assembly
preview added by the project template.

Each piece of content on a page should be inside of a `pure-u-1` div:

```
<div class="pure-u-1">
   [content goes here]
</div>
```

To create multi-column sections, add additional classes to the
div. These are based on screen size in the Pure.css system. For
example, to specify that three preview images can be shown
side-by-side on large screens, add `pure-u-lg-1-3` to each image's
div:

```
<div class="pure-u-1 pure-u-lg-1-3">
   [preview image 1]
</div>
<div class="pure-u-1 pure-u-lg-1-3">
   [preview image 2]
</div>
<div class="pure-u-1 pure-u-lg-1-3">
   [preview image 3]
</div>
```

An "include" (Jekyll/Liquid term) called `preview_image.html` is
available to make creating images with the correct accessibility
tags. For example, this will show `view-key.png` in a way that scales
it to the screen space available, allows a viewer to click it to see
detail, provides alt text to screen readers, and shows a tooltip on
hover or long-press:

```
<div class="pure-u-1">
   {% include preview_image.html image="view-key.png"
      description="Key to the components of the project." %}
</div>
```

## Steps

Some pages include step-by-step instructions for building the
projects. Each step starts with a header numbering and naming the
step. That looks like this:

```
{% capture step_first_cut %}{% increment prj_step %}{% endcapture %}
{% include step_heading.html number=step_first_cut
title="The first cut is the deepest." %}
```

This produces and HTML header tag with the title text, and a
`step[number]` anchor. The `capture` instruction is a little verbose,
but it allows you to write and re-write instructions, without worrying
about renumbering the steps. The current step number is kept in the
variable appearing after `increment` (that's `prj_step` here). That
value is copied to `step_first_cut` at this point, and then passed to
the `step_heading.html` include.

Why not skip the `capture` and just pass the increment directly?
First, Liquid (the templating system used by Jekyll) doesn't support
that. Second, it allows you to reference this step from a later
step. For example, you might want to say, "Using the piece you made in
Step 1..." You can do that like so:

```
Using the piece you made in {% include step_link.html number=step_first_cut %}...
```

Important: The `prj_` on the front of `prj_step` is required to make
sure that this step counter only applies to this page. If multiple
projects were to use the same counter name (e.g. `step` without any
prefix), each project's step numbering would pick up where the last
project left off!

## Figures

In addition to extra preview images, "view" scads can be used to make
detailed images to support the instruction text. To include a view in
a step, use the `feature.html` include:

```
{% capture figure_cut_angle %}{% increment prj_fig %}{% endcapture %}
{% include figure.html number=figure_cut_angle
image="view-cut-angle.png"
caption="Cut the board at a 15&deg; angle." %}
```

As with steps, incrementing and capturing a counter provides a
sequence number that is used in the caption (e.g. "Figure 1: ...") and
in an anchor (e.g. `#figure1`). The include also makes the image
scalable and clickable, as with preview images.

To reference a figure in the instruction text, use the
`figure_link.html` include:

```
See {% include figure_link.html number=figure_cut_angle %} for detail.
```

## Values from the model

The value of any variables in a model's `params.scad`, and the values
of any zero-parameter functions in the main model SCAD are available
for including in the page. This is done via addition of a "data file"
(Jekyll term) named for the project. This data file is created
automatically during the build process.

For example, if a model's params file defines:

```
length = 20;
height = 10;
```

And the main model defines:

```
function hypotenuse() = sqrt(length * length + height * height);
```

Then the values of these elements can be used in the page like so:

```
A right triangle with length {{length}} and height {{height}} has a
hypotenuse of {{hypotenuse}}.
```

And that will produce text on the page that says:

```
A right triangle with length 20 and height 10 has a hypotenuse of 22.36.
```

Note that all values are arounded to two decimal places. All models
current use centimeters as their units. Since these models are for
woodworking, sizes below one-tenth of a millimeter can be ignored in
favor of easier readability.