# dotfiles
This ansible playbook contains my dotfiles and other system configuration as deployed on my PCs.

### Where are the actual dotfiles?
*If you just want to take a look at the dotfiles themselves, go to `roles/dotfiles/files/dotfiles`.*
A few files are also templated and at `roles/dotfiles/templates`.

## Deploying
### Requirements
For this to work, you'll need a local repo serving some AUR packages that ansible will be
trying to install. The configuration for this is in `roles/system/files/pacman.conf`.  
I recommend using `aurutils` for this.

**If you don't want to do this**, you can install them manually. Remove the marked section from
`roles/dotfiles/vars/main.yml` as well as the marked repo in `roles/system/files/pacman.conf`, and install the 
packages manually. The packages you'll need from the AUR are as follows:
`dracula-gtk-theme dracula-qt5-theme i3lock-fancy-git picom-git polybar tela-icon-theme ttf-comfortaa yay`

Finally, put your desired wallpapers into `data/wallpapers`. They are shuffled at login.

### Deploy
To deploy this, first modify the `inventory` to contain the hostnames of the devices you want to
deploy to, and change `remote_user` in `ansible.cfg`.  

For the locking script, you will need a HASSIO token (lock state tracking). Supply with `-e "hassio_token=my_token"` when running `ansible-playbook`.  
If you don't want to use this feature, simply supply the token "NONE".

Lastly, you need some host vars. See `host_vars/host_vars.example` for a template, 
copy it to for example `host_vars/my_hostname.yml` and change accordingly (hostname should match
the one put in `inventory`).

Then simply deploy with `ansible-playbook`; assuming your targets have a running ssh server
accepting connections and you aren't going to use HASSIO integration:
`ansible-playbook -K -e "hassio_token=NONE" site.yml`

### Warning regarding updates
These dotfiles are configured in such a way that they auto-update, meaning that they are
redeployed on `localhost` when a new commit on `origin/main` is found.  
For this to work, the repo must live in `~/.local/share/dotfiles`.  
Remove the last autostart entry in `.i3/config` to disable this.
