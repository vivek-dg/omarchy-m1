#!/bin/bash

# Upgrade the system, create a new user and drop into that user
/bin/bash -c "$(curl -fsSL https://github.com/vivek-dg/omarchy-m1/raw/refs/heads/main/prereq.sh)"

# Run the Omarchy script
/bin/bash -c "$(curl -fsSL https://github.com/vivek-dg/omarchy-m1/raw/refs/heads/main/boot.sh)"
