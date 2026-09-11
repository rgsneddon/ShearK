# [Testnet] ShearK

Official **ShearK-Miner 1.6** for ShearHash-v3 (RandomX light, 128 MiB cache, salt `ShearHash-v3/rx`).

- Ticker: **SHE**
- Wire algo: **ShearHash**
- Personalisation: **ShearHash-v3**
- Magic: **shear-testnet-v2** (do not mine the frozen `shear-testnet-v1` book)
- Pool: `pool.shear.digital:1111`
- Pin: **ShearK-Miner 1.6**. Do not recut 1.5 / 1.4 / 1.1 / 1.0 or Shear-Miner 1.1 / 1.0.
- Paid login: `ssa1….worker` — wallet **Copy dest**. Offer `she1` when someone pays you; incoming coin lands on revolving `ssa1`. Rest-frame `shear1` stays in Closure.
- Each hasher dest that produced proven work receives its own hash bonus on the next sealed block. The 1 SHE pot is PROP of those dests (pool takes 1% of the pot only).

```
ShearK-Miner --pool pool.shear.digital:1111 --user YOUR_SSA1.worker --backend jit --threads 8
```

`--selftest` digest `64d41fa97f5ebea8a7e2a2625b1824467ce9d081bf29b0b2ae0a7fe617599895`. The v1 vector `5d00a242…` must fail.

