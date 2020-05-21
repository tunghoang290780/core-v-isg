###############################################################################
#
# Copyright 2020 OpenHW Group
# 
# Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     https://solderpad.org/licenses/
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 
###############################################################################
# DSIM-specific Makefile for the CORE-V Instruction Set Generator.
###############################################################################

DSIM               = dsim
DSIM_HOME         ?= /tools/Metrics/dsim
DSIM_CMP_FLAGS    ?= $(TIMESCALE) $(SV_CMP_FLAGS)
DSIM_CMP_WARN     ?= -warn InvalidWildMethod
DSIM_UVM_ARGS     ?= +incdir+$(UVM_HOME)/src $(UVM_HOME)/src/uvm_pkg.sv
DSIM_RESULTS      ?= $(PWD)/dsim_results
DSIM_WORK         ?= $(DSIM_RESULTS)/dsim_work
DSIM_IMAGE        ?= dsim.out
DSIM_RUN_FLAGS    ?= +UVM_MAX_QUIT_COUNT=50
DSIM_RUN_LOG      ?= run.log
TEST_NAME         ?= riscv_random_all_test
SEED              ?= 0
UVM_VERBOSITY     ?= UVM_LOW
GEN_INST_NUM      ?= 1000
DSIM_RUN_ARGS     ?=

# Variables to control wave dumping from command the line
# Humans _always_ forget the "S", so you can have it both ways...
WAVES                  ?= 0
WAVE                   ?= 0
DUMP_WAVES             := 0

ifneq ($(WAVES), 0)
DUMP_WAVES = 1
endif

ifneq ($(WAVE), 0)
DUMP_WAVES = 1
endif

ifneq ($(DUMP_WAVES), 0)
DSIM_ACC_FLAGS ?= +acc
DSIM_DMP_FILE  ?= dsim.fst
DSIM_DMP_FLAGS ?= -waves $(DSIM_DMP_FILE)
endif


.PHONY: comp

no_rule:
	@echo 'makefile: SIMULATOR is set to $(SIMULATOR), but no rule/target specified.'
	@echo 'try "make SIMULATOR=dsim comp" (or just "make comp" if shell ENV variable SIMULATOR is already set).'

all: clean_all comp

help:
	dsim -help

mk_results: 
	mkdir -p $(DSIM_RESULTS)
	mkdir -p $(DSIM_WORK)

# DSIM compile target
# TODO: create a proper manifest
comp: mk_results
	$(DSIM) \
		$(DSIM_CMP_FLAGS) \
		$(DSIM_CMP_WARN) \
		$(DSIM_UVM_ARGS) \
		$(DSIM_ACC_FLAGS) \
		-sv_lib $(UVM_HOME)/src/dpi/libuvm_dpi.so \
		+incdir+../memory \
		+incdir+../parameter \
		+incdir+../sequence \
		+incdir+../transaction \
		+incdir+../test \
		./CV32E40P_macros.sv \
		../transaction/riscv_txn_pkg.sv \
		../memory/riscv_memory_pkg.sv \
		../parameter/riscv_params.sv \
		../sequence/riscv_base_seq.sv \
		../sequence/riscv_random_all_seq.sv \
		../test/riscv_test_base.sv \
		../test/riscv_random_all_test.sv \
		../test/riscv_gen_top.sv \
		-work $(DSIM_WORK) \
		+$(UVM_PLUSARGS) \
		-genimage $(DSIM_IMAGE)

run: comp
	mkdir -p $(DSIM_RESULTS)/$(TEST_NAME)  && \
	cd       $(DSIM_RESULTS)/$(TEST_NAME)  && \
	$(DSIM) \
		-l $(DSIM_RUN_LOG) \
		-image $(DSIM_IMAGE) \
		-work $(DSIM_WORK) \
		-sv_lib $(UVM_HOME)/src/dpi/libuvm_dpi.so \
		$(DSIM_RUN_ARGS) \
		$(DSIM_RUN_FLAGS) \
		+UVM_TESTNAME=$(TEST_NAME) \
		+ntb_random_seed=$(SEED) \
		+UVM_VERBOSITY=$(UVM_VERBOSITY) \
		+MAXLEN=$(GEN_INST_NUM) \
		+MINLEN=$(GEN_INST_NUM)

clean_all:
	rm -rf $(DSIM_RESULTS)
	rm -f dsim.env dsim.log

