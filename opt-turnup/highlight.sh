#!/usr/bin/bash

IN=$1
OUT=$2
SYNTAX=$3
CLASS=$4
OPTIONS='-O html --fragment --stdout'

rm -f ./${OUT}

if [ ! -z "${CLASS}" ]; then
    echo "<div class='${CLASS}'>" >  ./${OUT}
fi

echo "<pre class='hl'>"                          >> ./${OUT}
highlight ${OPTIONS} --syntax ${SYNTAX} -i ${IN} >> ./${OUT}
echo "</pre>"                                    >> ./${OUT}

if [ ! -z "${CLASS}" ]; then
    echo "</div>"                 >> ./${OUT}
fi