Source, node, pool, and wallet: [rgsneddon/shear-testnet](https://github.com/rgsneddon/shear-testnet) pin **0.30**. This repo is the miner pin and downloads.

## Get a dest (required)

1. Install the Shear wallet from [shear-testnet 0.30](https://github.com/rgsneddon/shear-testnet/releases/tag/0.30).
2. Set a password. Open **Continuum**.
3. Tap **Copy dest**. That string starts with `ssa1`. That is the paid mining mailbox.
4. Do **not** mine to `she1` alone. Fingerprint-only `she1` login mints nothing. Rest-frame `shear1` is never a login.

`--user` is one string: that `ssa1` dest, a dot, then a worker name unique to this machine (`pc1`, `vps1`, `rig2`). Two boxes must not share the same `.worker`.

## Downloads (1.6)

| OS | Zip | Inside the zip |
| --- | --- | --- |
| Windows | [ShearK-Miner-1.6-windows.zip](https://github.com/rgsneddon/ShearK/releases/download/1.6/ShearK-Miner-1.6-windows.zip) | `ShearK-Miner.exe` + `example.bat` |
| Linux VPS / server | [ShearK-Miner-1.6-linux.zip](https://github.com/rgsneddon/ShearK/releases/download/1.6/ShearK-Miner-1.6-linux.zip) | `ShearK-Miner` + `example.sh` |

Need a dest: wallet **Copy dest** (`ssa1…`). Site: [shear.digital](https://shear.digital). Pool: [pool.shear.digital](https://pool.shear.digital). Stratum **TCP 1111**.

128 MiB RAM for the RandomX light cache, plus a little for threads. CPU only.

---

## Windows

1. Download [ShearK-Miner-1.6-windows.zip](https://github.com/rgsneddon/ShearK/releases/download/1.6/ShearK-Miner-1.6-windows.zip).
2. Unzip so `ShearK-Miner.exe` and `example.bat` sit in the same folder.
3. If SmartScreen or Defender warns: **More info → Run anyway**, or file **Properties → Unblock** (this testnet build is not Authenticode-signed).
4. Open `example.bat` in Notepad. Find:

```bat
ShearK-Miner.exe --pool pool.shear.digital:1111 --user YOUR_SSA1.worker --backend jit --threads 8
```

5. Replace `YOUR_SSA1` with the dest you copied. Replace `.worker` with a unique name (`pc1`). Set `--threads` to this PC’s logical CPUs (`echo %NUMBER_OF_PROCESSORS%` in cmd).
6. Save. Double-click `example.bat`.

Leave that window open. First line after a good start looks like `job=… height=… shareBits=8`. `accepted` should climb. Each accepted floor share is paid to that dest on the **next** sealed block (`kind:hash`). The 1 SHE pot is split across dests that hashed that round.

Self-test from `cmd` in the unzip folder:

```bat
cd /d C:\path\to\sheark
ShearK-Miner.exe --selftest
ShearK-Miner.exe --print-config
```

For a box that should survive logoff: Task Scheduler → **Create Task** → **Run whether user is logged on or not** → Action starts `ShearK-Miner.exe` with the same arguments, start in the unzip folder. Allow outbound **TCP 1111**.

`she1` login (RAM-only) must also pass `--dest` with the Copy dest:

```bat
ShearK-Miner.exe --pool pool.shear.digital:1111 --user YOUR_SHE1.worker --dest YOUR_SSA1 --backend jit --threads 8
```

---

## Linux VPS

Use the **linux** zip. The Windows zip will not run on a VPS.

A fresh VPS often has none of the download tools. `curl: command not found` means install the packages in step 2 **before** you fetch the zip.

| Package | Why |
| --- | --- |
| `curl` or `wget` | Download the zip from GitHub. |
| `unzip` | Unpack `ShearK-Miner-1.6-linux.zip`. |
| `ca-certificates` | GitHub HTTPS. |
| `libstdc++` | C++ runtime (`libstdc++6` on Debian/Ubuntu). |

Also: 128 MiB RAM for the RandomX light cache, outbound **TCP 1111** to `pool.shear.digital`.

### 1. SSH in

```bash
ssh user@vps.example.com
```

### 2. Install packages

Debian / Ubuntu:

```bash
sudo apt-get update
sudo apt-get install -y curl wget unzip ca-certificates libstdc++6
```

Fedora / RHEL / Alma / Rocky:

```bash
sudo dnf install -y curl wget unzip ca-certificates libstdc++
```

Alpine:

```bash
sudo apk add --no-cache curl wget unzip ca-certificates libstdc++
```

### 3. Get the zip onto the VPS

```bash
curl -L -o sheark.zip \
  https://github.com/rgsneddon/ShearK/releases/download/1.6/ShearK-Miner-1.6-linux.zip
```

or

```bash
wget -O sheark.zip \
  https://github.com/rgsneddon/ShearK/releases/download/1.6/ShearK-Miner-1.6-linux.zip
```

Or copy from your laptop:

```bash
scp ShearK-Miner-1.6-linux.zip user@vps.example.com:~/sheark.zip
```

### 4. Unpack and check

```bash
unzip -o sheark.zip -d sheark && cd sheark
chmod +x ShearK-Miner example.sh
./ShearK-Miner --selftest
./ShearK-Miner --print-config
```

`--selftest` must print `64d41fa9…`. `--print-config` must show `personalisation":"ShearHash-v3"`, `rxMode":"light"`, `feePct":0`.

### 5. Edit `example.sh`, then run

`--user` is one string: Copy dest, a dot, then a worker name for this machine.

| Part | What to put |
| --- | --- |
| Login | Your `ssa1…` dest (Copy dest). Not `shear1`. |
| Worker | Unique per box, e.g. `vps1`. |
| Threads | This box’s logical CPUs. `$(nproc)` uses all of them. |

```bash
nano example.sh
```

Find:

```sh
exec ./ShearK-Miner --pool pool.shear.digital:1111 --user YOUR_SSA1.worker --backend jit --threads 8
```

Replace `YOUR_SSA1` and `worker`. Example (use your real dest):

```sh
exec ./ShearK-Miner --pool pool.shear.digital:1111 --user ssa1qexampledestxxxxxxxxxxxxxxxxxxxxxxxxxx.vps1 --backend jit --threads $(nproc)
```

Save in nano: `Ctrl+O`, Enter, `Ctrl+X`. Then:

```bash
./example.sh
```

Or skip the script:

```bash
./ShearK-Miner --pool pool.shear.digital:1111 --user YOUR_SSA1.vps1 --backend jit --threads $(nproc)
```

### 6. Stay up (systemd)

As root. Put the **same** `--user ssa1….worker` you set in `example.sh`:

```ini
# /etc/systemd/system/sheark-miner.service
[Unit]
Description=ShearK-Miner 1.6 (ShearHash-v3 light)
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=/opt/sheark
ExecStart=/opt/sheark/ShearK-Miner --pool pool.shear.digital:1111 --user YOUR_SSA1.vps1 --backend jit --threads 8 --notls
Restart=always
RestartSec=5
Nice=5

[Install]
WantedBy=multi-user.target
```

```bash
sudo mkdir -p /opt/sheark
sudo cp ShearK-Miner /opt/sheark/ && sudo chmod +x /opt/sheark/ShearK-Miner
sudo systemctl daemon-reload
sudo systemctl enable --now sheark-miner
sudo journalctl -u sheark-miner -f
```

Plain TCP is the default on this pool (`--notls`). Open outbound **TCP 1111**.

---

## What you are paid

| Mint | Who | When |
| --- | --- | --- |
| 1 SHE pot | PROP of dests with proven floor shares that round, minus 100 bps pool fee | Next sealed coinbase (`kind:pot`) |
| Hash bonus | **Each** hasher dest, `256u` per proven floor share (`SHARE_FLOOR_BITS=8`) | Next sealed coinbase (`kind:hash`) |

HUD hashes below the floor do not mint. Spendable after **6** confirms. The dest that hashed must be the dest the wallet can spend (Copy dest / destCommit).

Watch the pool: [pool.shear.digital](https://pool.shear.digital). Your row is an opaque tag, not your dest.

---

## Flags (`--help`)

```
ShearK-Miner 1.6 (ShearHash-v3 light)
Hashes the 128-byte Shear header. One proven share-hash mints units.

  --user she1…|ssa1….worker   required (not shear1)
  --dest ssa1…                owned payout dest (she1 login)
  --pool host:port            default pool.shear.digital:1111
  --threads N                 no 256 farm cap
  --backend jit                default: light JIT + HARD_AES + huge pages
  --backend interpreter
  --notls                     plaintext (default on this pool)
  --bench [SECONDS]
  --selftest
  --verify HEADERHEX
  --print-config
  --help
```

| Flag | What it does |
| --- | --- |
| `--user` | Login. Paid path is `ssa1….worker`. Required to mine. |
| `--dest` | Owned `ssa1` when `--user` is `she1`. Ignored when `--user` is already `ssa1`. |
| `--pool` | Stratum `host:port`. Default `pool.shear.digital:1111`. |
| `--threads` | Worker threads. Use this machine’s logical CPUs. |
| `--backend` | `jit` (default) or `interpreter`. Do not use `jit-full` on this pool. |
| `--notls` | Plain TCP (already the default on this pool). |
| `--selftest` | Check the ShearHash-v3 light vector; must print `64d41fa9…`. |
| `--print-config` | JSON: name, algo, personalisation `ShearHash-v3`, version `1.6`, `rxMode=light`, `feePct=0`. |

---

## Build from source

Miner source lives in the Shear tree (`sheark-miner/`), with RandomX vendored at `crypto/randomx`. From that directory:

```
make
./ShearK-Miner --selftest
```

Windows: native PE on a Windows box (MinGW). Do not pack a Mac cross-compile as the Windows zip.
