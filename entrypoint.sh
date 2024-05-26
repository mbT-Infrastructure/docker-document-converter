#!/usr/bin/env bash
set -e

CONVERSION_FORMAT="$1"

mkdir --parents /media/converter/input
mkdir --parents /media/converter/output

if [[ "$CONVERSION_FORMAT" == @(mediawiki|pdf|presentation) ]]; then
    shift
else
    echo "Conversion format \"${CONVERSION_FORMAT}\" not supported. Running input as command."
    exec "$@"
fi

function convertToMediaWiki {
    local DOCUMENT="$1"
    local CONVERTED_DOCUMENT="${2}.mediawiki"
    pandoc --to mediawiki --output "$CONVERTED_DOCUMENT" "$DOCUMENT"
}

function convertToPdf {
    local DOCUMENT="$1"
    local CONVERTED_DOCUMENT="${2}.pdf"
    if [[ "$DOCUMENT" == *.@(doc|docx|dot|dotx|odp|ods|odt|otp|ots|ott|pot|potx|ppt|pptx|xls|\
xlt|xlsx|xltx) ]]; then
        libreoffice --convert-to pdf "$DOCUMENT" --outdir "$(dirname "$CONVERTED_DOCUMENT")"
    else
        local ADDITIONAL_ARGUMENTS=()
        if [[ "$DOCUMENT" == *.@(md) ]]; then
            ADDITIONAL_ARGUMENTS+=(--from
                commonmark+footnotes+pipe_tables+superscript+subscript+yaml_metadata_block)
        fi
        pandoc --output "$CONVERTED_DOCUMENT" --pdf-engine xelatex \
            --variable "geometry:margin=2cm" --variable "mainfont=DejaVu Sans" \
            --variable "monofont=DejaVu Sans Mono" --variable documentclass=scrartcl \
            "${ADDITIONAL_ARGUMENTS[@]}" "$DOCUMENT"
    fi
}

function convertToPresentation {
    local DOCUMENT="$1"
    local CONVERTED_DOCUMENT="${2}.pptx"
    pandoc --output "$CONVERTED_DOCUMENT" "$DOCUMENT"
}

for DOCUMENT in "$@"; do
    CONVERTED_DOCUMENT_WITHOUT_EXTENSION="/media/converter/output/$(basename "${DOCUMENT%.*}")"
    DOCUMENT="/media/converter/input/$DOCUMENT"
    if [[ "$CONVERSION_FORMAT" == pdf ]]; then
        convertToPdf "$DOCUMENT" "$CONVERTED_DOCUMENT_WITHOUT_EXTENSION"
    elif [[ "$CONVERSION_FORMAT" == mediawiki ]]; then
        convertToMediaWiki "$DOCUMENT" "$CONVERTED_DOCUMENT_WITHOUT_EXTENSION"
    elif [[ "$CONVERSION_FORMAT" == presentation ]]; then
        convertToPresentation "$DOCUMENT" "$CONVERTED_DOCUMENT_WITHOUT_EXTENSION"
    fi
done
