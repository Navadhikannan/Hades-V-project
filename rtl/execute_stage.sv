/* Copyright (c) 2024 Tobias Scheipel, David Beikircher, Florian Riedl
 * Embedded Architectures & Systems Group, Graz University of Technology
 * SPDX-License-Identifier: MIT
 * ---------------------------------------------------------------------
 * File: execute_stage.sv
 */
module execute_stage (
    input logic clk,
    input logic rst,
    input logic [31:0]   rs1_data_in,
    input logic [31:0]   rs2_data_in,
    input instruction::t instruction_in,
    input logic [31:0]   program_counter_in,
    output logic [31:0]   source_data_reg_out,
    output logic [31:0]   rd_data_reg_out,
    output instruction::t instruction_reg_out,
    output logic [31:0]   program_counter_reg_out,
    output logic [31:0]   next_program_counter_reg_out,
    output forwarding::t  forwarding_out,
    input  pipeline_status::forwards_t  status_forwards_in,
    output pipeline_status::forwards_t  status_forwards_out,
    input  pipeline_status::backwards_t status_backwards_in,
    output pipeline_status::backwards_t status_backwards_out,
    input  logic [31:0] jump_address_backwards_in,
    output logic [31:0] jump_address_backwards_out
);
    // ALU operands
    logic [31:0] alu_a, alu_b, alu_result;
    logic [31:0] next_pc;
    logic        branch_taken;
    logic        is_jump;

    // ALU input selection
    always_comb begin
        case (instruction_in.op)
            op::AUIPC: alu_a = program_counter_in;
            op::JAL:   alu_a = program_counter_in;
            op::JALR:  alu_a = program_counter_in;
            default:   alu_a = rs1_data_in;
        endcase
    end

    always_comb begin
        case (instruction_in.op)
            op::ADD, op::SUB, op::SLL, op::SLT, op::SLTU,
            op::XOR, op::SRL, op::SRA, op::OR, op::AND:
                alu_b = rs2_data_in;
            default:
                alu_b = instruction_in.immediate;
        endcase
    end

    // ALU operation
    always_comb begin
        case (instruction_in.op)
            op::ADD, op::ADDI, op::AUIPC, op::LUI,
            op::LB, op::LH, op::LW, op::LBU, op::LHU,
            op::SB, op::SH, op::SW,
            op::JAL, op::JALR:
                alu_result = alu_a + alu_b;
            op::SUB:
                alu_result = alu_a - alu_b;
            op::SLL, op::SLLI:
                alu_result = alu_a << alu_b[4:0];
            op::SLT, op::SLTI:
                alu_result = ($signed(alu_a) < $signed(alu_b)) ? 32'b1 : 32'b0;
            op::SLTU, op::SLTIU:
                alu_result = (alu_a < alu_b) ? 32'b1 : 32'b0;
            op::XOR, op::XORI:
                alu_result = alu_a ^ alu_b;
            op::SRL, op::SRLI:
                alu_result = alu_a >> alu_b[4:0];
            op::SRA, op::SRAI:
                alu_result = $signed(alu_a) >>> alu_b[4:0];
            op::OR, op::ORI:
                alu_result = alu_a | alu_b;
            op::AND, op::ANDI:
                alu_result = alu_a & alu_b;
            default:
                alu_result = 32'b0;
        endcase
    end

    // Branch condition
    always_comb begin
        case (instruction_in.op)
            op::BEQ:  branch_taken = (rs1_data_in == rs2_data_in);
            op::BNE:  branch_taken = (rs1_data_in != rs2_data_in);
            op::BLT:  branch_taken = ($signed(rs1_data_in) < $signed(rs2_data_in));
            op::BGE:  branch_taken = ($signed(rs1_data_in) >= $signed(rs2_data_in));
            op::BLTU: branch_taken = (rs1_data_in < rs2_data_in);
            op::BGEU: branch_taken = (rs1_data_in >= rs2_data_in);
            default:  branch_taken = 1'b0;
        endcase
    end

    // Jump detection
    assign is_jump = (instruction_in.op == op::JAL) ||
                     (instruction_in.op == op::JALR) ||
                     (branch_taken && (
                         instruction_in.op == op::BEQ ||
                         instruction_in.op == op::BNE ||
                         instruction_in.op == op::BLT ||
                         instruction_in.op == op::BGE ||
                         instruction_in.op == op::BLTU ||
                         instruction_in.op == op::BGEU));

    // Next PC calculation
    always_comb begin
        case (instruction_in.op)
            op::JAL:
                next_pc = program_counter_in + instruction_in.immediate;
            op::JALR:
                next_pc = (rs1_data_in + instruction_in.immediate) & ~32'b1;
            op::BEQ, op::BNE, op::BLT, op::BGE, op::BLTU, op::BGEU:
                next_pc = branch_taken ?
                    (program_counter_in + instruction_in.immediate) :
                    (program_counter_in + 32'd4);
            default:
                next_pc = program_counter_in + 32'd4;
        endcase
    end

    // Check misaligned jump
    logic fetch_misaligned;
    assign fetch_misaligned = is_jump && (next_pc[1:0] != 2'b00);

    // Backwards status
    always_comb begin
        if (status_backwards_in == pipeline_status::JUMP) begin
            status_backwards_out       = pipeline_status::JUMP;
            jump_address_backwards_out = jump_address_backwards_in;
        end
        else if (status_backwards_in == pipeline_status::STALL) begin
            status_backwards_out       = pipeline_status::STALL;
            jump_address_backwards_out = jump_address_backwards_in;
        end
        else if (is_jump && !fetch_misaligned && status_forwards_in == pipeline_status::VALID) begin
            status_backwards_out       = pipeline_status::JUMP;
            jump_address_backwards_out = next_pc;
        end
        else begin
            status_backwards_out       = pipeline_status::READY;
            jump_address_backwards_out = jump_address_backwards_in;
        end
    end

    // rd_data - for JAL/JALR store return address
    logic [31:0] rd_data;
    always_comb begin
        case (instruction_in.op)
            op::JAL, op::JALR:
                rd_data = program_counter_in + 32'd4;
            op::LUI:
                rd_data = instruction_in.immediate;
            op::LB, op::LH, op::LW, op::LBU, op::LHU:
                rd_data = alu_result; // memory address
            op::SB, op::SH, op::SW:
                rd_data = alu_result; // memory address
            default:
                rd_data = alu_result;
        endcase
    end

    // Forwarding output
    logic fwd_valid;
    always_comb begin
        case (instruction_in.op)
            op::LB, op::LH, op::LW, op::LBU, op::LHU:
                fwd_valid = 1'b0; // data not yet available
            default:
                fwd_valid = (status_forwards_in == pipeline_status::VALID) &&
                            (instruction_in.rd_address != 5'b0);
        endcase
    end

    // Output registers
    always_ff @(posedge clk) begin
        if (rst) begin
            source_data_reg_out         <= 32'b0;
            rd_data_reg_out             <= 32'b0;
            instruction_reg_out         <= instruction::NOP;
            program_counter_reg_out     <= 32'b0;
            next_program_counter_reg_out<= 32'b0;
            forwarding_out              <= '{data_valid: 1'b0, data: 32'b0, address: 5'b0};
            status_forwards_out         <= pipeline_status::BUBBLE;
        end
        else if (status_backwards_in == pipeline_status::STALL) begin
            source_data_reg_out         <= source_data_reg_out;
            rd_data_reg_out             <= rd_data_reg_out;
            instruction_reg_out         <= instruction_reg_out;
            program_counter_reg_out     <= program_counter_reg_out;
            next_program_counter_reg_out<= next_program_counter_reg_out;
            forwarding_out              <= forwarding_out;
            status_forwards_out         <= status_forwards_out;
        end
        else begin
            source_data_reg_out         <= rs2_data_in;
            rd_data_reg_out             <= rd_data;
            instruction_reg_out         <= instruction_in;
            program_counter_reg_out     <= program_counter_in;
            next_program_counter_reg_out<= next_pc;
            forwarding_out              <= '{
                data_valid: fwd_valid,
                data:       rd_data,
                address:    instruction_in.rd_address
            };
            if (fetch_misaligned && status_forwards_in == pipeline_status::VALID)
                status_forwards_out <= pipeline_status::FETCH_MISALIGNED;
            else if (is_jump && status_forwards_in == pipeline_status::VALID)
                status_forwards_out <= pipeline_status::BUBBLE;
            else
                status_forwards_out <= status_forwards_in;
        end
    end

endmodule
