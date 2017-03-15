FROM ryankurte/docker-rpi-emu
WORKDIR  /usr/rpi
ADD ./emulate-hypriot-nohead /usr/rpi/emulate-hypriot-nohead
ADD ./prepare-n-run /usr/rpi/prepare-n-run
COPY scripts /usr/rpi/scripts
EXPOSE 10022
ENTRYPOINT ["./prepare-n-run"]