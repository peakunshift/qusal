# sys-usb

PCI handler of USB devices in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Access control](#access-control)
* [Usage](#usage)
* [Credits](#credits)

## Description

Setup named disposables for USB qubes. During creation, it tries to separate
the USB controllers to different qubes is possible.

## Installation

- Top:
```sh
sudo qubesctl top.enable sys-usb
sudo qubesctl --targets=tpl-sys-usb state.apply
sudo qubesctl top.disable sys-usb
```

- State:
<!-- pkg:begin:post-install -->
```sh
sudo qubesctl state.apply sys-usb.create
sudo qubesctl --skip-dom0 --targets=tpl-sys-usb state.apply sys-usb.install
```
<!-- pkg:end:post-install -->

If you use an USB keyboard, also run:
```sh
sudo qubesctl state.apply sys-usb.keyboard
```

Install the proxy on the client template:
```sh
sudo qubesctl --skip-dom0 --targets=tpl-QUBE state.apply sys-usb.install-client-proxy
```

If the client requires decrypting a device, install on the client template:
```sh
sudo qubesctl --skip-dom0 --targets=tpl-QUBE state.apply sys-usb.install-client-cryptsetup
```

If the client requires a FIDO device, install on the client template:
```sh
sudo qubesctl --skip-dom0 --targets=tpl-QUBE state.apply sys-usb.install-client-fido
```
And enable the CTAP Proxy service for the client qubes:
```sh
qvm-features QUBE service.qubes-ctap-proxy 1
```

## Access control

No extra services are implemented, consult upstream to learn how to use the
following services:
- `qubes.InputMouse`, `qubes.InputKeyboard`, `qubes.InputTablet`;
- `ctap.GetInfo`, `ctap.ClientPin`, `u2f.Register`, `u2f.Authenticate`,
  `policy.RegisterArgument`.

## Usage

Depending on you system, one or more USB qubes will be created to hold the
different controllers. The qube names are `disp-sys-usb`, `disp-sys-usb-left`,
`disp-sys-usb-dock`.

Start a USB qube an connect a device to it.  USB PCI devices will appear on
the system tray icon `qui-devices`. From there, assign it to the intended
qube.

## Credits

- [Unman](https://github.com/unman/shaker/blob/main/sys-usb)
