FROM ryankurte/docker-rpi-emu
WORKDIR  /usr/rpi
ADD ./emulate-hypriot-nohead /usr/rpi/emulate-hypriot-nohead
ADD ./prepare-n-run /usr/rpi/prepare-n-run
ADD ./scripts/prepare-hypriot-qemu/prepare_for_qemu scripts/prepare-hypriot-qemu/prepare_for_qemu
EXPOSE 10022
ENTRYPOINT ["./prepare-n-run"]