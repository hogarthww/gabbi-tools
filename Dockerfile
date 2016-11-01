# ----------------------------------------------------------------------------#
# This Dockerfile runs the `gabbi-tools` service in a development mode.   #
# ----------------------------------------------------------------------------#
FROM ubuntu:14.04
MAINTAINER Tom Viner <tom.viner@hogarthww.com>

RUN apt-get update && apt-get install -y -qq python-virtualenv

ADD ./ /opt/gabbi-tools
ADD ./src/gabbi_tools/default_config.ini /etc/hogarth/gabbi-tools/config.ini

WORKDIR /opt/gabbi-tools
RUN echo "10.9.4.60 pypi-zonza.hogarthww.prv" >> /etc/hosts; make env

EXPOSE 8080
CMD ["make", "run"]