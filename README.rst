docker-gaviewer
=============
GAviewer was written to explore geometric algebra visually and as a companion to
the book 'Geometric Algebra for Computer Science' by Leo Durst, Daniel Fontijne
and Stephen Mann. This provides a graphical docker container to run gaviewer.

![GAviewer running in a browser](screenshot.png)

Overview
--------

This Docker image is derived from
[thewtex/opengl](https://github.com/thewtex/docker-opengl), which supports
rendering OpenGL-based applications. An X session is
running on display `:0` and can be viewed through an HTML5 viewer on any device
with a modern web browser (Mac OSX, Windows, Linux, Android, iOS, ChromeOS,
...).

Quick-start
-----------

Download and execute the
[`run.sh`](https://raw.githubusercontent.com/sbliven/docker-gaviewer/master/run.sh)
script. It requires Docker.

After starting the container, point your browser to the gaviewer process (e.g.
http://localhost:6080/).

GAviewer should automatically start (or run the `gaviewer` command). Book figures
can be loaded with:

1. 'File > Load .g directory' and select /home/user/Figures
2. Type `FIG(1,1)` at the console

If using run.sh, the host current working dir will be mounted at `/home/user/work`
for saving scripts.

Details
--------

By default, the `run.sh` start up the graphical session and points the user to
a URL on the local host where they can view and interact with the session. On
application exit, the `run.sh` will print the application's console output and
exit with the application's return code.

The session runs `Openbox <http://openbox.org>`_ as a non-root user, *user*
that has password-less sudo privileges. The browser view is an HTML5 viewer
that talks over websockets to a VNC Server. The VNC Server displays a running
Xdummy session.

The `run.sh` script can be used to drive start-up. It is customizable with
flags::

    Usage: run.sh [-h] [-q] [-c CONTAINER] [-i IMAGE] [-p PORT] [-r DOCKER_RUN_FLAGS]

This script is a convenience script to run Docker images based on
blivens/gaviewer. It:

- Makes sure docker is available
- On Windows and Mac OSX, creates a docker machine if required
- Informs the user of the URL to access the container with a web browser
- Stops and removes containers from previous runs to avoid conflicts
- Mounts the present working directory to /home/user/work on Linux and Mac OSX
- Includes figures from gaviewer in /home/user/Figures
- Starts gaviewer
- Exits with the same return code as gaviewer

Options:

    - `-h` Display this help and exit.
    - `-c` Container name to use (default opengl).
    - `-i` Image name (default thewtex/opengl).
    - `-p` Port to expose HTTP server (default 6080). If an empty string, the
      port is not exposed.
    - `-r` Extra arguments to pass to 'docker run'. E.g. `--env="APP=glxgears"`
    - `-q` Do not output informational messages.
    - `-v` Print debugging information

Running with docker
-------------------

To run directly from docker without using the run.sh script:

    docker run -d -v $PWD:/home/user/work -p 6080:6080 blivens/gaviewer

Building the image
------------------

The image can be built by running `make`.

Credits
-------

The Docker images is based heavily on
[thewtex/opengl](https://github.com/thewtex/docker-opengl),
which was in turn inspired by the `dit4c project <https://dit4c.github.io>`_.

GAviewer and the Figure code were created by Leo Dorst, Daniel Fontijne, and Stephen Mann.
They are licensed under GPL 2.0 and source code is distributed at
[geometricalgebra.org](https://geometricalgebra.org/code.html).
