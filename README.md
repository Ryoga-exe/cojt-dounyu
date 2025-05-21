# cojt-dounyu

[筑波大学情報学群組み込み技術キャンパスOJT (COJT) ハードウェアコース](https://www.cojt.or.jp/tkb/curriculum/index.html#b)の導入課題を [Veryl](https://veryl-lang.org/) で取り組んでみる。

This exercise requires creating a fully functional digital clock that displays hours, minutes, and seconds with two display modes and a manual time‐adjust feature.

## Prerequisites

- **Veryl**: Install from https://veryl-lang.org/install
- **Xilinx Vivado** 2024.2 or later
- **Make** utility on your PATH

## Build & Test workflow

All commands assume you are in the repository root.

### Run simulation tests and generate waveforms

```
make test
```

### Compile Veryl sources to HDL in `target/`

```
make build
```

### Build and generate FPGA bitstream

```
make flow
```
