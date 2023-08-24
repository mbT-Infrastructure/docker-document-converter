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
    if [[ "$CONVERSION_FORMAT" == pdf ]]; then
        CONVERTED_DOCUMENT="/media/converter/output/$(basename "${DOCUMENT%.*}").pdf"
        pandoc --output "$CONVERTED_DOCUMENT" "/media/converter/input/$DOCUMENT"
    fi
    if [[ "$CONVERSION_FORMAT" == mediawiki ]]; then
        CONVERTED_DOCUMENT="/media/converter/output/$(basename "${DOCUMENT%.*}").mediawiki"
        pandoc --to mediawiki --output "$CONVERTED_DOCUMENT" "/media/converter/input/$DOCUMENT"
    fi
done
