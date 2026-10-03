# ShearK

Official **ShearK-Miner 2.8** for ShearHash-v3. One release, six zips. Each zip is built on that operating system and includes `example.bat` and `example.sh`.

Public TLS verifies with the current Let's Encrypt and ISRG roots, or the OS store. There is no certificate pin. `--tls-pin` is refused. There is no `--tls-insecure`.

- Ticker: **SHE**
- Wire algo: **ShearHash**
- Personalisation: **ShearHash-v3**
- Live book: **shear-testnet-v10**
- Miner `--print-config` magic label: **shear-testnet-v4** (the header you hash comes from the job)
- Pool: `stratum+ssl://pool.shear.digital:443`
- Localhost solo: `stratum+tcp://127.0.0.1:1111` (cleartext, after the node reports `ibd=false`)
- Pin: **ShearK-Miner 2.8**. Do not recut **2.6**. Tag **2.6** stays on its own commit. Header **128 bytes**. Share floor is dest-bound.
- Paid login: a bare `ssa1` Copy dest stays bare. A typed `ssa1.worker` is optional and pays the same address. Offer `she1` when someone pays you; incoming coin lands on revolving `ssa1`. Rest-frame `shear1` stays off stratum.
- Each hasher dest that produced proven work receives its own hash bonus on the next sealed block. The 1 SHE pot is PROP of those dests (pool takes 1% of the pot only).

`--selftest` digest `98818c31d739ef821db0242f76bd244b96f1fb5049d27ea9a192e95c67b39a8b`. The v1 vector `5d00a242` must fail.

