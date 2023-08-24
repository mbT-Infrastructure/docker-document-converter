# document-converter image

This Container image extends the
[base image](https://github.com/mbT-Infrastructure/docker-base).
Make sure to also configure environment variables, ports and volumes from that image.

This image contains some document converters.

It converts specified files from `/media/converter/input` to the given format.

The command has to be in the format
```
FORMAT DOCUMENTS
```
where `FORMAT` is pdf or mediawiki and `DOCUMENT` is a file in the input folder.

## Volumes

- `/media/converter`
    - The input and output directory of the files to convert.
- `/media/converter/input`
    - The input directory of the files to convert.
- `/media/converter/output`
    - The output directory of the files to convert.


## Development

To build and run for development run:
```bash
docker compose --file docker-compose-dev.yaml up --build
```

To build the image locally run:
```bash
./docker-build.sh
```
