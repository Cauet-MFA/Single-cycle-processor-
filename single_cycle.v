module cpu (
    input clk,
    input reset
);

    // =============================
    // Program Counter
    // =============================
    reg [31:0] pc;

    // =============================
    // Instruction Memory
    // =============================
    reg [31:0] instr_mem [0:255];

    initial begin
        $readmemb("program.mem", instr_mem);
    end

    wire [31:0] instr;
    assign instr = instr_mem[pc >> 2];

    // =============================
    // Decode
    // =============================
    wire [5:0] opcode = instr[31:26];
    wire [4:0] rs     = instr[25:21];
    wire [4:0] rt     = instr[20:16];
    wire [4:0] rd     = instr[15:11];
    wire [15:0] imm   = instr[15:0];

    wire [31:0] imm_ext = {{16{imm[15]}}, imm};

    // =============================
    // Register File
    // =============================
    reg [31:0] regs [0:31];

    wire [31:0] reg_rs = regs[rs];
    wire [31:0] reg_rt = regs[rt];

    // =============================
    // Data Memory
    // =============================
    reg [31:0] data_mem [0:255];

    // =============================
    // ALU
    // =============================
    reg [31:0] alu_result;
    wire zero = (alu_result == 0);

    always @(*) begin
        case (opcode)
            6'b000000: alu_result = reg_rs + reg_rt; // ADD
            6'b000001: alu_result = reg_rs - reg_rt; // SUB
            6'b100011: alu_result = reg_rs + imm_ext; // LW
            6'b101011: alu_result = reg_rs + imm_ext; // SW
            6'b000100: alu_result = reg_rs - reg_rt; // BEQ
            default:   alu_result = 0;
        endcase
    end

    // =============================
    // Write Back + PC update
    // =============================
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 0;
        end else begin
            pc <= pc + 4;

            case (opcode)
                6'b000000: regs[rd] <= alu_result; // ADD
                6'b000001: regs[rd] <= alu_result; // SUB

                6'b100011: // LW
                    regs[rt] <= data_mem[alu_result >> 2];

                6'b101011: // SW
                    data_mem[alu_result >> 2] <= reg_rt;

                6'b000100: // BEQ
                    if (zero)
                        pc <= pc + (imm_ext << 2);
            endcase
        end
    end

endmodule
