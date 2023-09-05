#!/usr/bin/env bash
set -e

CONVERSION_FORMAT="$1"

mkdir --parents /media/converter/input
mkdir --parents /media/converter/output

if [[ "$CONVERSION_FORMAT" == @(pdf|mediawiki) ]]; then
    shift
else
    echo "Conversion format \"${CONVERSION_FORMAT}\" not supported. Running input as command."
    exec "$@"
fi

for DOCUMENT in "$@"; do
    CONVERTED_DOCUMENT="/media/converter/output/$(basename "${DOCUMENT%.*}").pdf"
    DOCUMENT="/media/converter/input/$DOCUMENT"
    if [[ "$CONVERSION_FORMAT" == pdf ]]; then
        if [[ "$DOCUMENT" == *.@(doc|docx|dot|dotx|odp|ods|odt|otp|ots|ott|pot|potx|ppt|pptx|xls|xlt|xlsx|xltx) ]]; then
            libreoffice --convert-to pdf "$DOCUMENT" --outdir "$(dirname "$CONVERTED_DOCUMENT")"
        else
            pandoc --output "$CONVERTED_DOCUMENT" "$DOCUMENT"
        fi
    fi
    if [[ "$CONVERSION_FORMAT" == mediawiki ]]; then
        pandoc --to mediawiki --output "$CONVERTED_DOCUMENT" "/media/converter/input/$DOCUMENT"
    fi
done