Source lives in [rgsneddon/shear-testnet](https://github.com/rgsneddon/shear-testnet) (`sheark-miner/`). This repo is the miner pin, the downloads, and this how-to. Wallet: [Continuum 0.68](https://github.com/rgsneddon/shear-testnet/releases/tag/0.68). Site: [shear.digital/miner](https://shear.digital/miner/).

Mainnet `shear-v1` is not live. Do not recut this tag as mainnet.

## Get a dest (required)

1. Install Continuum 0.68 from [wallet 0.68](https://github.com/rgsneddon/shear-testnet/releases/tag/0.68).
2. Set a password. Open **Continuum** (or `shear dest`).
3. **Copy dest**. That string starts with `ssa1`. That is the paid mining mailbox.
4. Do not mine to `she1` alone. Fingerprint-only `she1` login mints nothing unless you also pass `--dest` with the same Copy dest. Rest-frame `shear1` is never a login.

`--user` is that `ssa1` dest. A dot and a worker name (`pc1`, `vps1`) are optional. Two machines must not share the same `.worker`.

## Which zip

| Machine | Zip |
| --- | --- |
| Windows x86_64 | [ShearK-Miner-2.8-windows.zip](https://github.com/rgsneddon/ShearK/releases/download/2.8/ShearK-Miner-2.8-windows.zip) |
| Linux x86_64 (Ubuntu / Debian) | [ShearK-Miner-2.8-linux.zip](https://github.com/rgsneddon/ShearK/releases/download/2.8/ShearK-Miner-2.8-linux.zip) |
| Arch Linux x86_64 | [ShearK-Miner-2.8-archlinux.zip](https://github.com/rgsneddon/ShearK/releases/download/2.8/ShearK-Miner-2.8-archlinux.zip) |
| Fedora x86_64 | [ShearK-Miner-2.8-fedora.zip](https://github.com/rgsneddon/ShearK/releases/download/2.8/ShearK-Miner-2.8-fedora.zip) |
| openSUSE x86_64 | [ShearK-Miner-2.8-opensuse.zip](https://github.com/rgsneddon/ShearK/releases/download/2.8/ShearK-Miner-2.8-opensuse.zip) |
| macOS Apple silicon | [ShearK-Miner-2.8-macos.zip](https://github.com/rgsneddon/ShearK/releases/download/2.8/ShearK-Miner-2.8-macos.zip) |

Use the zip built for that operating system. An Ubuntu binary stays on Ubuntu. Fedora uses the Fedora zip. Arch uses the Arch zip. openSUSE uses the openSUSE zip.

Every zip contains:

- the miner (`ShearK-Miner.exe` on Windows, `ShearK-Miner` everywhere else)
- `example.bat` (Windows sample launcher; also packed in the other zips)
- `example.sh` (Linux, Arch, Fedora, openSUSE, and macOS sample launcher)
- the OpenSSL libraries that binary needs, in the same folder

Default `--backend jit-full` is the 2 GiB dataset (same digest as light). `--backend jit` is the 128 MiB cache. Huge pages fall back to 4K if unavailable.

## How to start

1. Download the zip from the table. Unzip the whole archive into one folder. Do not pull the binary out and leave the libraries behind.
2. Open the sample launcher. Windows: `example.bat`. Linux, Arch, Fedora, openSUSE, and macOS: `example.sh`.
3. Replace `YOUR_SSA1` with Copy dest. Set `--threads` to this machine's logical CPUs. Windows: `echo %NUMBER_OF_PROCESSORS%`. Linux: `nproc`.
4. Windows: save `example.bat` and double-click it. If SmartScreen or Defender warns: **More info, then Run anyway**, or file **Properties, Unblock**.
5. Everywhere else:

```sh
chmod +x ShearK-Miner example.sh
./example.sh
```

Leave that window open. A good start prints `tls verify ok` and `job=... height=...`. `accepted` should climb. Each accepted floor share is paid to that dest on the **next** sealed block (`kind:hash`).

On a new machine, once:

```sh
./ShearK-Miner --selftest
./ShearK-Miner --print-config
```

Windows uses `ShearK-Miner.exe` with the same flags. `--selftest` must print `98818c31d739ef821db0242f76bd244b96f1fb5049d27ea9a192e95c67b39a8b`. `--print-config` must show `"personalisation":"ShearHash-v3"`, version `2.8`, `rxMode=light`, `feePct=0`. The magic field in that print is the build label `shear-testnet-v4`. The live book is `shear-testnet-v10`.

Localhost solo stays cleartext. The sample files have those lines commented:

```sh
./ShearK-Miner --pool stratum+tcp://127.0.0.1:1111 --notls --user YOUR_SSA1.worker --backend jit-full --threads 8
```

Run solo only after your own node reports `ibd=false`. Do not point a public miner at cleartext.

## Build from source

Miner source lives in the Shear tree (`sheark-miner/`), with RandomX vendored at `crypto/randomx`:

```sh
git clone https://github.com/rgsneddon/shear-testnet.git
cd shear-testnet/sheark-miner
make
./ShearK-Miner --selftest
```

macOS Homebrew OpenSSL is keg-only:

```sh
brew install openssl cmake
make OPENSSL_PREFIX="$(brew --prefix openssl)"
```

Public packs stay on the compiler baseline. `SHEARK_NATIVE=1` is a local opt-in. Windows: native PE on a Windows box via `python pack/zip_windows.py`. Do not pack a Mac cross-compile as the Windows zip. Do not rename one distro's ELF onto another.

## Flags (`--help`)

```
ShearK-Miner 2.8 (ShearHash-v3 light)
  --user she1|ssa1.worker   required (not shear1)
  --dest ssa1               owned payout dest (she1 login)
  --pool stratum+ssl://host:port   TLS stratum. Default pool.shear.digital:443
  --pool stratum+tcp://host:port   cleartext (localhost / lab)
  --threads N
  --backend jit-full | jit | interpreter
  --tls-ca FILE             extra PEM trust anchor
  --require-tls             refuse a cleartext URL
  --bench [SECONDS]
  --selftest
  --verify HEADERHEX
  --print-config
  --help
```

`--tls-pin` exits with `tls pin refused`. The certificate chain is checked. A leaf pin is not a substitute.
