# core-v-isg
RISC-V Random Instruction Stream Generator

## Try the Example
A compile-and-run example can be found in the `sim` directory.  Run `make comp SIMULATOR=<sim>` to compile the ISG or `make run SIMULATOR=<sim>` to compile and run it.
<br>
...where \<sim\> is one of:<br>
**dsim** for [Metrics](https://metrics.ca/) dsim.<br>
**xrun** for [Cadence](https://www.cadence.com/en_US/home/tools/system-design-and-verification/simulation-and-testbench-verification/xcelium-parallel-simulator.html) Xcelium. (Note that there is not yet a `run` target for xrun at this time.)<br>
**vcs**  for [Synopsys](https://www.synopsys.com/verification/simulation/vcs.html) VCS.<br>

## New To Git?
Check out the [GitCheats](https://github.com/openhwgroup/core-v-verif/blob/master/GitCheats.md) on [core-v-verif](https://github.com/openhwgroup/core-v-verif).
