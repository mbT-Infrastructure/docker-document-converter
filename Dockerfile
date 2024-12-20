FROM madebytimo/java

RUN apt update -qq \
    && apt install -y -qq fonts-dejavu-extra libreoffice-calc-nogui \
    libreoffice-impress-nogui libreoffice-writer-nogui pandoc texlive-xetex \
    && rm -rf /var/lib/apt/lists/* \
    \
    && mkdir --parents /media/converter/input \
    && mkdir --parents /media/converter/output

COPY entrypoint.sh /entrypoint.sh
WORKDIR /media/converter/input

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "pdf" ]
