/* Copyright (c) 2024 Tobias Scheipel, David Beikircher, Florian Riedl
 * Embedded Architectures & Systems Group, Graz University of Technology
 * SPDX-License-Identifier: MIT
 * ---------------------------------------------------------------------
 * File: memory_stage.sv
 */
module memory_stage (
    input logic clk,
    input logic rst,
    wishbone_interface.master wb,
    input logic [31:0]   source_data_in,
    input logic [31:0]   rd_data_in,
    input instruction::t instruction_in,
    input logic [31:0]   program_counter_in,
    input logic [31:0]   next_program_counter_in,
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
    // Memory access signals
    logic is_load, is_store;
    logic mem_active;
    logic [31:0] mem_addr;

    assign is_load  = (status_forwards_in == pipeline_status::VALID) && (
        instruction_in.op == op::LB  ||
        instruction_in.op == op::LH  ||
        instruction_in.op == op::LW  ||
        instruction_in.op == op::LBU ||
        instruction_in.op == op::LHU);

    assign is_store = (status_forwards_in == pipeline_status::VALID) && (
        instruction_in.op == op::SB ||
        instruction_in.op == op::SH ||
        instruction_in.op == op::SW);

    assign mem_active = is_load || is_store;
    assign mem_addr   = rd_data_in >> 2; // word address

    // Misalignment check
    logic misaligned;
    always_comb begin
        case (instruction_in.op)
            op::LH, op::LHU, op::SH: misaligned = rd_data_in[0];
            op::LW, op::SW:          misaligned = |rd_data_in[1:0];
            default:                  misaligned = 1'b0;
        endcase
    end

    // Wishbone byte select
    always_comb begin
        case (instruction_in.op)
            op::LB, op::LBU, op::SB: begin
                case (rd_data_in[1:0])
                    2'b00: wb.sel = 4'b0001;
                    2'b01: wb.sel = 4'b0010;
                    2'b10: wb.sel = 4'b0100;
                    2'b11: wb.sel = 4'b1000;
                    default: wb.sel = 4'b0001;
                endcase
            end
            op::LH, op::LHU, op::SH: begin
                case (rd_data_in[1])
                    1'b0: wb.sel = 4'b0011;
                    1'b1: wb.sel = 4'b1100;
                    default: wb.sel = 4'b0011;
                endcase
            end
            default: wb.sel = 4'b1111;
        endcase
    end

    // Wishbone signals
    assign wb.cyc      = mem_active && !misaligned;
    assign wb.stb      = mem_active && !misaligned;
    assign wb.adr      = mem_addr;
    assign wb.we       = is_store;
    logic [31:0] latched_addr;
    logic [31:0] latched_data;
    logic        latched_we;
    logic        mem_pending;

    always_ff @(posedge clk) begin
        if (rst) begin
            latched_addr <= 32'b0;
            latched_data <= 32'b0;
            latched_we   <= 1'b0;
            mem_pending  <= 1'b0;
        end
        else if (mem_active && !misaligned && !mem_pending && !wb.ack && !wb.err) begin
            latched_addr <= mem_addr;
            latched_data <= source_data_in;
            latched_we   <= is_store;
            mem_pending  <= 1'b1;
        end
        else if (wb.ack || wb.err) begin
            mem_pending  <= 1'b0;
        end
    end

    assign wb.cyc      = (mem_active && !misaligned) || mem_pending;
    assign wb.stb      = (mem_active && !misaligned) || mem_pending;
    assign wb.adr      = mem_pending ? latched_addr : mem_addr;
    assign wb.we       = mem_pending ? latched_we   : is_store;
    assign wb.dat_mosi = mem_pending ? latched_data : source_data_in;

    // Stall while waiting for memory
    logic mem_stall;
    assign mem_stall = ((mem_active && !misaligned) || mem_pending) && !wb.ack && !wb.err;

    // Backwards status
    always_comb begin
        if (status_backwards_in == pipeline_status::JUMP) begin
            status_backwards_out       = pipeline_status::JUMP;
            jump_address_backwards_out = jump_address_backwards_in;
        end
        else if (status_backwards_in == pipeline_status::STALL || mem_stall) begin
            status_backwards_out       = pipeline_status::STALL;
            jump_address_backwards_out = jump_address_backwards_in;
        end
        else begin
            status_backwards_out       = pipeline_status::READY;
            jump_address_backwards_out = jump_address_backwards_in;
        end
    end

    // Read data with sign extension
    logic [31:0] read_data;
    always_comb begin
        case (instruction_in.op)
            op::LB: begin
                case (rd_data_in[1:0])
                    2'b00: read_data = {{24{wb.dat_miso[7]}},  wb.dat_miso[7:0]};
                    2'b01: read_data = {{24{wb.dat_miso[15]}}, wb.dat_miso[15:8]};
                    2'b10: read_data = {{24{wb.dat_miso[23]}}, wb.dat_miso[23:16]};
                    2'b11: read_data = {{24{wb.dat_miso[31]}}, wb.dat_miso[31:24]};
                    default: read_data = 32'b0;
                endcase
            end
            op::LBU: begin
                case (rd_data_in[1:0])
                    2'b00: read_data = {24'b0, wb.dat_miso[7:0]};
                    2'b01: read_data = {24'b0, wb.dat_miso[15:8]};
                    2'b10: read_data = {24'b0, wb.dat_miso[23:16]};
                    2'b11: read_data = {24'b0, wb.dat_miso[31:24]};
                    default: read_data = 32'b0;
                endcase
            end
            op::LH: begin
                case (rd_data_in[1])
                    1'b0: read_data = {{16{wb.dat_miso[15]}}, wb.dat_miso[15:0]};
                    1'b1: read_data = {{16{wb.dat_miso[31]}}, wb.dat_miso[31:16]};
                    default: read_data = 32'b0;
                endcase
            end
            op::LHU: begin
                case (rd_data_in[1])
                    1'b0: read_data = {16'b0, wb.dat_miso[15:0]};
                    1'b1: read_data = {16'b0, wb.dat_miso[31:16]};
                    default: read_data = 32'b0;
                endcase
            end
            op::LW: read_data = wb.dat_miso;
            default: read_data = 32'b0;
        endcase
    end

    // Forwarding
    logic fwd_valid;
    assign fwd_valid = (status_forwards_in == pipeline_status::VALID) &&
                       (instruction_in.rd_address != 5'b0) &&
                       !is_store;

    // Output registers
    always_ff @(posedge clk) begin
        if (rst) begin
            source_data_reg_out          <= 32'b0;
            rd_data_reg_out              <= 32'b0;
            instruction_reg_out          <= instruction::NOP;
            program_counter_reg_out      <= 32'b0;
            next_program_counter_reg_out <= 32'b0;
            forwarding_out               <= '{data_valid: 1'b0, data: 32'b0, address: 5'b0};
            status_forwards_out          <= pipeline_status::BUBBLE;
        end
        else if (status_backwards_in == pipeline_status::STALL) begin
            source_data_reg_out          <= source_data_reg_out;
            rd_data_reg_out              <= rd_data_reg_out;
            instruction_reg_out          <= instruction_reg_out;
            program_counter_reg_out      <= program_counter_reg_out;
            next_program_counter_reg_out <= next_program_counter_reg_out;
            forwarding_out               <= forwarding_out;
            status_forwards_out          <= status_forwards_out;
        end
        else if (mem_stall) begin
            source_data_reg_out          <= source_data_reg_out;
            rd_data_reg_out              <= rd_data_reg_out;
            instruction_reg_out          <= instruction_reg_out;
            program_counter_reg_out      <= program_counter_reg_out;
            next_program_counter_reg_out <= next_program_counter_reg_out;
            forwarding_out               <= forwarding_out;
            status_forwards_out          <= status_forwards_out;
        end
        else begin
            source_data_reg_out          <= source_data_in;
            instruction_reg_out          <= instruction_in;
            program_counter_reg_out      <= program_counter_in;
            next_program_counter_reg_out <= next_program_counter_in;

            if (is_load && wb.ack) begin
                rd_data_reg_out <= read_data;
                forwarding_out  <= '{
                    data_valid: fwd_valid,
                    data:       read_data,
                    address:    instruction_in.rd_address
                };
            end
            else begin
                rd_data_reg_out <= rd_data_in;
                forwarding_out  <= '{
                    data_valid: fwd_valid,
                    data:       rd_data_in,
                    address:    instruction_in.rd_address
                };
            end

            if (misaligned && status_forwards_in == pipeline_status::VALID) begin
                if (is_load)
                    status_forwards_out <= pipeline_status::LOAD_MISALIGNED;
                else
                    status_forwards_out <= pipeline_status::STORE_MISALIGNED;
            end
            else if (wb.err && status_forwards_in == pipeline_status::VALID) begin
                if (is_load)
                    status_forwards_out <= pipeline_status::LOAD_FAULT;
                else
                    status_forwards_out <= pipeline_status::STORE_FAULT;
            end
            else
                status_forwards_out <= status_forwards_in;
        end
    end

endmodule
