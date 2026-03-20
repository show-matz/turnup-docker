#!/usr/bin/bash

MODE=$1
IN=$2
OUT=$3
SUFFIX=svg
CACHE=.cache

function filter-gnuplot {
    local LINENUM=`grep -n '^-\+$' ${IN} | perl -pe 's/^(\d):-+$/\1/'`
    local LINECNT=`cat ${IN} | wc -l`
    if [ ! -z "${LINENUM}" ]; then
        echo "in_file=\"${IN}.dat\""              >  ${IN}.gp
        echo "out_file=\"./${CACHE}/${OUT}.svg\"" >> ${IN}.gp
        head -$((LINENUM - 1))       ${IN}        >> ${IN}.gp
        tail -$((LINECNT - LINENUM)) ${IN}        >  ${IN}.dat
        gnuplot ${IN}.gp
        rm ${IN}.gp
        rm ${IN}.dat
    fi
}
function filter-kaavio {
	kaavio ${IN} > ./${CACHE}/${OUT}.${SUFFIX}
}
function filter-mermaid {
    mmdc -p /opt/turnup/puppeteer-config.json -i ${IN} -o ./${CACHE}/${OUT}.${SUFFIX} > /dev/null
}
function filter-plantuml {
    local OPT=-Dfile.encoding=UTF-8
    local CFG=
    cat ${IN} | plantuml ${CFG} -pipe -tsvg >> ./${CACHE}/${OUT}.${SUFFIX}
}

if [ ! -e ./${CACHE} ]; then
    mkdir ${CACHE}
fi

if [ -e ./${CACHE}/${OUT}.${SUFFIX} ]; then
    touch ./${CACHE}/${OUT}.${SUFFIX}
else
    filter-${MODE}
fi

echo "<div align='center'>"     >  ./${OUT}
cat ./${CACHE}/${OUT}.${SUFFIX} >> ./${OUT}
echo "</div>"                   >> ./${OUT}
