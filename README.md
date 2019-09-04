# personal-site

Repo for my [personal site](dylanjwolff.com)

Running from my apartment in Switzerland on a 32-bit Raspberry Pi. The site is statically hosted via an Nginx in a docker container. The code itself is Elm and markdown, using Elm-Bootstrap and CSS from [Bootswatch](https://bootswatch.com/lux/).

#### Notes:

* ```make deploy``` will build and deploy the entire project, but requires SSH keys and to be logged in to Docker Hub
* Web development can be done locally entirely within the web-app directory with a dev server set up through the makefile
* SSL certs are managed with LetsEncrypt/Certbot, with a cron job inside the container (initial expiring on December 2, 2019). As of now, the cert is on the host machine, and all files relating to it are mounted into the container at runtime.
* The ARM build can be built on x86 machines according to [this blog post](https://lobradov.github.io/Building-docker-multiarch-images/) using a statically linked QEMU binary. This requires you to run ```docker run --rm --privileged multiarch/qemu-user-static``` before building.

#### TODOS:

* Analytics [Fathom?](https://github.com/usefathom/fathom)
* Logging to e.g. Splunk
