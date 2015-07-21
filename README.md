# apk_signer
A tool to simplify signing multiple Android APKs with different keys

--------

###  Why use this?
Because Google ties your signing key to your app and does not ever aloow you to change it, it is important that you keep it safe. If you have multiple apps, the safest thing to do is sign them each with a different key. There are 2 main benefits to this:

1. If one app gets compromised, any apps that _DO NOT_ share its key are safe.
2. If you ever sell the app, you have to give up the key as well. If you shared the key with multiple apps, the buyer would be capable of compromising your other apps.

Most people (from an informal poll) do not use a different key for every app because it is complicated to organize, maintain, and use many keys. I manage over 120 apps and this is the tool I created to do all the hard work for me.

### Usage
Following my recommended installation method makes usage extremely simple.

    apk_signer app1.apk app2.apk app3.apk etc.apk

Of course it works with wildcards...

    apk_signer *.apk

Or in a complex command pipe...

    find . -name '*-release-unsigned.apk' | xargs apk_signer.sh

### Installation
The command requires a config and at least one keystore. The easiest way to handle this is to:

1. Clone the repo into any location.
2. Edit the config.ini
3. Symlink the apk_signer.sh anywhere in your $PATH

The format of the config.ini is pretty self explanatory.

### Notes
1. This is written in pure BASH and should be able to run anywhere and be modified by anyone.
2. I have run this on both Mac and Linux.
3. Most of my edits are made on a Mac and go untested on Linux for long periods of time.
4. Pull requests welcomed.
