# Utils-Tool
This repository contains a collection of Makefiles designed to support development tasks.

## Udev rules
If you encounter an error such as `JTAG init failed with: Couldn't open device.`, you may need to install the required udev rules. To do so, run:

```bash
sudo cp 99-fpga.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules && sudo udevadm trigger # force udev to take new rule
```

Afterwards, log out and unplug/replug the device you want to program.