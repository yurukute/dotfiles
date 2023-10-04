#!/bin/sudo bash
date -s "$(curl -s --head google.com | sed -n 's/Date: //p')"
