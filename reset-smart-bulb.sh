#!/bin/sh
set -x

# Using a desk lamp plugged into a smart outlet (mPower...?) is easy an easy to trigger the reset sequence and then you can
# reinstall the bulb into the correct location before re-pairing with your smart home hub
# For harder to reach bulbs it could be interesting to rig up a "switch flipper" robot that can handle paddle or finger style switches

toggle_state () { echo $1 > /proc/power/relay${PORT:-1}; }

toggle_on () { toggle_state 1; }

toggle_off () { toggle_state 0; }

reset () {
  : ${CYCLE_COUNT:=5} \
    ${CYCLE_WAIT:=3}
  
  COUNTER=0
  # Most bulbs expect to start from a powered on state with off being the start of a sequence
  toggle_on
  
  while [ $COUNTER -le $CYCLE_COUNT ]; do
    toggle_off
    sleep $CYCLE_WAIT
    toggle_on 
    sleep $CYCLE_WAIT
    COUNTER=$((COUNTER+1))
  done
  echo "Your bulb should quickly blink a few times to indicate it is ready for pairing and then to relocate to its long term home"
}

# The : <<'START/END' is a HEREDOC comment block with is handy for avoiding lots of start of line # for large blocks of text
: <<'EOS'
https://support.smartthings.com/hc/en-us/articles/214191863-How-to-connect-SYLVANIA-Bulbs#query:~:text=To%20reset%20the%20SYLVANIA%20Bulb,does%20not%20blink%20three%20(3)%20times
To reset the SYLVANIA Bulb
If the SYLVANIA Bulb is not discovered or is not performing as expected, you may need to reset the bulb and/or remove and reconnect it with the SmartThings Hub.

Turn the light off
Turn the light on for three (3) seconds
Turn the light off
Repeat this cycle five (5) times
Wait ten (10) seconds for the light to blink three (3) times
Repeat these steps if the light does not blink three (3) times
EOS

reset_sylvania () {
# Don't need to set variables if they match the default
# : ${CYCLE_COUNT:=5} \
#  ${CYCLE_WAIT:=3} \
reset
}

: <<'EOS'
https://support.smartthings.com/hc/en-us/articles/115000523063-Sengled-Element-Classic-and-Plus#query:~:text=How%20to%20reset%20the%20Sengled%20Element,times%20when%20it%20has%20successfully%20reset
How to reset the Sengled Element Bulb
If the Sengled Element Bulb was not discovered, you may need to reset it before it can successfully connect with the SmartThings Hub. To physically reset the device:

Turn the light off and on ten (10) times (using a light switch or power strip works best)
The bulb will blink 5 times when it has successfully reset
EOS

reset_sengled () {
: ${CYCLE_COUNT:=10} \
  ${CYCLE_WAIT:=.1} \
reset
}

# TODO: Prompt for a device type and trigger correct reset sequence, defaults to Sylvania/OSRAM currently.
case ${1:-syl} in
  syl*) reset_sylvania
      ;;
  seng*) reset_sengled
      ;;
esac
