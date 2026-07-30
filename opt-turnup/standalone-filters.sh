#!/usr/bin/bash

MODE=$1
IN=$2

function filter-gnuplot {
    local LINENUM=`grep -n '^-\+$' ${IN} | perl -pe 's/^(\d):-+$/\1/'`
    local LINECNT=`cat ${IN} | wc -l`
    if [ ! -z "${LINENUM}" ]; then
        echo "in_file=\"${IN}.dat\""        >  ${IN}.gp
        echo "out_file=\"./$$.svg\""        >> ${IN}.gp
        head -$((LINENUM - 1))       ${IN}  >> ${IN}.gp
        tail -$((LINECNT - LINENUM)) ${IN}  >  ${IN}.dat
        gnuplot ${IN}.gp
        rm ${IN}.gp
        rm ${IN}.dat
    fi
}
function filter-kaavio {
	kaavio ${IN} > ./$$.svg
}
function filter-mermaid {
    mmdc -p /opt/turnup/puppeteer-config.json -i ${IN} -o ./$$.svg > /dev/null
}
function filter-plantuml {
    local OPT=-Dfile.encoding=UTF-8
    local CFG=
    cat ${IN} | plantuml ${CFG} -pipe -tsvg > ./$$.svg
}

filter-${MODE}
cat ./$$.svg
rm  ./$$.svg
