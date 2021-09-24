# dotfiles

This ansible playbook contains my dotfiles and other system configuration as deployed on my PCs.

#### Where are the actual dotfiles?

*If you just want to take a look at the dotfiles themselves, go to `roles/dotfiles/files/dotfiles`.*
A few files are also templated and at `roles/dotfiles/templates`.


### Deploying

To deploy this, simply create an `inventory` file with the appropriate roles (see `site.yml`).

For the locking script, you will need a HASSIO token (lock state tracking). Supply with `-e "hassio_token=my_token"` when running `ansible-playbook`.

Additionally, you need some host vars. See `host_vars/host_vars.example` for a template.