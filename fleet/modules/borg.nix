{ ... }: {
  # Borg secrets
  age.secrets."borg-repokey".file = ../secrets/borg-repokey.age;
  age.secrets."borg-ssh-id".file = ../secrets/borg-ssh-id.age;
}
