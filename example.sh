#!/bin/sh
# ShearK-Miner 2.6 (ShearHash-v3)
# Pool: pool.shear.digital:1111  (shear-testnet-v5)
#
# Paid login is the ssa1 Copy dest. A bare address stays bare.
# A typed YOUR_SSA1.suffix is optional and pays the same address.
# she1 without --dest is unpaid. Never use shear1.
#
# 1) Wallet: Copy dest. Paste it below as YOUR_SSA1.
# 2) Set --threads to this machine's logical CPUs ($(nproc) on Linux).

cd "$(dirname "$0")"
if [ ! -x ./ShearK-Miner ]; then
  echo "ShearK-Miner missing or not executable. Unpack ShearK-Miner-2.6-linux.zip first."
  exit 1
fi

exec ./ShearK-Miner --pool pool.shear.digital:1111 --user YOUR_SSA1 --backend jit-full --threads 8

# she1 login is RAM-only and must also pass --dest (the same Copy dest):
# exec ./ShearK-Miner --pool pool.shear.digital:1111 --user YOUR_SHE1.worker --dest YOUR_SSA1 --backend jit --threads 8
