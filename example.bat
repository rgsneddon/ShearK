@echo off
REM ShearK-Miner 2.6 (ShearHash-v3) — Windows
REM Pool: pool.shear.digital:1111  (shear-testnet-v5)
REM
REM Paid login is the ssa1 Copy dest. A bare address stays bare.
REM A typed YOUR_SSA1.suffix is optional and pays the same address.
REM she1 without --dest is unpaid. Never use shear1.
REM
REM 1) Wallet: Copy dest. Paste it below as YOUR_SSA1.
REM 2) Set --threads to this machine's logical CPUs (echo %NUMBER_OF_PROCESSORS%).

cd /d "%~dp0"

if not exist "ShearK-Miner.exe" (
  echo ShearK-Miner.exe missing. Unpack ShearK-Miner-2.6-windows.zip first.
  pause
  exit /b 1
)

REM Edit this line, then double-click this file:
ShearK-Miner.exe --pool pool.shear.digital:1111 --user YOUR_SSA1 --backend jit-full --threads 8

REM she1 login is RAM-only and must also pass --dest (the same Copy dest):
REM ShearK-Miner.exe --pool pool.shear.digital:1111 --user YOUR_SHE1.worker --dest YOUR_SSA1 --backend jit --threads 8

pause
