FROM madebytimo/base

RUN apt update -qq && apt install -y -qq pandoc texlive-latex-recommended && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir --parents /media/converter/input && \
    mkdir --parents /media/converter/output

COPY entrypoint.sh /entrypoint.sh
WORKDIR /media/converter/input

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "pdf" ]
