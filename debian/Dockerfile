# ----------------------------------------------------------------------------#
# This Dockerfile creates a Debian package for the `gabbi-tools`    #
# service.                                                                    #
#                                                                             #
# Usage: cd .. && make dpkg                                                   #
# ----------------------------------------------------------------------------#
FROM ubuntu:14.04
MAINTAINER Tom Viner <tom.viner@hogarthww.com>

RUN apt-get update && apt-get install -y -qq software-properties-common
RUN add-apt-repository ppa:dh-virtualenv/stable
RUN apt-get update && apt-get install -y -qq build-essential debhelper devscripts equivs python3-dev


ADD ./ /root/gabbi-tools
RUN apt-get update && mk-build-deps --install /root/gabbi-tools/debian/control --tool "apt-get --force-yes -y"

RUN mkdir /mnt/dist
VOLUME /mnt/dist

WORKDIR /root/gabbi-tools

# NOTE: We're adding default_config.ini to the manpage like this because I don't
#       know how to source files in nroff. I tried the `.so` command but it
#       evaluates when you run `man` instead of compiling a manpage file.
RUN cat ./src/gabbi_tools/default_config.ini >> ./debian/gabbi-tools.1

ENV DH_VIRTUALENV_INSTALL_ROOT /opt/hogarth/
ENV DESTINATION_DPKG_DIR /mnt/dist/
CMD ["dpkg-buildpackage", "-us", "-uc", "-b", "--changes-option=-u/mnt/dist/"]