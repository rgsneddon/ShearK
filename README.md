# ShearK

Official **ShearK-Miner 2.6** for ShearHash-v3. Default `--backend jit-full` (2 GiB dataset, same digest as light). Salt `ShearHash-v3/rx`. Aborts in-flight hashes on job/restamp (`dropped`, not `reject`). Console paints **accept green** / **reject red**. Operator H/s is a time window; `proven_round` is hash-bonus only.

- Ticker: **SHE**
- Wire algo: **ShearHash**
- Personalisation: **ShearHash-v3**
- Magic: **shear-testnet-v5** (do not mine frozen `shear-testnet-v4` / v3 / v2)
- Pool: `pool.shear.digital:1111`
- Pin: **ShearK-Miner 2.6**. Do not recut **2.5** / 2.4 / 2.3. Header **128 bytes**. Share floor is dest-bound. **Copy dest** may be short (`dest20`) or long (`dest20||B`, ~95 chars). Download **2.6**.
- Paid login: a bare `ssa1` Copy dest. A typed `ssa1.suffix` is optional and pays the same address. 2.6 does not invent `.worker`. Offer `she1` when someone pays you; incoming coin lands on revolving `ssa1`. Rest-frame `shear1` stays in Closure.
- Each hasher dest that produced proven work receives its own hash bonus on the next sealed block. The 1 SHE pot is PROP of those dests (pool takes 1% of the pot only).

```
ShearK-Miner --pool pool.shear.digital:1111 --user YOUR_SSA1 --backend jit-full --threads 8
```

`--selftest` digest `98818c31d739ef821db0242f76bd244b96f1fb5049d27ea9a192e95c67b39a8b`. The v1 vector `5d00a242` must fail.

Source lives in [rgsneddon/shear-testnet](https://github.com/rgsneddon/shear-testnet) (`sheark-miner/`, tag `0.51`). This repo is the miner pin, downloads, and how-to. Wallet: [Continuum 0.51](https://github.com/rgsneddon/shear-testnet/releases/tag/0.51).

Mainnet `shear-v1` is not live. Do not recut this tag as mainnet.

## Get a dest (required)

1. Install the Shear wallet from [wallet 0.40](https://github.com/rgsneddon/shear-testnet/releases/tag/0.40) (or GUI/CLI in the main tree).
2. Set a password. Open **Continuum** (or `shear dest`).
3. **Copy dest**. That string starts with `ssa1`. That is the paid mining mailbox.
4. Do **not** mine to `she1` alone. Fingerprint-only `she1` login mints nothing. Rest-frame `shear1` is never a login.

`--user` is one string: that `ssa1` dest, a dot, then a worker name unique to this machine (`pc1`, `vps1`, `rig2`). Two boxes must not share the same `.worker`.

## Downloads (2.6)

| OS | Zip | Inside the zip |
| --- | --- | --- |
| Windows | [ShearK-Miner-2.6-windows.zip](https://github.com/rgsneddon/ShearK/releases/download/2.6/ShearK-Miner-2.6-windows.zip) | `ShearK-Miner.exe` + `example.bat` |
| Linux VPS / server | [ShearK-Miner-2.6-linux.zip](https://github.com/rgsneddon/ShearK/releases/download/2.6/ShearK-Miner-2.6-linux.zip) | `ShearK-Miner` + `example.sh` |

Need a dest: wallet **Copy dest** (`ssa1`). Site: [shear.digital](https://shear.digital). Pool: [pool.shear.digital](https://pool.shear.digital). Stratum **TCP 1111**.

128 MiB RAM for the RandomX light cache, plus a little for threads. CPU only.

## Windows

1. Download the Windows zip.
2. Unzip so `ShearK-Miner.exe` and `example.bat` sit in the same folder.
3. If SmartScreen or Defender warns: **More info -> Run anyway**, or file **Properties -> Unblock**.
4. Open `example.bat` in Notepad. Replace `YOUR_SSA1` with Copy dest. Replace `.worker` with a unique name. Set `--threads` to `%NUMBER_OF_PROCESSORS%`.
5. Save. Double-click `example.bat`.

Leave that window open. First line after a good start looks like `job=... height=... shareBits=8`. `accepted` should climb. Each accepted floor share is paid to that dest on the **next** sealed block (`kind:hash`).

Self-test:

```bat
ShearK-Miner.exe --selftest
ShearK-Miner.exe --print-config
```

`--print-config` must show `"personalisation":"ShearHash-v3"`, version `2.6`, `rxMode=light`, `feePct=0`.

`she1` login (RAM-only) must also pass `--dest` with the Copy dest.

## Linux VPS

Use the **linux** zip. The Windows zip will not run on a VPS.

```bash
sudo apt-get update
sudo apt-get install -y curl wget unzip ca-certificates libstdc++6
curl -L -o sheark.zip https://github.com/rgsneddon/ShearK/releases/download/2.6/ShearK-Miner-2.6-linux.zip
unzip -o sheark.zip -d sheark && cd sheark
chmod +x ShearK-Miner example.sh
./ShearK-Miner --selftest
```

Edit `example.sh`: `--user YOUR_SSA1.vps1 --threads $(nproc)`. Then `./example.sh`.

systemd (as root): `ExecStart=/opt/sheark/ShearK-Miner --pool pool.shear.digital:1111 --user YOUR_SSA1.vps1 --backend jit --threads 8 --notls`. Open outbound **TCP 1111**.

## Build from source

Miner source lives in the Shear tree (`sheark-miner/`), with RandomX vendored at `crypto/randomx`:

```
git clone https://github.com/rgsneddon/shear-testnet.git
cd shear-testnet/sheark-miner
make
./ShearK-Miner --selftest
```

Windows: native PE on a Windows box. Do not pack a Mac cross-compile as the Windows zip.

## Flags (`--help`)

```
ShearK-Miner 2.6 (ShearHash-v3 light)
  --user she1|ssa1.worker   required (not shear1)
  --dest ssa1               owned payout dest (she1 login)
  --pool host:port          default pool.shear.digital:1111
  --threads N
  --backend jit-full | jit | interpreter
  --notls
  --bench [SECONDS]
  --selftest
  --verify HEADERHEX
  --print-config
  --help
```
