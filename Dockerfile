FROM multiarch/debian-debootstrap:armhf-buster-slim

ENV APP_DIR /home/domoticz/stable

RUN apt-get update && apt-get upgrade -y \
	&& apt-get install -y \
	curl unzip wget libudev-dev libcurl4 libusb-0.1 libcurl3-gnutls libpython3-dev \
    python3-pip libglib2.0-dev git \
	&& rm -rf /var/lib/apt/lists/*

RUN pip3 install bluepy

RUN useradd -m domoticz

# USER domoticz
WORKDIR ${APP_DIR}
RUN ["/bin/bash", "-c", "set -o pipefail && wget -qO - https://releases.domoticz.com/releases/release/domoticz_linux_armv7l.tgz | tar xz -C ./"]
RUN git clone https://github.com/flatsiedatsie/Mi_Flower_mate_plugin ./plugins/Mi_Flower_mate_plugin

HEALTHCHECK CMD curl -so /dev/null -I http://localhost:8080 || exit 1

ENTRYPOINT ["./domoticz"]
CMD ["-sslwww", "0"]
EXPOSE 8080

