# [Testnet] ShearK

Official **ShearK-Miner** for ShearHash-v2 (RandomX light, 128 MiB cache, salt `ShearHash-v2/rx`).

- Ticker: SHE
- Wire algo: **ShearHash**
- Personalisation: **ShearHash-v2**
- Magic: **shear-testnet-v2** (new genesis; do not mine the frozen `shear-testnet-v1` book)
- Pool: `pool.shear.digital:1111`
- Pin: **ShearK-Miner 1.0** (two-part). Do not recut Shear-Miner 1.1 / 1.0.

```
ShearK-Miner --pool pool.shear.digital:1111 --user YOUR_SHE1.worker --threads 8
```

Windows zip is `ShearK-Miner.exe` + `example.bat` at zip root. macOS zip is `ShearK-Miner` + `example.sh`.

`--selftest` digest `64d41fa97f5ebea8a7e2a2625b1824467ce9d081bf29b0b2ae0a7fe617599895`. The v1 vector `5d00a242…` must fail.

Source and node/pool live in [rgsneddon/shear-testnet](https://github.com/rgsneddon/shear-testnet). This repo is the miner pin and downloads.

Linux zip is leftover on this Darwin cut.
