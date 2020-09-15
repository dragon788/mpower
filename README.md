Power Monitoring with Ubiquiti mPower Smart Plug
============

(These instructions assume the mPower Mini smart plug. For the larger plugs, this will only monitor the first plug receptacle on the device)

1. Plug in the mPower Mini
2. Connect to the plug over WiFi
3. Generally the next step is to set up the device to associate with a particular network. However, this step isn't necessary for our purposes and data can be collected directly from the device without setting it up.
4. ssh to the plug at 192.168.2.20 with username and password 'ubnt' (note that the device requires a [weaker key exchange algorithm](http://www.openssh.com/legacy.html) to be enabled):
```
ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 ubnt@192.168.2.20
```
5. Test to determine whether the outlet is switched on:
```
cat /proc/power/relay1
(returns 1 if on, 0 if off)
```
6. If not, turn on the relay:
```
echo 1 > /proc/power/relay1
```
7. You're ready to run the monitor script in this repo:
```
./mpower.sh
(enter password when prompted. the default is just 'ubnt', same as the username)
```

The script will record the current time, active power, current, voltage, and power factor (in that order) every second. The most interesting values are probably the active power and current. A few notes:
 * The voltage reported by the device is the mains voltage.
 * Active power = voltage * current * power factor.
 * If you associated the device with your wireless network, specify its new hostname/IP as an argument to the script.

## reset-smart-bulb.sh
Copy this file (or the contents of it) to `$HOME/bin/reset-smart-bulb.sh` and `chmod +x $HOME/bin/reset-smart-builb.sh`. The reason to use this directory is it will persist, while the /bin and /usr/bin may get reset during restarts or firmware upgrades (haha..... sorry, probably none of those ever happening again).

Now you can run the command below to quickly trigger a bulb reset without needing to open a long term connection for one command. This example shows `syl` but if you omit it that is the default as well, otherwise you can use `seng` for Sengled.

```
ssh -c aes256-cbc -oKexAlgorithms=+diffie-hellman-group1-sha1 ubnt@192.168.2.20 '$HOME/bin/reset-smart-bulb.sh syl'
```

If you prefer to log in to be able to tweak things you can just drop everything after the `user@hostnameORip` and then once logged in run `bin/reset-smart-bulb.sh`


For more convenience add your SSH public key to the `$HOME/.ssh/authorized_keys` and you can run the command or connect without getting prompted for a password if you are running `ssh-agent` or `gpg-agent` to cache the passphrase/PIN for your private key.
