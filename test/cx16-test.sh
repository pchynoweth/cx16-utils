#/usr/bin/bash -xc

# TODO: simplify gawk command
x16emu -scale 4 -debug -keymap en-gb -prg $1 -warp -echo -run | gawk 'BEGIN{ RES=1; }; { print }; /^(PASSED)$/{ RES=0; exit 0; }; /^(FAILED)$/{ RES=1; exit 1; }; END{ exit RES; }'
exit $?