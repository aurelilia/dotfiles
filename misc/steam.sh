flatpak override com.valvesoftware.Steam --unset-env=LIBGL_DRIVERS_PATH --unset-env=LIBVA_DRIVERS_PATH --unset=env=__EGL_VENDOR_LIBRARY_FILENAMES
flatpak override com.valvesoftware.Steam --filesystem=/home/leela/.local/share/Steam
pacman -S vulkan-radeon
