#!/bin/bash
rc4_encode(){
        rcsrc=${1}
        rckey=${2}
        klen=${#rckey}
        vlen=${#rcsrc}
        for i in `seq 1 ${klen}`
        do
                char_key=`echo ${rckey}|cut -b "$i"`
                asc_key[$((${i}-1))]=`printf "%d" "'${char_key}"`
        done
        for i in `seq 1 ${vlen}`
        do
                char_src=`echo ${rcsrc}|cut -b "$i"`
                asc_src[$((${i}-1))]=`printf "%d" "'${char_src}"`
        done
        for i in `seq 0 255`
        do
                key[${i}]=${asc_key[$((${i} % ${klen}))]}
                sbox[${i}]=${i}
        done
        j=0
        for i in `seq 0 255`
        do
                ((j=(${j}+${sbox[${i}]}+${key[${i}]})%256))
                tmp=${sbox[${i}]}
                sbox[${i}]=${sbox[${j}]}
                sbox[${j}]=${tmp}
        done
        a=0
        b=0
        rcdes=""
        for i in `seq 0 $((${vlen}-1))`
        do
                ((a=(${a}+1)%256))
                ((b=(${b}+${sbox[${a}]})%256))
                tmp=${sbox[${a}]}
                sbox[${a}]=${sbox[${b}]}
                sbox[${b}]=${tmp}
                ((c=(${sbox[${a}]}+${sbox[${b}]})%256))
                ((tmp=${asc_src[${i}]}^${sbox[${c}]}))
                rcdes=`printf "${rcdes}%02x" ${tmp}`
        done
        echo "${rcdes}"
}
if [ $# -eq 2 ]
then
        rc4_encode ${1} ${2}
fi
