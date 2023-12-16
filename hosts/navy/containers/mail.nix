{...}:
let
  ports = [ 25 143 465 587 993 ];
  caddyDir = "/containers/caddy/";
  mailDir = "/containers/mail/";
  fqdn = "mail.elia.garden";
in {
  # Network
  networking.firewall = {
    allowedTCPPorts = ports;
    allowedUDPPorts = ports;
  };

  virtualisation.oci-containers.containers.mail = {
    image = "ghcr.io/docker-mailserver/docker-mailserver:latest";
    autoStart = true;

    extraOptions = [
      "--hostname=${fqdn}"
      "--cap-add=NET_ADMIN"
      "--env-file=/etc/mailserver.env"
    ];

    ports = [
      "25:25"    # SMTP  (explicit TLS => STARTTLS)
      "143:143"  # IMAP4 (explicit TLS => STARTTLS)
      "465:465"  # ESMTP (implicit TLS)
      "587:587"  # ESMTP (explicit TLS => STARTTLS)
      "993:993"  # IMAP4 (implicit TLS)
    ];
    volumes = [
      "${mailDir}/docker-data/dms/mail-data/:/var/mail/"
      "${mailDir}/docker-data/dms/mail-state/:/var/mail-state/"
      "${mailDir}/docker-data/dms/mail-logs/:/var/log/mail/"
      "${mailDir}/docker-data/dms/config/:/tmp/docker-mailserver/"
      "/etc/localtime:/etc/localtime:ro"
        "${caddyDir}/data/caddy/certificates/acme-v02.api.letsencrypt.org-directory/${fqdn}/${fqdn}.crt:/etc/letsencrypt/live/${fqdn}/fullchain.pem"
        "${caddyDir}/data/caddy/certificates/acme-v02.api.letsencrypt.org-directory/${fqdn}/${fqdn}.key:/etc/letsencrypt/live/${fqdn}/privkey.pem"
    ];
  };
  
  environment.etc."mailserver.env".text = ''
    # -----------------------------------------------
    # --- Mailserver Environment Variables ----------
    # -----------------------------------------------

    # DOCUMENTATION FOR THESE VARIABLES IS FOUND UNDER
    # https://docker-mailserver.github.io/docker-mailserver/latest/config/environment/

    # -----------------------------------------------
    # --- General Section ---------------------------
    # -----------------------------------------------

    # empty => uses the `hostname` command to get the mail server's canonical hostname
    # => Specify a fully-qualified domainname to serve mail for.  This is used for many of the config features so if you can't set your hostname (e.g. you're in a container platform that doesn't let you) specify it in this environment variable.
    OVERRIDE_HOSTNAME=

    # REMOVED in version v11.0.0! Use LOG_LEVEL instead.
    DMS_DEBUG=0

    # Set the log level for DMS.
    # This is mostly relevant for container startup scripts and change detection event feedback.
    #
    # Valid values (in order of increasing verbosity) are: `error`, `warn`, `info`, `debug` and `trace`.
    # The default log level is `info`.
    LOG_LEVEL=info

    # critical => Only show critical messages
    # error => Only show erroneous output
    # **warn** => Show warnings
    # info => Normal informational output
    # debug => Also show debug messages
    SUPERVISOR_LOGLEVEL=

    # 0 => mail state in default directories
    # 1 => consolidate all states into a single directory (`/var/mail-state`) to allow persistence using docker volumes
    ONE_DIR=1

    # **empty** => use FILE
    # LDAP => use LDAP authentication
    # OIDC => use OIDC authentication (not yet implemented)
    # FILE => use local files (this is used as the default)
    ACCOUNT_PROVISIONER=

    # empty => postmaster@domain.com
    # => Specify the postmaster address
    POSTMASTER_ADDRESS=

    # Check for updates on container start and then once a day
    # If an update is available, a mail is sent to POSTMASTER_ADDRESS
    # 0 => Update check disabled
    # 1 => Update check enabled
    ENABLE_UPDATE_CHECK=1

    # Customize the update check interval.
    # Number + Suffix. Suffix must be 's' for seconds, 'm' for minutes, 'h' for hours or 'd' for days.
    UPDATE_CHECK_INTERVAL=1d

    # Set different options for mynetworks option (can be overwrite in postfix-main.cf)
    # **WARNING**: Adding the docker network's gateway to the list of trusted hosts, e.g. using the `network` or
    # `connected-networks` option, can create an open relay
    # https://github.com/docker-mailserver/docker-mailserver/issues/1405#issuecomment-590106498
    # The same can happen for rootless podman. To prevent this, set the value to "none" or configure slirp4netns
    # https://github.com/docker-mailserver/docker-mailserver/issues/2377
    #
    # none => Explicitly force authentication
    # container => Container IP address only
    # host => Add docker container network (ipv4 only)
    # network => Add all docker container networks (ipv4 only)
    # connected-networks => Add all connected docker networks (ipv4 only)
    PERMIT_DOCKER=host

    # Set the timezone. If this variable is unset, the container runtime will try to detect the time using
    # `/etc/localtime`, which you can alternatively mount into the container. The value of this variable
    # must follow the pattern `AREA/ZONE`, i.e. of you want to use Germany's time zone, use `Europe/Berlin`.
    # You can lookup all available timezones here: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List
    TZ=

    # In case you network interface differs from 'eth0', e.g. when you are using HostNetworking in Kubernetes,
    # you can set NETWORK_INTERFACE to whatever interface you want. This interface will then be used.
    #  - **empty** => eth0
    NETWORK_INTERFACE=

    # empty => modern
    # modern => Enables TLSv1.2 and modern ciphers only. (default)
    # intermediate => Enables TLSv1, TLSv1.1 and TLSv1.2 and broad compatibility ciphers.
    TLS_LEVEL=

    # Configures the handling of creating mails with forged sender addresses.
    #
    # **0** => (not recommended) Mail address spoofing allowed. Any logged in user may create email messages with a forged sender address (see also https://en.wikipedia.org/wiki/Email_spoofing).
    # 1 => Mail spoofing denied. Each user may only send with his own or his alias addresses. Addresses with extension delimiters(http://www.postfix.org/postconf.5.html#recipient_delimiter) are not able to send messages.
    SPOOF_PROTECTION=

    # Enables the Sender Rewriting Scheme. SRS is needed if your mail server acts as forwarder. See [postsrsd](https://github.com/roehling/postsrsd/blob/master/README.md#sender-rewriting-scheme-crash-course) for further explanation.
    #  - **0** => Disabled
    #  - 1 => Enabled
    ENABLE_SRS=0

    # Enables the OpenDKIM service.
    # **1** => Enabled
    #   0   => Disabled
    ENABLE_OPENDKIM=1

    # Enables the OpenDMARC service.
    # **1** => Enabled
    #   0   => Disabled
    ENABLE_OPENDMARC=1


    # Enabled `policyd-spf` in Postfix's configuration. You will likely want to set this
    # to `0` in case you're using Rspamd (`ENABLE_RSPAMD=1`).
    #
    # - 0     => Disabled
    # - **1** => Enabled
    ENABLE_POLICYD_SPF=1

    # 1 => Enables POP3 service
    # empty => disables POP3
    ENABLE_POP3=

    # Enables ClamAV, and anti-virus scanner.
    #   1   => Enabled
    # **0** => Disabled
    ENABLE_CLAMAV=0

    # Enables Rspamd
    # **0** => Disabled
    #   1   => Enabled
    ENABLE_RSPAMD=0

    # When `ENABLE_RSPAMD=1`, an internal Redis instance is enabled implicitly.
    # This setting provides an opt-out to allow using an external instance instead.
    # 0 => Disabled
    # 1 => Enabled
    ENABLE_RSPAMD_REDIS=

    # When enabled,
    #
    # 1. the "[autolearning][rspamd-autolearn]" feature is turned on;
    # 2. the Bayes classifier will be trained when moving mails from or to the Junk folder (with the help of Sieve scripts).
    #
    # **0** => disabled
    # 1     => enabled
    RSPAMD_LEARN=0

    # This settings controls whether checks should be performed on emails coming
    # from authenticated users (i.e. most likely outgoing emails). The default value
    # is `0` in order to align better with SpamAssassin. We recommend reading
    # through https://rspamd.com/doc/tutorials/scanning_outbound.html though to
    # decide for yourself whether you need and want this feature.
    RSPAMD_CHECK_AUTHENTICATED=0

    # Controls whether the Rspamd Greylisting module is enabled.
    # This module can further assist in avoiding spam emails by greylisting
    # e-mails with a certain spam score.
    #
    # **0** => disabled
    # 1     => enabled
    RSPAMD_GREYLISTING=0

    # Can be used to enable or disable the Hfilter group module.
    #
    # - 0     => Disabled
    # - **1** => Enabled
    RSPAMD_HFILTER=1

    # Can be used to control the score when the HFILTER_HOSTNAME_UNKNOWN symbol applies. A higher score is more punishing. Setting it to 15 is equivalent to rejecting the email when the check fails.
    #
    # Default: 6
    RSPAMD_HFILTER_HOSTNAME_UNKNOWN_SCORE=6

    # Amavis content filter (used for ClamAV & SpamAssassin)
    # 0 => Disabled
    # 1 => Enabled
    ENABLE_AMAVIS=0

    # -1/-2/-3 => Only show errors
    # **0**    => Show warnings
    # 1/2      => Show default informational output
    # 3/4/5    => log debug information (very verbose)
    AMAVIS_LOGLEVEL=0

    # This enables DNS block lists in Postscreen.
    # Note: Emails will be rejected, if they don't pass the block list checks!
    # **0** => DNS block lists are disabled
    # 1     => DNS block lists are enabled
    ENABLE_DNSBL=0

    # If you enable Fail2Ban, don't forget to add the following lines to your `compose.yaml`:
    #    cap_add:
    #      - NET_ADMIN
    # Otherwise, `nftables` won't be able to ban IPs.
    ENABLE_FAIL2BAN=1

    # Fail2Ban blocktype
    # drop   => drop packet (send NO reply)
    # reject => reject packet (send ICMP unreachable)
    FAIL2BAN_BLOCKTYPE=drop

    # 1 => Enables Managesieve on port 4190
    # empty => disables Managesieve
    ENABLE_MANAGESIEVE=

    # **enforce** => Allow other tests to complete. Reject attempts to deliver mail with a 550 SMTP reply, and log the helo/sender/recipient information. Repeat this test the next time the client connects.
    # drop => Drop the connection immediately with a 521 SMTP reply. Repeat this test the next time the client connects.
    # ignore => Ignore the failure of this test. Allow other tests to complete. Repeat this test the next time the client connects. This option is useful for testing and collecting statistics without blocking mail.
    POSTSCREEN_ACTION=enforce

    # empty => all daemons start
    # 1 => only launch postfix smtp
    SMTP_ONLY=1

    # See https://docker-mailserver.github.io/docker-mailserver/edge/config/user-management/accounts/#notes
    # 0 => Dovecot quota is disabled
    # 1 => Dovecot quota is enabled
    ENABLE_QUOTAS=1

    # Changes the interval in which log files are rotated
    # **weekly** => Rotate log files weekly
    # daily => Rotate log files daily
    # monthly => Rotate log files monthly
    #
    # Note: This Variable actually controls logrotate inside the container
    # and rotates the log files depending on this setting. The main log output is
    # still available in its entirety via `docker logs mail` (Or your
    # respective container name). If you want to control logrotation for
    # the Docker-generated logfile see:
    # https://docs.docker.com/config/containers/logging/configure/
    #
    # Note: This variable can also determine the interval for Postfix's log summary reports, see [`PFLOGSUMM_TRIGGER`](#pflogsumm_trigger).
    LOGROTATE_INTERVAL=weekly


    # If enabled, employs `reject_unknown_client_hostname` to sender restrictions in Postfix's configuration.
    #
    # - **0** => Disabled
    # - 1 => Enabled
    POSTFIX_REJECT_UNKNOWN_CLIENT_HOSTNAME=0

    # Choose TCP/IP protocols for postfix to use
    # **all** => All possible protocols.
    # ipv4 => Use only IPv4 traffic. Most likely you want this behind Docker.
    # ipv6 => Use only IPv6 traffic.
    #
    # Note: More details at http://www.postfix.org/postconf.5.html#inet_protocols
    POSTFIX_INET_PROTOCOLS=all

    # Choose TCP/IP protocols for dovecot to use
    # **all** => Listen on all interfaces
    # ipv4 => Listen only on IPv4 interfaces. Most likely you want this behind Docker.
    # ipv6 => Listen only on IPv6 interfaces.
    #
    # Note: More information at https://dovecot.org/doc/dovecot-example.conf
    DOVECOT_INET_PROTOCOLS=all

    # -----------------------------------------------
    # --- Fetchmail Section -------------------------
    # -----------------------------------------------

    ENABLE_FETCHMAIL=0

    # The interval to fetch mail in seconds
    FETCHMAIL_POLL=300

    # Enable or disable `getmail`.
    #
    # - **0** => Disabled
    # - 1 => Enabled
    ENABLE_GETMAIL=0

    # The number of minutes for the interval. Min: 1; Max: 30.
    GETMAIL_POLL=5

    # -----------------------------------------------
    # --- Dovecot Section ---------------------------
    # -----------------------------------------------

    # empty => no
    # yes => LDAP over TLS enabled for Dovecot
    DOVECOT_TLS=

    # e.g. `"(&(objectClass=PostfixBookMailAccount)(uniqueIdentifier=%n))"`
    DOVECOT_USER_FILTER=

    # e.g. `"(&(objectClass=PostfixBookMailAccount)(uniqueIdentifier=%n))"`
    DOVECOT_PASS_FILTER=

    # Define the mailbox format to be used
    # default is maildir, supported values are: sdbox, mdbox, maildir
    DOVECOT_MAILBOX_FORMAT=maildir

    # empty => no
    # yes => Allow bind authentication for LDAP
    # https://wiki.dovecot.org/AuthDatabase/LDAP/AuthBinds
    DOVECOT_AUTH_BIND=

    ENABLE_SPAMASSASSIN=0
    ENABLE_LDAP=
    ENABLE_POSTGREY=0
    ENABLE_SASLAUTHD=0

    # -----------------------------------------------
    # --- SRS Section -------------------------------
    # -----------------------------------------------
    # envelope_sender => Rewrite only envelope sender address (default)
    # header_sender => Rewrite only header sender (not recommended)
    # envelope_sender,header_sender => Rewrite both senders
    # An email has an "envelope" sender (indicating the sending server) and a
    # "header" sender (indicating who sent it). More strict SPF policies may require
    # you to replace both instead of just the envelope sender.
    SRS_SENDER_CLASSES=envelope_sender

    # empty => Envelope sender will be rewritten for all domains
    # provide comma separated list of domains to exclude from rewriting
    SRS_EXCLUDE_DOMAINS=

    # empty => generated when the image is built
    # provide a secret to use in base64
    # you may specify multiple keys, comma separated. the first one is used for
    # signing and the remaining will be used for verification. this is how you
    # rotate and expire keys
    SRS_SECRET=

    DEFAULT_RELAY_HOST=
    RELAY_HOST=
    RELAY_PORT=25
    RELAY_USER=
    RELAY_PASSWORD=
  '';
}
