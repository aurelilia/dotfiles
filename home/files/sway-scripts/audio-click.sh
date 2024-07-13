CURRENT=$(pactl get-default-sink)
if [ "$CURRENT" = "alsa_output.usb-Focusrite_Scarlett_Solo_USB-00.HiFi__hw_USB__sink" ]; then
    pactl set-default-sink alsa_output.pci-0000_0c_00.1.hdmi-stereo-extra3
else if [ "$CURRENT" = "alsa_output.pci-0000_0c_00.1.hdmi-stereo-extra3" ]; then
    pactl set-default-sink alsa_output.usb-Focusrite_Scarlett_Solo_USB-00.HiFi__hw_USB__sink
else
    pavucontrol
fi
fi
