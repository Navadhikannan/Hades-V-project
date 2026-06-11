/* Copyright (c) 2024 Tobias Scheipel, David Beikircher, Florian Riedl
 * Embedded Architectures & Systems Group, Graz University of Technology
 * SPDX-License-Identifier: MIT
 * ---------------------------------------------------------------------
 * File: instruction_decoder.sv
 */
module instruction_decoder (
    input  logic [31:0]   instruction_in,
    output instruction::t instruction_out
);
    always_comb begin
        instruction_out.rd_address  = instruction_in[11:7];
        instruction_out.rs1_address = instruction_in[19:15];
        instruction_out.rs2_address = instruction_in[24:20];
        instruction_out.csr         = csr::t'(instruction_in[31:20]);
        instruction_out.immediate   = 32'b0;
        instruction_out.op          = op::ILLEGAL;

        casez (instruction_in)
            32'b?????????????????????????0110111: begin
                instruction_out.op          = op::LUI;
                instruction_out.rs1_address = 5'b0;
                instruction_out.rs2_address = 5'b0;
                instruction_out.immediate   = {instruction_in[31:12], 12'b0};
            end
            32'b?????????????????????????0010111: begin
                instruction_out.op          = op::AUIPC;
                instruction_out.rs1_address = 5'b0;
                instruction_out.rs2_address = 5'b0;
                instruction_out.immediate   = {instruction_in[31:12], 12'b0};
            end
            32'b?????????????????????????1101111: begin
                instruction_out.op          = op::JAL;
                instruction_out.rs1_address = 5'b0;
                instruction_out.rs2_address = 5'b0;
                instruction_out.immediate   = {{11{instruction_in[31]}}, instruction_in[31], instruction_in[19:12], instruction_in[20], instruction_in[30:21], 1'b0};
            end
            32'b????????????_?????_000_?????_1100111: begin
                instruction_out.op          = op::JALR;
                instruction_out.rs2_address = 5'b0;
                instruction_out.immediate   = {{20{instruction_in[31]}}, instruction_in[31:20]};
            end
            32'b???????_?????_?????_000_?????_1100011: begin
                instruction_out.op        = op::BEQ;
                instruction_out.rd_address  = 5'b0;
                instruction_out.immediate = {{19{instruction_in[31]}}, instruction_in[31], instruction_in[7], instruction_in[30:25], instruction_in[11:8], 1'b0};
            end
            32'b???????_?????_?????_001_?????_1100011: begin
                instruction_out.op        = op::BNE;
                instruction_out.rd_address  = 5'b0;
                instruction_out.immediate = {{19{instruction_in[31]}}, instruction_in[31], instruction_in[7], instruction_in[30:25], instruction_in[11:8], 1'b0};
            end
            32'b???????_?????_?????_100_?????_1100011: begin
                instruction_out.op        = op::BLT;
                instruction_out.rd_address  = 5'b0;
                instruction_out.immediate = {{19{instruction_in[31]}}, instruction_in[31], instruction_in[7], instruction_in[30:25], instruction_in[11:8], 1'b0};
            end
            32'b???????_?????_?????_101_?????_1100011: begin
                instruction_out.op        = op::BGE;
                instruction_out.rd_address  = 5'b0;
                instruction_out.immediate = {{19{instruction_in[31]}}, instruction_in[31], instruction_in[7], instruction_in[30:25], instruction_in[11:8], 1'b0};
            end
            32'b???????_?????_?????_110_?????_1100011: begin
                instruction_out.op        = op::BLTU;
                instruction_out.rd_address  = 5'b0;
                instruction_out.immediate = {{19{instruction_in[31]}}, instruction_in[31], instruction_in[7], instruction_in[30:25], instruction_in[11:8], 1'b0};
            end
            32'b???????_?????_?????_111_?????_1100011: begin
                instruction_out.op        = op::BGEU;
                instruction_out.rd_address  = 5'b0;
                instruction_out.immediate = {{19{instruction_in[31]}}, instruction_in[31], instruction_in[7], instruction_in[30:25], instruction_in[11:8], 1'b0};
            end
            32'b????????????_?????_000_?????_0000011: begin
                instruction_out.op        = op::LB;
                instruction_out.rs2_address = 5'b0;
                instruction_out.immediate = {{20{instruction_in[31]}}, instruction_in[31:20]};
            end
            32'b????????????_?????_001_?????_0000011: begin
                instruction_out.op        = op::LH;
                instruction_out.rs2_address = 5'b0;
                instruction_out.immediate = {{20{instruction_in[31]}}, instruction_in[31:20]};
            end
            32'b????????????_?????_010_?????_0000011: begin
                instruction_out.op        = op::LW;
                instruction_out.rs2_address = 5'b0;
                instruction_out.immediate = {{20{instruction_in[31]}}, instruction_in[31:20]};
            end
            32'b????????????_?????_100_?????_0000011: begin
                instruction_out.op        = op::LBU;
                instruction_out.rs2_address = 5'b0;
                instruction_out.immediate = {{20{instruction_in[31]}}, instruction_in[31:20]};
            end
            32'b????????????_?????_101_?????_0000011: begin
                instruction_out.op        = op::LHU;
                instruction_out.rs2_address = 5'b0;
                instruction_out.immediate = {{20{instruction_in[31]}}, instruction_in[31:20]};
            end
            32'b???????_?????_?????_000_?????_0100011: begin
                instruction_out.op        = op::SB;
                instruction_out.rd_address  = 5'b0;
                instruction_out.immediate = {{20{instruction_in[31]}}, instruction_in[31:25], instruction_in[11:7]};
            end
            32'b???????_?????_?????_001_?????_0100011: begin
                instruction_out.op        = op::SH;
                instruction_out.rd_address  = 5'b0;
                instruction_out.immediate = {{20{instruction_in[31]}}, instruction_in[31:25], instruction_in[11:7]};
            end
            32'b???????_?????_?????_010_?????_0100011: begin
                instruction_out.op        = op::SW;
                instruction_out.rd_address  = 5'b0;
                instruction_out.immediate = {{20{instruction_in[31]}}, instruction_in[31:25], instruction_in[11:7]};
            end
            32'b????????????_?????_000_?????_0010011: begin
                instruction_out.op        = op::ADDI;
                instruction_out.rs2_address = 5'b0;
                instruction_out.immediate = {{20{instruction_in[31]}}, instruction_in[31:20]};
            end
            32'b????????????_?????_010_?????_0010011: begin
                instruction_out.op        = op::SLTI;
                instruction_out.rs2_address = 5'b0;
                instruction_out.immediate = {{20{instruction_in[31]}}, instruction_in[31:20]};
            end
            32'b????????????_?????_011_?????_0010011: begin
                instruction_out.op        = op::SLTIU;
                instruction_out.rs2_address = 5'b0;
                instruction_out.immediate = {{20{instruction_in[31]}}, instruction_in[31:20]};
            end
            32'b????????????_?????_100_?????_0010011: begin
                instruction_out.op        = op::XORI;
                instruction_out.rs2_address = 5'b0;
                instruction_out.immediate = {{20{instruction_in[31]}}, instruction_in[31:20]};
            end
            32'b????????????_?????_110_?????_0010011: begin
                instruction_out.op        = op::ORI;
                instruction_out.rs2_address = 5'b0;
                instruction_out.immediate = {{20{instruction_in[31]}}, instruction_in[31:20]};
            end
            32'b????????????_?????_111_?????_0010011: begin
                instruction_out.op        = op::ANDI;
                instruction_out.rs2_address = 5'b0;
                instruction_out.immediate = {{20{instruction_in[31]}}, instruction_in[31:20]};
            end
            32'b0000000_?????_?????_001_?????_0010011: begin
                instruction_out.op        = op::SLLI;
                instruction_out.rs2_address = 5'b0;
                instruction_out.immediate = {27'b0, instruction_in[24:20]};
            end
            32'b0000000_?????_?????_101_?????_0010011: begin
                instruction_out.op        = op::SRLI;
                instruction_out.rs2_address = 5'b0;
                instruction_out.immediate = {27'b0, instruction_in[24:20]};
            end
            32'b0100000_?????_?????_101_?????_0010011: begin
                instruction_out.op        = op::SRAI;
                instruction_out.rs2_address = 5'b0;
                instruction_out.immediate = {27'b0, instruction_in[24:20]};
            end
            32'b0000000_?????_?????_000_?????_0110011: instruction_out.op = op::ADD;
            32'b0100000_?????_?????_000_?????_0110011: instruction_out.op = op::SUB;
            32'b0000000_?????_?????_001_?????_0110011: instruction_out.op = op::SLL;
            32'b0000000_?????_?????_010_?????_0110011: instruction_out.op = op::SLT;
            32'b0000000_?????_?????_011_?????_0110011: instruction_out.op = op::SLTU;
            32'b0000000_?????_?????_100_?????_0110011: instruction_out.op = op::XOR;
            32'b0000000_?????_?????_101_?????_0110011: instruction_out.op = op::SRL;
            32'b0100000_?????_?????_101_?????_0110011: instruction_out.op = op::SRA;
            32'b0000000_?????_?????_110_?????_0110011: instruction_out.op = op::OR;
            32'b0000000_?????_?????_111_?????_0110011: instruction_out.op = op::AND;
            32'b????????????_?????_000_?????_0001111: begin
                instruction_out.op = op::FENCE;
                instruction_out.immediate = {{20{instruction_in[31]}}, instruction_in[31:20]};
            end
            32'b????????????_?????_001_?????_0001111: begin
                instruction_out.op = op::FENCE_I;
                instruction_out.immediate = {{20{instruction_in[31]}}, instruction_in[31:20]};
            end
            32'b000000000000_00000_000_00000_1110011: begin
                instruction_out.op          = op::ECALL;
                instruction_out.rd_address  = 5'b0;
                instruction_out.rs1_address = 5'b0;
                instruction_out.rs2_address = 5'b0;
            end
            32'b000000000001_00000_000_00000_1110011: begin
                instruction_out.op          = op::EBREAK;
                instruction_out.rd_address  = 5'b0;
                instruction_out.rs1_address = 5'b0;
                instruction_out.rs2_address = 5'b0;
            end
            32'b001100000010_00000_000_00000_1110011: begin
                instruction_out.op          = op::MRET;
                instruction_out.rd_address  = 5'b0;
                instruction_out.rs1_address = 5'b0;
                instruction_out.rs2_address = 5'b0;
            end
            32'b000100000101_00000_000_00000_1110011: begin
                instruction_out.op          = op::WFI;
                instruction_out.rd_address  = 5'b0;
                instruction_out.rs1_address = 5'b0;
                instruction_out.rs2_address = 5'b0;
            end
            32'b????????????_?????_001_?????_1110011: begin
                instruction_out.op          = op::CSRRW;
                instruction_out.rs2_address = 5'b0;
            end
            32'b????????????_?????_010_?????_1110011: begin
                instruction_out.op          = op::CSRRS;
                instruction_out.rs2_address = 5'b0;
            end
            32'b????????????_?????_011_?????_1110011: begin
                instruction_out.op          = op::CSRRC;
                instruction_out.rs2_address = 5'b0;
            end
            32'b????????????_?????_101_?????_1110011: begin
                instruction_out.op          = op::CSRRWI;
                instruction_out.rs1_address = 5'b0;
                instruction_out.rs2_address = 5'b0;
                instruction_out.immediate   = {27'b0, instruction_in[19:15]};
            end
            32'b????????????_?????_110_?????_1110011: begin
                instruction_out.op          = op::CSRRSI;
                instruction_out.rs1_address = 5'b0;
                instruction_out.rs2_address = 5'b0;
                instruction_out.immediate   = {27'b0, instruction_in[19:15]};
            end
            32'b????????????_?????_111_?????_1110011: begin
                instruction_out.op          = op::CSRRCI;
                instruction_out.rs1_address = 5'b0;
                instruction_out.rs2_address = 5'b0;
                instruction_out.immediate   = {27'b0, instruction_in[19:15]};
            end
            default: begin
                instruction_out.op          = op::ILLEGAL;
                instruction_out.rd_address  = 5'b0;
                instruction_out.rs1_address = 5'b0;
                instruction_out.rs2_address = 5'b0;
            end
        endcase
    end

endmodule
