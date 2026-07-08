# FFT Streaming Input — Radix-2 8-Point FFT (Verilog)

A Verilog implementation of a streaming, pipelined 8-point FFT using the Decimation-In-Frequency (DIF) radix-2 algorithm and a Single-Path Delay Feedback (SDF) architecture.

## How it works

- Complex samples (8-bit real + 8-bit imaginary) stream in **one per clock cycle** — 8 cycles to load a full input block.
- The 8-point FFT is computed in **3 pipelined stages** (log₂8 = 3), each performing butterfly operations followed by twiddle factor multiplication:
  - `sdf_stage1.v` — distance 4
  - `sdf_stage2.v` — distance 2
  - `sdf_stage3.v` — distance 1
- `top_module.v` connects the three stages into the full pipeline.

## Files

| File | Description |
|---|---|
| `top_module.v` | Top-level module chaining the 3 SDF stages |
| `sdf_stage1.v` | First butterfly/twiddle stage |
| `sdf_stage2.v` | Second butterfly/twiddle stage |
| `sdf_stage3.v` | Third butterfly/twiddle stage |
| `Report.pdf` | Assignment write-up covering FFT theory, DIF vs DIT, and the streaming architecture |
