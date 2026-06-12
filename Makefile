# ---- Sources ----
RTL_SRCS := \
	rtl/mul.sv \
	rtl/alu.sv \
	rtl/datapath.sv \
	rtl/controller.sv \
	rtl/counter.sv \
	rtl/FFTbutterfly.sv

TB_SRCS := tb/FFT_tb.sv
SRCS    := $(RTL_SRCS) $(TB_SRCS)

# ---- ModelSim ----
VLIB := vlib
VLOG := vlog
VSIM := vsim
WORK := work
TOP  := FFT_tb

compile:
	@echo "== Compiling (ModelSim) =="
	$(VLIB) $(WORK)
	$(VLOG) -sv $(SRCS)

run: compile
	@echo "== Running (ModelSim) =="
	$(VSIM) -c $(WORK).$(TOP) -do "run -all; quit"

gui: compile
	@echo "== Running GUI (ModelSim) =="
	$(VSIM) $(WORK).$(TOP) -do "log -r /*; run -all"

# ---- Verilator ----
VERILATOR := verilator
VER_FLAGS := -Wall --timing --trace --top-module $(TOP) --binary -Wno-UNUSEDSIGNAL -Wno-UNDRIVEN -Wno-SYNCASYNCNET
OBJDIR    := obj_dir
BIN       := $(OBJDIR)/V$(TOP)
WAVFILE   ?= waves.vcd

vbuild:
	@echo "== Building (Verilator) =="
	$(VERILATOR) $(VER_FLAGS) $(SRCS)

vsim: vbuild
	@echo "== Running (Verilator) =="
	./$(BIN)

vwave: vsim
	@if [ ! -f $(WAVFILE) ]; then \
		echo "Error: '$(WAVFILE)' not found."; \
		exit 1; \
	fi
	@echo "== Opening Surfer =="
	surfer $(WAVFILE) &

# ---- Clean ----
clean:
	@echo "== Cleaning =="
	rm -rf $(WORK) $(OBJDIR) transcript vsim.wlf $(WAVFILE)

.PHONY: compile run gui vbuild vsim vwave clean