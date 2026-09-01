# [Testnet] ShearK

Official **ShearK-Miner** for ShearHash-v2 (RandomX light, 128 MiB cache, salt `ShearHash-v2/rx`).

- Ticker: **SHE**
- Wire algo: **ShearHash**
- Personalisation: **ShearHash-v2**
- Magic: **shear-testnet-v2** (do not mine the frozen `shear-testnet-v1` book)
- Pool: `pool.shear.digital:1111`
- Pin: **ShearK-Miner 1.5** (two-part). Do not recut 1.4 / 1.1 / 1.0 or Shear-Miner 1.1 / 1.0.
- Login: `she1…` silent ID or `ssa1…` dest, then `.worker`. Not `shear1`.
- 1 hash = 1 tx. `--print-config` shows `feePct=0`.

```
ShearK-Miner --pool pool.shear.digital:1111 --user YOUR_SHE1.worker --threads 8
```

`--selftest` digest `64d41fa97f5ebea8a7e2a2625b1824467ce9d081bf29b0b2ae0a7fe617599895`. The v1 vector `5d00a242…` must fail.

Source, node, and pool: [rgsneddon/shear-testnet](https://github.com/rgsneddon/shear-testnet). This repo is the miner pin and downloads.

## Downloads (1.5)

| OS | Zip | Binary in the zip |
| --- | --- | --- |
| Linux VPS / server | [ShearK-Miner-1.5-linux.zip](https://github.com/rgsneddon/ShearK/releases/download/1.5/ShearK-Miner-1.5-linux.zip) | `ShearK-Miner` + `example.sh` |
| Windows | [ShearK-Miner-1.5-windows.zip](https://github.com/rgsneddon/ShearK/releases/download/1.5/ShearK-Miner-1.5-windows.zip) | `ShearK-Miner.exe` + `example.bat` |
| macOS | [ShearK-Miner-1.5-macos.zip](https://github.com/rgsneddon/ShearK/releases/download/1.5/ShearK-Miner-1.5-macos.zip) | `ShearK-Miner` + `example.sh` |

Need a login: a Shear wallet dest (`ssa1…`) or silent ID (`she1…`). Site: [shear.digital](https://shear.digital). Pool page: [pool.shear.digital](https://pool.shear.digital).

128 MiB RAM for the RandomX light cache, plus a little for threads. Use one unique `.worker` name per machine.

---

## Linux VPS

Use the **linux** zip (`ShearK-Miner-1.5-linux.zip`). The macOS and Windows zips will not run on a VPS.

A fresh VPS often has none of the download tools. `curl: command not found` (or the same for `wget` / `unzip`) means install the packages in step 2 **before** you try to fetch the zip.

| Package | Why |
| --- | --- |
| `curl` or `wget` | Download the zip from GitHub. Either one is enough; installing both is fine. |
| `unzip` | Unpack `ShearK-Miner-1.5-linux.zip`. |
| `ca-certificates` | GitHub HTTPS. Without this, curl/wget can fail with an SSL error. |
| `libstdc++` | C++ runtime the miner binary needs (`libstdc++6` on Debian/Ubuntu). |

Also: 128 MiB RAM for the RandomX light cache, outbound **TCP 1111** to `pool.shear.digital`.

### 1. SSH in

Replace `user` and `vps.example.com` with your host:

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

**Download on the VPS** (simplest). `curl` or `wget`:

```bash
curl -L -o sheark.zip \
  https://github.com/rgsneddon/ShearK/releases/download/1.5/ShearK-Miner-1.5-linux.zip
```

```bash
wget -O sheark.zip \
  https://github.com/rgsneddon/ShearK/releases/download/1.5/ShearK-Miner-1.5-linux.zip
```

**Or copy from your laptop** after you downloaded the linux zip at home.

From a Mac or Linux machine:

```bash
scp ShearK-Miner-1.5-linux.zip user@vps.example.com:~/sheark.zip
ssh user@vps.example.com
```

From Windows (PowerShell):

```powershell
scp ShearK-Miner-1.5-linux.zip user@vps.example.com:~/sheark.zip
ssh user@vps.example.com
```

### 4. Unpack and check

On the VPS, in the directory that has `sheark.zip`:

```bash
unzip -o sheark.zip -d sheark && cd sheark
chmod +x ShearK-Miner example.sh
./ShearK-Miner --selftest
./ShearK-Miner --print-config
```

### 5. Run

Edit `example.sh` (`YOUR_SHE1` and `--threads`, often `$(nproc)`), then:

```bash
./example.sh
```

Or run directly:

```bash
./ShearK-Miner --pool pool.shear.digital:1111 --user YOUR_SHE1.vps1 --threads $(nproc)
```

### 6. Stay up (systemd)

As root. Paths and user are examples:

```ini
# /etc/systemd/system/sheark-miner.service
[Unit]
Description=ShearK-Miner (ShearHash-v2 light)
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=/opt/sheark
ExecStart=/opt/sheark/ShearK-Miner --pool pool.shear.digital:1111 --user YOUR_SHE1.vps1 --threads 8
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

Plain TCP is the default on this pool (`--notls`). Open outbound **TCP 1111** to `pool.shear.digital`.

---

## Windows (PC or Windows Server)

1. Download [ShearK-Miner-1.5-windows.zip](https://github.com/rgsneddon/ShearK/releases/download/1.5/ShearK-Miner-1.5-windows.zip).
2. Unzip so `ShearK-Miner.exe` and `example.bat` sit in the same folder.
3. If SmartScreen or Defender warns: **More info → Run anyway**, or file **Properties → Unblock** (this build is not Authenticode-signed).
4. Edit `example.bat`: set `YOUR_SHE1` and `--threads` to this box’s logical CPUs (`echo %NUMBER_OF_PROCESSORS%`).
5. Double-click `example.bat`, or from `cmd`:

```bat
cd /d C:\path\to\sheark
ShearK-Miner.exe --selftest
ShearK-Miner.exe --print-config
ShearK-Miner.exe --pool pool.shear.digital:1111 --user YOUR_SHE1.win1 --threads 8
```

Leave that window open. For a server that should survive logoff, use Task Scheduler: **Create Task → Run whether user is logged on or not → Action** start `ShearK-Miner.exe` with the same arguments, start in the unzip folder. Allow outbound **TCP 1111**.

---

## macOS

```bash
curl -L -o sheark.zip \
  https://github.com/rgsneddon/ShearK/releases/download/1.5/ShearK-Miner-1.5-macos.zip
unzip -o sheark.zip -d sheark && cd sheark
chmod +x ShearK-Miner example.sh
xattr -d com.apple.quarantine ShearK-Miner 2>/dev/null || true
./ShearK-Miner --selftest
```

If Gatekeeper blocks it: **System Settings → Privacy & Security → Open Anyway**, or right-click → **Open**.

Edit `example.sh`, then `./example.sh`, or:

```bash
./ShearK-Miner --pool pool.shear.digital:1111 --user YOUR_SHE1.mac1 --threads $(sysctl -n hw.logicalcpu)
```

Apple silicon and Intel both use the macOS zip. 128 MiB cache still applies.

---

## Flags (`--help`)

```
ShearK-Miner 1.5 (ShearHash-v2 light)
Hashes the 128-byte Shear header. 1 hash = 1 tx.

  --user she1…|ssa1….worker   required (not shear1)
  --pool host:port            default pool.shear.digital:1111
  --threads N                 no 256 farm cap
  --backend auto|interpreter|jit
  --notls                     plaintext (default on this pool)
  --bench [SECONDS]
  --selftest
  --verify HEADERHEX
  --print-config
  --help
```

| Flag | What it does |
| --- | --- |
| `--help` / `-h` | Print the list above and exit. |
| `--user` | Login. `she1` silent ID or `ssa1` dest, then `.worker`. Required to mine. |
| `--pool` | Stratum `host:port`. Default `pool.shear.digital:1111`. |
| `--threads` | Worker threads. Use this machine’s logical CPUs. No 256 farm cap. |
| `--backend` | RandomX: `auto` (default), `interpreter`, or `jit`. If JIT fails, it falls back to interpreter. |
| `--notls` | Plain TCP. This pool is plaintext; you usually omit this (it is already the default). |
| `--bench [SECONDS]` | Hashrate bench, then exit. Optional duration. |
| `--selftest` | Check the ShearHash-v2 light vector; must print `64d41fa9…`. |
| `--verify HEADERHEX` | Hash one 128-byte header (hex) and print the digest. |
| `--print-config` | JSON: name, algo, personalisation, version, pool, `rxMode=light`, `rxCacheMiB=128`, `feePct=0`, threads, backend. |

`--print-config` example:

```json
{"name":"ShearK-Miner","client":"ShearHash","algorithm":"ShearHash","personalisation":"ShearHash-v2","version":"1.5","clientLogin":"direct","feePct":0,"pool":"pool.shear.digital:1111","headerBytes":128,"magic":"shear-testnet-v2","rxMode":"light","rxCacheMiB":128,"threads":1,"backend":"interpreter"}
```

---

## Build from source

Miner source lives in the Shear tree (`sheark-miner/`), with RandomX vendored at `crypto/randomx`. From that directory:

```
make
./ShearK-Miner --selftest
```

Windows: native PE on a Windows box (MinGW). Do not pack a Mac cross-compile as the Windows zip.
