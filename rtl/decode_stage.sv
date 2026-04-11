/* Copyright (c) 2024 Tobias Scheipel, David Beikircher, Florian Riedl
 * Embedded Architectures & Systems Group, Graz University of Technology
 * SPDX-License-Identifier: MIT
 * ---------------------------------------------------------------------
 * File: decode_stage.sv
 */
module decode_stage (
    input logic clk,
    input logic rst,
    input logic [31:0]  instruction_in,
    input logic [31:0]  program_counter_in,
    input forwarding::t exe_forwarding_in,
    input forwarding::t mem_forwarding_in,
    input forwarding::t wb_forwarding_in,
    output logic [31:0]   rs1_data_reg_out,
    output logic [31:0]   rs2_data_reg_out,
    output logic [31:0]   program_counter_reg_out,
    output instruction::t instruction_reg_out,
    input  pipeline_status::forwards_t  status_forwards_in,
    output pipeline_status::forwards_t  status_forwards_out,
    input  pipeline_status::backwards_t status_backwards_in,
    output pipeline_status::backwards_t status_backwards_out,
    input  logic [31:0] jump_address_backwards_in,
    output logic [31:0] jump_address_backwards_out
);
    logic [31:0] rf_read_data1, rf_read_data2;

    register_file rf (
        .clk(clk),
        .rst(rst),
        .read_address1(instruction_in[19:15]),
        .read_data1(rf_read_data1),
        .read_address2(instruction_in[24:20]),
        .read_data2(rf_read_data2),
        .write_address(wb_forwarding_in.address),
        .write_data(wb_forwarding_in.data),
        .write_enable(wb_forwarding_in.data_valid && wb_forwarding_in.address != 5'b0)
    );

    instruction::t decoded;
    always_comb begin
        decoded.rd_address  = instruction_in[11:7];
        decoded.rs1_address = instruction_in[19:15];
        decoded.rs2_address = instruction_in[24:20];
        decoded.csr         = csr::t'(instruction_in[31:20]);
        decoded.immediate   = 32'b0;
        decoded.op          = op::ILLEGAL;
        casez (instruction_in)
            32'b?????????????????????????0110111:begin decoded.op=op::LUI;    decoded.rs1_address=5'b0; decoded.rs2_address=5'b0; decoded.immediate={instruction_in[31:12],12'b0}; end
            32'b?????????????????????????0010111 :begin decoded.op=op::AUIPC;  decoded.rs1_address=5'b0; decoded.rs2_address=5'b0; decoded.immediate={instruction_in[31:12],12'b0}; end
            32'b?????????????????????????1101111: begin decoded.op=op::JAL;    decoded.rs1_address=5'b0; decoded.rs2_address=5'b0; decoded.immediate={{11{instruction_in[31]}},instruction_in[31],instruction_in[19:12],instruction_in[20],instruction_in[30:21],1'b0}; end
            32'b????????????_?????_000_?????_1100111: begin decoded.op=op::JALR;   decoded.rs2_address=5'b0; decoded.immediate={{20{instruction_in[31]}},instruction_in[31:20]}; end
            32'b???????_?????_?????_000_?????_1100011: begin decoded.op=op::BEQ;   decoded.rd_address=5'b0; decoded.immediate={{19{instruction_in[31]}},instruction_in[31],instruction_in[7],instruction_in[30:25],instruction_in[11:8],1'b0}; end
            32'b???????_?????_?????_001_?????_1100011: begin decoded.op=op::BNE;   decoded.rd_address=5'b0; decoded.immediate={{19{instruction_in[31]}},instruction_in[31],instruction_in[7],instruction_in[30:25],instruction_in[11:8],1'b0}; end
            32'b???????_?????_?????_100_?????_1100011: begin decoded.op=op::BLT;   decoded.rd_address=5'b0; decoded.immediate={{19{instruction_in[31]}},instruction_in[31],instruction_in[7],instruction_in[30:25],instruction_in[11:8],1'b0}; end
            32'b???????_?????_?????_101_?????_1100011: begin decoded.op=op::BGE;   decoded.rd_address=5'b0; decoded.immediate={{19{instruction_in[31]}},instruction_in[31],instruction_in[7],instruction_in[30:25],instruction_in[11:8],1'b0}; end
            32'b???????_?????_?????_110_?????_1100011: begin decoded.op=op::BLTU;  decoded.rd_address=5'b0; decoded.immediate={{19{instruction_in[31]}},instruction_in[31],instruction_in[7],instruction_in[30:25],instruction_in[11:8],1'b0}; end
            32'b???????_?????_?????_111_?????_1100011: begin decoded.op=op::BGEU;  decoded.rd_address=5'b0; decoded.immediate={{19{instruction_in[31]}},instruction_in[31],instruction_in[7],instruction_in[30:25],instruction_in[11:8],1'b0}; end
            32'b????????????_?????_000_?????_0000011: begin decoded.op=op::LB;     decoded.rs2_address=5'b0; decoded.immediate={{20{instruction_in[31]}},instruction_in[31:20]}; end
            32'b????????????_?????_001_?????_0000011: begin decoded.op=op::LH;     decoded.rs2_address=5'b0; decoded.immediate={{20{instruction_in[31]}},instruction_in[31:20]}; end
            32'b????????????_?????_010_?????_0000011: begin decoded.op=op::LW;     decoded.rs2_address=5'b0; decoded.immediate={{20{instruction_in[31]}},instruction_in[31:20]}; end
            32'b????????????_?????_100_?????_0000011: begin decoded.op=op::LBU;    decoded.rs2_address=5'b0; decoded.immediate={{20{instruction_in[31]}},instruction_in[31:20]}; end
            32'b????????????_?????_101_?????_0000011: begin decoded.op=op::LHU;    decoded.rs2_address=5'b0; decoded.immediate={{20{instruction_in[31]}},instruction_in[31:20]}; end
            32'b???????_?????_?????_000_?????_0100011: begin decoded.op=op::SB;    decoded.rd_address=5'b0; decoded.immediate={{20{instruction_in[31]}},instruction_in[31:25],instruction_in[11:7]}; end
            32'b???????_?????_?????_001_?????_0100011: begin decoded.op=op::SH;    decoded.rd_address=5'b0; decoded.immediate={{20{instruction_in[31]}},instruction_in[31:25],instruction_in[11:7]}; end
            32'b???????_?????_?????_010_?????_0100011: begin decoded.op=op::SW;    decoded.rd_address=5'b0; decoded.immediate={{20{instruction_in[31]}},instruction_in[31:25],instruction_in[11:7]}; end
            32'b????????????_?????_000_?????_0010011: begin decoded.op=op::ADDI;   decoded.rs2_address=5'b0; decoded.immediate={{20{instruction_in[31]}},instruction_in[31:20]}; end
            32'b????????????_?????_010_?????_0010011: begin decoded.op=op::SLTI;   decoded.rs2_address=5'b0; decoded.immediate={{20{instruction_in[31]}},instruction_in[31:20]}; end
            32'b????????????_?????_011_?????_0010011: begin decoded.op=op::SLTIU;  decoded.rs2_address=5'b0; decoded.immediate={{20{instruction_in[31]}},instruction_in[31:20]}; end
            32'b????????????_?????_100_?????_0010011: begin decoded.op=op::XORI;   decoded.rs2_address=5'b0; decoded.immediate={{20{instruction_in[31]}},instruction_in[31:20]}; end
            32'b????????????_?????_110_?????_0010011: begin decoded.op=op::ORI;    decoded.rs2_address=5'b0; decoded.immediate={{20{instruction_in[31]}},instruction_in[31:20]}; end
            32'b????????????_?????_111_?????_0010011: begin decoded.op=op::ANDI;   decoded.rs2_address=5'b0; decoded.immediate={{20{instruction_in[31]}},instruction_in[31:20]}; end
            32'b0000000_?????_?????_001_?????_0010011: begin decoded.op=op::SLLI;  decoded.rs2_address=5'b0; decoded.immediate={27'b0,instruction_in[24:20]}; end
            32'b0000000_?????_?????_101_?????_0010011: begin decoded.op=op::SRLI;  decoded.rs2_address=5'b0; decoded.immediate={27'b0,instruction_in[24:20]}; end
            32'b0100000_?????_?????_101_?????_0010011: begin decoded.op=op::SRAI;  decoded.rs2_address=5'b0; decoded.immediate={27'b0,instruction_in[24:20]}; end
            32'b0000000_?????_?????_000_?????_0110011: decoded.op=op::ADD;
            32'b0100000_?????_?????_000_?????_0110011: decoded.op=op::SUB;
            32'b0000000_?????_?????_001_?????_0110011: decoded.op=op::SLL;
            32'b0000000_?????_?????_010_?????_0110011: decoded.op=op::SLT;
            32'b0000000_?????_?????_011_?????_0110011: decoded.op=op::SLTU;
            32'b0000000_?????_?????_100_?????_0110011: decoded.op=op::XOR;
            32'b0000000_?????_?????_101_?????_0110011: decoded.op=op::SRL;
            32'b0100000_?????_?????_101_?????_0110011: decoded.op=op::SRA;
            32'b0000000_?????_?????_110_?????_0110011: decoded.op=op::OR;
            32'b0000000_?????_?????_111_?????_0110011: decoded.op=op::AND;
            32'b????????????_?????_000_?????_0001111: begin decoded.op=op::FENCE;   decoded.rd_address=5'b0; decoded.rs1_address=5'b0; decoded.rs2_address=5'b0; end
            32'b????????????_?????_001_?????_0001111: begin decoded.op=op::FENCE_I; decoded.rd_address=5'b0; decoded.rs1_address=5'b0; decoded.rs2_address=5'b0; end
            32'b000000000000_00000_000_00000_1110011: begin decoded.op=op::ECALL;   decoded.rd_address=5'b0; decoded.rs1_address=5'b0; decoded.rs2_address=5'b0; end
            32'b000000000001_00000_000_00000_1110011: begin decoded.op=op::EBREAK;  decoded.rd_address=5'b0; decoded.rs1_address=5'b0; decoded.rs2_address=5'b0; end
            32'b001100000010_00000_000_00000_1110011: begin decoded.op=op::MRET;    decoded.rd_address=5'b0; decoded.rs1_address=5'b0; decoded.rs2_address=5'b0; end
            32'b000100000101_00000_000_00000_1110011: begin decoded.op=op::WFI;     decoded.rd_address=5'b0; decoded.rs1_address=5'b0; decoded.rs2_address=5'b0; end
            32'b????????????_?????_001_?????_1110011: begin decoded.op=op::CSRRW;   decoded.rs2_address=5'b0; end
            32'b????????????_?????_010_?????_1110011: begin decoded.op=op::CSRRS;   decoded.rs2_address=5'b0; end
            32'b????????????_?????_011_?????_1110011: begin decoded.op=op::CSRRC;   decoded.rs2_address=5'b0; end
            32'b????????????_?????_101_?????_1110011: begin decoded.op=op::CSRRWI;  decoded.rs1_address=5'b0; decoded.rs2_address=5'b0; decoded.immediate={27'b0,instruction_in[19:15]}; end
            32'b????????????_?????_110_?????_1110011: begin decoded.op=op::CSRRSI;  decoded.rs1_address=5'b0; decoded.rs2_address=5'b0; decoded.immediate={27'b0,instruction_in[19:15]}; end
            32'b????????????_?????_111_?????_1110011: begin decoded.op=op::CSRRCI;  decoded.rs1_address=5'b0; decoded.rs2_address=5'b0; decoded.immediate={27'b0,instruction_in[19:15]}; end
            default: begin decoded.op=op::ILLEGAL; decoded.rd_address=5'b0; decoded.rs1_address=5'b0; decoded.rs2_address=5'b0; end
        endcase
    end

    logic [31:0] rs1_data, rs2_data;
    logic rs1_waiting, rs2_waiting;

    always_comb begin
        rs1_waiting = 1'b0;
        if (decoded.rs1_address == 5'b0) rs1_data = 32'b0;
        else if (exe_forwarding_in.address == decoded.rs1_address && exe_forwarding_in.address != 5'b0) begin
            rs1_data = exe_forwarding_in.data_valid ? exe_forwarding_in.data : 32'b0;
            if (!exe_forwarding_in.data_valid) rs1_waiting = 1'b1;
        end
        else if (mem_forwarding_in.address == decoded.rs1_address && mem_forwarding_in.address != 5'b0) begin
            rs1_data = mem_forwarding_in.data_valid ? mem_forwarding_in.data : 32'b0;
            if (!mem_forwarding_in.data_valid) rs1_waiting = 1'b1;
        end
        else if (wb_forwarding_in.address == decoded.rs1_address && wb_forwarding_in.address != 5'b0) begin
            rs1_data = wb_forwarding_in.data_valid ? wb_forwarding_in.data : 32'b0;
            if (!wb_forwarding_in.data_valid) rs1_waiting = 1'b1;
        end
        else rs1_data = rf_read_data1;
    end

    always_comb begin
        rs2_waiting = 1'b0;
        if (decoded.rs2_address == 5'b0) rs2_data = 32'b0;
        else if (exe_forwarding_in.address == decoded.rs2_address && exe_forwarding_in.address != 5'b0) begin
            rs2_data = exe_forwarding_in.data_valid ? exe_forwarding_in.data : 32'b0;
            if (!exe_forwarding_in.data_valid) rs2_waiting = 1'b1;
        end
        else if (mem_forwarding_in.address == decoded.rs2_address && mem_forwarding_in.address != 5'b0) begin
            rs2_data = mem_forwarding_in.data_valid ? mem_forwarding_in.data : 32'b0;
            if (!mem_forwarding_in.data_valid) rs2_waiting = 1'b1;
        end
        else if (wb_forwarding_in.address == decoded.rs2_address && wb_forwarding_in.address != 5'b0) begin
            rs2_data = wb_forwarding_in.data_valid ? wb_forwarding_in.data : 32'b0;
            if (!wb_forwarding_in.data_valid) rs2_waiting = 1'b1;
        end
        else rs2_data = rf_read_data2;
    end

    logic stall_for_forwarding;
    assign stall_for_forwarding = (rs1_waiting || rs2_waiting) && (status_forwards_in == pipeline_status::VALID);

    always_comb begin
        if (status_backwards_in == pipeline_status::JUMP) begin
            status_backwards_out = pipeline_status::JUMP;
            jump_address_backwards_out = jump_address_backwards_in;
        end
        else if (status_backwards_in == pipeline_status::STALL || stall_for_forwarding) begin
            status_backwards_out = pipeline_status::STALL;
            jump_address_backwards_out = jump_address_backwards_in;
        end
        else begin
            status_backwards_out = pipeline_status::READY;
            jump_address_backwards_out = jump_address_backwards_in;
        end
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            rs1_data_reg_out        <= 32'b0;
            rs2_data_reg_out        <= 32'b0;
            program_counter_reg_out <= 32'b0;
            instruction_reg_out     <= instruction::NOP;
            status_forwards_out     <= pipeline_status::BUBBLE;
        end
        else if (status_backwards_in == pipeline_status::JUMP) begin
            rs1_data_reg_out        <= 32'b0;
            rs2_data_reg_out        <= 32'b0;
            program_counter_reg_out <= program_counter_in;
            instruction_reg_out     <= instruction::NOP;
            status_forwards_out     <= pipeline_status::BUBBLE;
        end
        else if (status_backwards_in == pipeline_status::STALL) begin
            rs1_data_reg_out        <= rs1_data_reg_out;
            rs2_data_reg_out        <= rs2_data_reg_out;
            program_counter_reg_out <= program_counter_reg_out;
            instruction_reg_out     <= instruction_reg_out;
            status_forwards_out     <= status_forwards_out;
        end
        else if (stall_for_forwarding) begin
            rs1_data_reg_out        <= 32'b0;
            rs2_data_reg_out        <= 32'b0;
            program_counter_reg_out <= program_counter_in;
            instruction_reg_out     <= instruction::NOP;
            status_forwards_out     <= pipeline_status::BUBBLE;
        end
        else begin
            rs1_data_reg_out        <= rs1_data;
            rs2_data_reg_out        <= rs2_data;
            program_counter_reg_out <= program_counter_in;
            instruction_reg_out     <= decoded;
            status_forwards_out     <= status_forwards_in;
        end
    end

endmodule