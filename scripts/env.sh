#!/bin/bash
# Note: VGPU ports mask setting must be done before any VGPU is created
# VGPU to PORT assignment
# 1 -> PORT_A (can't be used because special eDP case: WIP to resolve)
# 2 -> PORT_B
# 3 -> PORT_C
# 4 -> PORT_D
MASK=0x0000000000000402

# BKM: To generate UUID, use uuid command.
# For ease of idfentification, replicate and replace the last number with VGPU index
VGPU1="f50aab10-7cc8-11e9-a94b-6b9d8245bfc1"
VGPU2="f50aab10-7cc8-11e9-a94b-6b9d8245bfc2"
VGPU3="f50aab10-7cc8-11e9-a94b-6b9d8245bfc3"
VGPU=" $VGPU1 $VGPU2 $VGPU3 "
VGPU_TYPE="i915-GVTg_V5_4"
BASEVGPU="/sys/bus/pci/devices/0000:00:02.0"
SDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DIR="${SDIR%/*}"
