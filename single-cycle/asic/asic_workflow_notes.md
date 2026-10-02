**ASIC Workflow:
 
**A. Setup commands**
- Check Nix: `nix --version`; load it with `. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh`
- Enable flakes and the cache in `/etc/nix/nix.custom.conf`: `extra-experimental-features = nix-command flakes`, plus `extra-substituters` and `extra-trusted-public-keys` for `nix-cache.fossi-foundation.org`
- Restart the daemon: `sudo systemctl restart nix-daemon`
- Verify: `nix show-config | grep -E "substituters|experimental"`
- Clone in WSL: `git clone https://github.com/librelane/librelane ~/librelane`
- Enter the shell: `nix-shell --pure shell.nix`
- Smoke test: `librelane --smoke-test` (antenna, LVS, DRC passed)
- Project: `~/my_core/{src/, config.json}`, copy RTL with `cp .../rtl/*.sv ~/my_core/src/`
- Run: `cd ~/my_core && librelane config.json`
- Pure shell hides PATH, so use full paths: `/usr/bin/grep`, `/usr/bin/nano`, `/usr/bin/cat`

**B. Issues, diagnosis, fixes**

| Issue | How I diagnosed it | Fix |
|---|---|---|
| `Input/output error` during the Nix download | Error text: `write of 24576 bytes: Input/output error`; `df -h /` showed space was fine | `wsl --shutdown`, reopen, rerun `nix-shell` |
| Installer failed on existing receipt | `Unable to parse existing receipt` | Nix was already installed, so just sourced the daemon profile |
| `PDN-0185` insufficient width (15 µm die) | Tiny die implied a tiny netlist; checked `stat.rpt` | See next row |
| Design collapsed to nothing | `cat runs/<tag>/*yosys*/reports/stat.rpt`: 32 `conb_1` cells, 3 ports, 0 flops; CTS said `clk has 0 sinks` | Added the instruction load port (`prog_we`, `prog_addr`, `prog_data`) so the program comes from outside; ports went from 34 to 72 |
| Fix appeared not to work | `grep -n prog_we ~/my_core/src/*.sv` returned nothing: edits never reached the copy | Re-edited the source, recopied, regrepped until both `core.sv` and `i_mem.sv` matched |
| 4 lint errors | `cat runs/<tag>/01-*/*.log \| grep -i error` showed `PINNOTFOUND` for `clk`, `prog_we` etc. on `i_mem` | Replaced `i_mem.sv` with the version with the new ports |
| `initial` blocks and `$readmemh` in synthesis | Risk of init values and folding | Wrapped in `` `ifndef SYNTHESIS ``, added `"VERILOG_DEFINES": ["SYNTHESIS"]` to `config.json` |
| Run very slow at stage 37 | Log: WNS about -17 ns at 25 ns period, 2079 violating endpoints | Raised `CLOCK_PERIOD` to 50 |
| Still slow after that | Log: `RSZ-0098 No setup violations`, then `3073 endpoints with hold violations` | Waited; hold buffers added one at a time |
| Slow-corner setup failed at 50 ns | `metrics.json`: `ss_100C_1v60` setup WNS -7.4 ns | Raised `CLOCK_PERIOD` to 60 and `PL_TARGET_DENSITY_PCT` to 55 |

**C. Readings I used**
- Synthesis health: `stat.rpt` (cell count, `dfxtp` flop count, port bits)
- Timing: `grep -i "setup__ws\|hold__ws" runs/<tag>/final/metrics.json` per corner (`tt`, `ss`, `ff`)
- Area and power: `design__instance__area__stdcell`, `power__total` in `metrics.json`
- Sign-off: end-of-run summary (Antenna, LVS, DRC) and `Circuits match uniquely` from LVS
- Fmax estimate: `1 / (period - WNS)`

**D. Final result (60 ns run)**
- Antenna, LVS and DRC passed; no setup or hold violations
- Synthesis: 11,699 cells, 0.154 mm², 3,104 flops (43% of area)
- Remaining: max slew and max cap warnings (3,105-sink clock net, flop-based memories)

Add the exact final-run area, power and slack from `metrics.json` to the table before committing.
