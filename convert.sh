#!/bin/bash
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
nocolor=$(tput -T ansi sgr0)
python3 <<EOF 
import pandas as pd
pd.read_excel('input.xlsx').to_csv('output.txt')
EOF
mkdir -p generated
IFS=$'\n' read -rd '' -a rows <<< "$(sed 's&,,,,,,$&&gI' < output.txt |sed 's/^\([^"]*"[^,"]*\),/\1/gI' | sed -r 's/"(.*)"/\1/gI')"
companycreatingserials=Company
for ((i=1; i<${#rows[@]}; i++ ))
do
number[$i]=$(echo "${rows[$i]}" | awk --field-separator=, '{print $2}')
date[$i]=$(echo "${rows[$i]}" | awk --field-separator=, '{print $3}')
driveslot[$i]=$(echo "${rows[$i]}" | awk --field-separator=, '{print $4}')
highesttemp[$i]=$(echo "${rows[$i]}" | awk --field-separator=, '{print $5}')
health[$i]=$(echo "${rows[$i]}" | awk --field-separator=, '{print $6}')
time[$i]=$(echo "${rows[$i]}" | awk --field-separator=, '{print $7}')
totalwritten[$i]=$(echo "${rows[$i]}" | awk --field-separator=, '{print $9}')
model[$i]=$(echo "${rows[$i]}" | awk --field-separator=, '{print $10}')
serial[$i]=$(echo "${rows[$i]}" | awk --field-separator=, '{print $11}')
size[$i]=$(echo "${rows[$i]}" | awk --field-separator=, '{print $12}')
interface[$i]=$(echo "${rows[$i]}" | awk --field-separator=, '{print $13}')
wipetype[$i]=$(echo "${rows[$i]}" | awk --field-separator=, '{print $14}')

convert blankcert.png -fill black \
-pointsize 45 -font URWGothic-Demi -draw 'text 100,100 "'"${number[$i]}"'"' \
-pointsize 35 -font URWGothic-Demi -draw 'text 1150,900 "'"$companycreatingserials"'"' \
-pointsize 35 -font URWGothic-Demi -draw 'text 510,900 "'"${date[$i]}"'"' \
-pointsize 35 -font URWGothic-Demi -draw 'text 40,515 "'"${driveslot[$i]}"'"' \
-pointsize 35 -font URWGothic-Demi -draw 'text 40,590 "'"${health[$i]}"'"' \
-pointsize 35 -font URWGothic-Demi -draw 'text 40,670 "'"${size[$i]}"'"' \
-pointsize 35 -font URWGothic-Demi -draw 'text 40,750 "'"${totalwritten[$i]}"'"' \
-pointsize 35 -font URWGothic-Demi -draw 'text 40,820 "'"${time[$i]}"'"' \
-pointsize 35 -font URWGothic-Demi -draw 'text 40,880 "'"${interface[$i]}"'"' \
-pointsize 35 -font URWGothic-Demi -draw 'text 40,440 "'"${model[$i]}"'"' \
-pointsize 35 -font URWGothic-Demi -draw 'text 815,385 "'"${serial[$i]}"'"' \
-pointsize 55 -font code128.ttf -draw 'text 835,490 "'"${serial[$i]}"'"' \
-pointsize 55 -font code128.ttf -draw 'text 835,490 "'"${wipetype[$i]}"'"' \
generated/"${serial[i]}".png
echo -e "$green Generated Certificated $nocolor --- $red ${number[i]} $nocolor --- $yellow ${serial[i]}.png $nocolor"
done
