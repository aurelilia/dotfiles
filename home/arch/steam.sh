flatpak install com.valvesoftware.Steam
flatpak override com.valvesoftware.Steam --unset-env=LIBGL_DRIVERS_PATH --unset-env=LIBVA_DRIVERS_PATH --unset=env=__EGL_VENDOR_LIBRARY_FILENAMES --unset-env=LD_LIBRARY_PATH
flatpak install com.valvesoftware.Steam.CompatibilityTool.Proton-GE
pacman -S vulkan-radeon
