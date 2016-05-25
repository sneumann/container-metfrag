# MetFrag Docker

MetFrag is a tool for in-silico fragmentation for computer assisted identification of metabolite mass spectra.

## Building the Docker image

Building the docker file generally is not needed. You can pull it from the official dockerhub registry:

`docker search metfrag`
`docker pull korseby/metfrag`

## Using the Docker image

After building or pulling the image, you need to specify a settings.properties file in the docker run command line (Refer https://github.com/c-ruttkies/MetFragRelaunched for details on how to generate such a file.).

`docker run --publish=8080:8080 --log-driver=syslog --volume=settings.properties:/usr/src/MetFragRelaunched/MetFragWeb/src/main/webapp/resources/settings.properties:ro --name=metfrag-run -i -t -d korseby/metfrag`



