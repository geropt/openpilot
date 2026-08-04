#!/usr/bin/env bash

export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1
export NUMEXPR_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1
export VECLIB_MAXIMUM_THREADS=1

# models get lower priority than ui
# - ui is ~5ms
# - modeld is 20ms
# - DM is 10ms
# in order to run ui at 60fps (16.67ms), we need to allow
# it to preempt the model workloads. we have enough
# headroom for this until ui is moved to the CPU.
export QCOM_PRIORITY=12

if [ -z "$AGNOS_VERSION" ]; then
  export AGNOS_VERSION="18.8"
fi

export STAGING_ROOT="/data/safe_staging"

# Jeep Compass MP capture phase.
#
# No Compass firmware versions exist anywhere yet, so fingerprints.py cannot identify
# this car and openpilot would sit at "Car Unrecognized". That leaves panda in its silent
# safety mode, which keeps the harness relay closed and bridges bus 0 with bus 2 — exactly
# the confusion leomonde hit trying to tell camera traffic from car traffic.
#
# Forcing the platform makes openpilot load the port, panda take the fcaGiorgio safety
# mode, and the relay open, so the buses stay separate in the logs. The port is
# dashcamOnly, so this cannot engage.
#
# Deliberately NOT setting SKIP_FW_QUERY: that would skip the VIN read, the present-ECU
# scan and the firmware version query, which is the very data this capture exists to
# collect. FINGERPRINT is applied after those run, so forcing the platform costs nothing.
#
# DISABLE_FW_CACHE keeps it re-querying every boot instead of reusing a cached CarParams.
#
# Remove all of this once fingerprints.py has real firmware versions from the car.
export FINGERPRINT="JEEP_COMPASS_MP"
export DISABLE_FW_CACHE="1"
