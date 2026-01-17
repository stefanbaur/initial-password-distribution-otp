# initial-password-distribution-otp

This is a collection of scripts and templates to create physical One-Time-Pads for initial password distribution to users.

The configuration is kept in the file `etc/initpass.conf`. This is the file where you define the desired password length and the parameters you wish to pass to `pwgen`. Note that the `-y` parameter seems to cause empty character fields sometimes, so we advise against using that one. The parameter combination `-cnB` seems to work reasonably well.

You start by generating OTP sheets by calling `bin/generate-password-sheet user1@example.com user2@example.com ... usern@example.com`.

It is recommended to use E-Mail addresses, but you can also use simple user names. However, you will only be able to automatically send out the sheets via E-Mail if you use E-Mail addresses.

This script has been tested with LibreOffice 7.4.7.2 40(Build:2) - different LibreOffice versions may require a different `etc/etc/otp-formatted-header.fods` template file to work.

Once you have generated the sheets, you need to somehow get them to your users.

One way is to call `bin/mail-password-sheet user1@example.com user2@example.com ... usern@example.com` - this requires a working MTA configuration on your machine (`nullmailer` or `ssmtp` will do). This will send an E-Mail with a PDF attachment to all the users specified on the command line. You can also specify the corresponding PDF names, as long as the PDFs are stored in the `data` subdirectory. You will also need to set the `MAILSUBJECT` variable in `etc/initpass.conf`.

Another way is to call `bin/print-password-sheet user1@example.com user2@example.com ... usern@example.com` - the printer needs to be set in `etc/initpass.conf` and defaults to the default printer.

Once your users have been equipped with their OTP sheets, you can start setting their initial passwords. To do so, run `bin/set-initial-password user1@example.com user2@example.com ... usern@example.com` - this script will output the username, the row, the starting and the ending column where your users can find their initial password. It will then try to set the password for the user(s). The command that will be run can be specified in `etc/initpass.conf` as well.

The `./install_update.sh` command will install the scripts and config files to `/opt/initial-password-distribution-otp` (this can be overridden by specifying the desired destination path as a command line parameter), and will also add symlinks in `/usr/local/sbin/`.
