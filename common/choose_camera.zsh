#!/bin/zsh
#
# If the view's cmdline option doesn't already include camera
# instructions, extract them from the $vpt, $vpr, and $vpd
# settings. Makefile.common uses this output so that --hardwarnings
# can be on, because otherwise openscad will issue a warning about
# $vpt/r/d overriding viewall, even if viewall wasn't specified.

grep -e "cmdline.*camera" -e "cmdline.*autocenter" -e "viewall" $1 > /dev/null
if [[ $? -ne 0 ]]; then
    VPT=$(grep "^\$vpt" $1 | sed -E -e "s/[^-.0-9]*([-.0-9]+)[^-.0-9]*([-.0-9]+)[^-.0-9]*([-.0-9]+)[^-.0-9]*/\1,\2,\3/")
    VPR=$(grep "^\$vpr" $1 | sed -E -e "s/[^-.0-9]*([-.0-9]+)[^-.0-9]*([-.0-9]+)[^-.0-9]*([-.0-9]+)[^-.0-9]*/\1,\2,\3/")
    VPD=$(grep "^\$vpd" $1 | sed -E -e "s/[^-.0-9]*([-.0-9]+)[^-.0-9]*/\1/")
    echo "--camera=${VPT},${VPR},${VPD}"
fi
