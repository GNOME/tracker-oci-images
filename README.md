# Tracker container images

This repository builds container images suitable for building and testing
the [Tracker](https://gitlab.gnome.org/GNOME/tracker) and [Tracker
Miners](https://gitlab.gnome.org/GNOME/tracker-miners) projects.

Images are pushed to this project's [Docker
registry](https://gitlab.gnome.org/gnome/tracker-oci-images/container_registry)
automatically when changes are merged to the 'master' branch.

## Using the images in CI

To use these images in a GitLab CI pipeline, set the `image` key in the
`.gitlab-ci.yml` file to point to one of the images in this project's
repository:

    image: registry.gitlab.gnome.org/gnome/tracker-oci-images/amd64/fedora:latest

## Using the images locally

You can also try out images on your local machine. Here is an example which
opens a shell inside a Docker container:

    docker run -i -t registry.gitlab.gnome.org/gnome/tracker-oci-images/amd64/fedora:latest /bin/bash

# Related projects

[librsvg-oci-images](https://gitlab.gnome.org/GNOME/tracker/-/issues/218), on which this project is based.

[Freedesktop CI Templates](https://freedesktop.pages.freedesktop.org/ci-templates/templates.html), a
system for building base CI images on [gitlab.freedesktop.org](https://gitlab.freedesktop.org/).
