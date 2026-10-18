#!/bin/bash

INPUT_FILE=$1
convert -density '150' -compress jpeg -quality 80 "${INPUT_FILE}" "int_${INPUT_FILE}"
# gs -dSAFER -dBATCH -dNOPAUSE -dNOCACHE -sDEVICE=pdfwrite -sColorConversionStrategy=LeaveColorUnchanged -dAutoFilterColorImages=true -dAutoFilterGrayImages=true -dDownsampleMonoImages=true -dDownsampleGrayImages=true -dDownsampleColorImages=true  -sPAPERSIZE=a4 -sOutputFile="int2_${INPUT_FILE}" "int_${INPUT_FILE}"
# Remove metadata
pdftk "int_${INPUT_FILE}" dump_data |sed -e 's/\(InfoValue:\)\s.*/\1\ /g' | pdftk "int_${INPUT_FILE}" update_info - output "c_${INPUT_FILE}"
# Remove intermediate file
rm "int_${INPUT_FILE}"

# ps2pdf -dPDFSETTINGS=/ebook file.pdf compressed.pdf
