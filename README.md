# OGJFW TEMPLATE
Basic ObjFW template that provides a makefile and dockerfile for building.

By default `make` will build an executable named `program`, `make docker` uses docker to build the same executable and place it and the objfw shared libraries in the `docker-out` directory.

This project assumes that the objfw shared library files are in `LD_LIBRARY_PATH` and that the headers are in `C_INCLUDE_PATH`
The dockerfile provides a suitable environment for builds, running in a rootless container is recommended if you are building with containers.

The variables at the top of the makefile can be used to configure the build process and output.
