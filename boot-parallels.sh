#!/bin/bash

# Upgrade the system, create a new user and drop into that user
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/vivek-dg/omarchy-m1/main/prereq.sh)"

# Run the Omarchy script
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/vivek-dg/omarchy-m1/main/boot.sh)"
