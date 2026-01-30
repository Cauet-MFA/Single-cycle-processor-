# ===============================
# Ferramentas
# ===============================
IVERILOG = iverilog
VVP      = vvp
GTKWAVE  = gtkwave

# ===============================
# Arquivos
# ===============================
TOP      = testbench
SRC      = cpu.v testbench.v
OUT      = cpu_sim
VCD      = cpu.vcd

# ===============================
# Alvo padrão
# ===============================
all: compile run

# ===============================
# Compilação
# ===============================
compile:
	$(IVERILOG) -o $(OUT) $(SRC)

# ===============================
# Execução
# ===============================
run:
	$(VVP) $(OUT)

# ===============================
# Waveform
# ===============================
wave:
	$(GTKWAVE) $(VCD)

# ===============================
# Limpeza
# ===============================
clean:
	rm -f $(OUT) $(VCD)

.PHONY: all compile run wave clean
