/* Copyright (c) 2024 Tobias Scheipel, David Beikircher, Florian Riedl
 * Embedded Architectures & Systems Group, Graz University of Technology
 * SPDX-License-Identifier: MIT
 * ---------------------------------------------------------------------
 * File: writeback_stage.sv
 */
module writeback_stage (
    input logic clk,
    input logic rst,
    input logic [31:0]   source_data_in,
    input logic [31:0]   rd_data_in,
    input instruction::t instruction_in,
    input logic [31:0]   program_counter_in,
    input logic [31:0]   next_program_counter_in,
    input logic external_interrupt_in,
    input logic timer_interrupt_in,
    output forwarding::t forwarding_out,
    input  pipeline_status::forwards_t  status_forwards_in,
    output pipeline_status::backwards_t status_backwards_out,
    output logic [31:0] jump_address_backwards_out
);
    // CSR registers
    logic [31:0] mstatus;   // machine status
    logic [31:0] mtvec;     // trap vector base address
    logic [31:0] mepc;      // machine exception PC
    logic [31:0] mcause;    // machine cause
    logic [31:0] mip;       // machine interrupt pending
    logic [31:0] mie;       // machine interrupt enable
    logic [31:0] mscratch;  // machine scratch
    logic [31:0] mcycle;    // cycle counter
    logic [31:0] mcycleh;   // cycle counter high
    logic [31:0] minstret;  // instructions retired
    logic [31:0] minstreth; // instructions retired high

    // Interrupt/trap detection
    logic is_valid;
    logic is_trap;
    logic is_interrupt;
    logic is_mret;
    logic mstatus_mie;      // global interrupt enable bit
    logic [31:0] mcause_val;
    logic [31:0] trap_pc;

    assign is_valid    = (status_forwards_in == pipeline_status::VALID);
    assign mstatus_mie = mstatus[3];

    // Pending interrupts
    logic timer_pending, external_pending;
    assign timer_pending    = timer_interrupt_in    && mie[7]  && mstatus_mie;
    assign external_pending = external_interrupt_in && mie[11] && mstatus_mie;
    assign is_interrupt     = timer_pending || external_pending;

    // Trap detection from pipeline status
    logic is_exception;
    always_comb begin
        is_exception = 1'b0;
        mcause_val   = 32'b0;
        case (status_forwards_in)
            pipeline_status::FETCH_MISALIGNED:   begin is_exception=1'b1; mcause_val=32'h0; end
            pipeline_status::FETCH_FAULT:        begin is_exception=1'b1; mcause_val=32'h1; end
            pipeline_status::ILLEGAL_INSTRUCTION:begin is_exception=1'b1; mcause_val=32'h2; end
            pipeline_status::LOAD_MISALIGNED:    begin is_exception=1'b1; mcause_val=32'h4; end
            pipeline_status::LOAD_FAULT:         begin is_exception=1'b1; mcause_val=32'h5; end
            pipeline_status::STORE_MISALIGNED:   begin is_exception=1'b1; mcause_val=32'h6; end
            pipeline_status::STORE_FAULT:        begin is_exception=1'b1; mcause_val=32'h7; end
            pipeline_status::ECALL:              begin is_exception=1'b1; mcause_val=32'hB; end
            pipeline_status::EBREAK:             begin is_exception=1'b1; mcause_val=32'h3; end
            default: is_exception = 1'b0;
        endcase
    end

    assign is_trap = is_valid && (is_exception || is_interrupt);
    assign is_mret = is_valid && (instruction_in.op == op::MRET);

    // Trap vector address
    always_comb begin
        if (mtvec[1:0] == 2'b01 && is_interrupt)
            trap_pc = {mtvec[31:2], 2'b00} + (
                timer_pending ? 32'd7*4 : 32'd11*4
            );
        else
            trap_pc = {mtvec[31:2], 2'b00};
    end

    // Backwards status
    always_comb begin
        if (is_mret) begin
            status_backwards_out       = pipeline_status::JUMP;
            jump_address_backwards_out = mepc;
        end
        else if (is_trap) begin
            status_backwards_out       = pipeline_status::JUMP;
            jump_address_backwards_out = trap_pc;
        end
        else begin
            status_backwards_out       = pipeline_status::READY;
            jump_address_backwards_out = 32'b0;
        end
    end

    // CSR read data
    logic [31:0] csr_read_data;
    always_comb begin
        case (instruction_in.csr)
            csr::MSTATUS:   csr_read_data = mstatus;
            csr::MTVEC:     csr_read_data = mtvec;
            csr::MEPC:      csr_read_data = mepc;
            csr::MCAUSE:    csr_read_data = mcause;
            csr::MIP:       csr_read_data = mip;
            csr::MIE:       csr_read_data = mie;
            csr::MSCRATCH:  csr_read_data = mscratch;
            csr::MCYCLE:    csr_read_data = mcycle;
            csr::MCYCLEH:   csr_read_data = mcycleh;
            csr::MINSTRET:  csr_read_data = minstret;
            csr::MINSTRETH: csr_read_data = minstreth;
            default:        csr_read_data = 32'b0;
        endcase
    end

    // CSR write data
    logic [31:0] csr_write_data;
    always_comb begin
        case (instruction_in.op)
            op::CSRRW, op::CSRRWI:
                csr_write_data = rd_data_in;
            op::CSRRS, op::CSRRSI:
                csr_write_data = csr_read_data | rd_data_in;
            op::CSRRC, op::CSRRCI:
                csr_write_data = csr_read_data & ~rd_data_in;
            default:
                csr_write_data = 32'b0;
        endcase
    end

    logic is_csr_write;
    assign is_csr_write = is_valid && (
        instruction_in.op == op::CSRRW  ||
        instruction_in.op == op::CSRRS  ||
        instruction_in.op == op::CSRRC  ||
        instruction_in.op == op::CSRRWI ||
        instruction_in.op == op::CSRRSI ||
        instruction_in.op == op::CSRRCI);

    // Forwarding output
    logic fwd_valid;
    assign fwd_valid = is_valid && (instruction_in.rd_address != 5'b0) &&
                       !(instruction_in.op == op::SB ||
                         instruction_in.op == op::SH ||
                         instruction_in.op == op::SW);

    logic [31:0] wb_rd_data;
    always_comb begin
        if (is_csr_write)
            wb_rd_data = csr_read_data;
        else
            wb_rd_data = rd_data_in;
    end

    always_comb begin
        forwarding_out.data_valid = fwd_valid;
        forwarding_out.data       = wb_rd_data;
        forwarding_out.address    = instruction_in.rd_address;
    end

    // Sequential logic
    always_ff @(posedge clk) begin
        if (rst) begin
            mstatus   <= 32'b0;
            mtvec     <= 32'b0;
            mepc      <= 32'b0;
            mcause    <= 32'b0;
            mip       <= 32'b0;
            mie       <= 32'b0;
            mscratch  <= 32'b0;
            mcycle    <= 32'b0;
            mcycleh   <= 32'b0;
            minstret  <= 32'b0;
            minstreth <= 32'b0;
        end
        else begin
            // Cycle counter always increments
            {mcycleh, mcycle} <= {mcycleh, mcycle} + 64'b1;

            // Update MIP based on interrupts
            mip[7]  <= timer_interrupt_in;
            mip[11] <= external_interrupt_in;

            if (is_trap) begin
                // Save PC and cause, disable interrupts
                mepc      <= program_counter_in;
                mcause    <= is_interrupt ?
                    (timer_pending ? 32'h80000007 : 32'h8000000B) :
                    mcause_val;
                mstatus   <= {mstatus[31:8], mstatus[3], mstatus[7:4], 1'b0, mstatus[2:0]};
            end
            else if (is_mret) begin
                // Restore interrupt enable
                mstatus <= {mstatus[31:8], 1'b1, mstatus[7:4], mstatus[7], mstatus[2:0]};
            end
            else if (is_csr_write) begin
                case (instruction_in.csr)
                    csr::MSTATUS:  mstatus  <= csr_write_data;
                    csr::MTVEC:    mtvec    <= csr_write_data;
                    csr::MEPC:     mepc     <= csr_write_data;
                    csr::MCAUSE:   mcause   <= csr_write_data;
                    csr::MIE:      mie      <= csr_write_data;
                    csr::MSCRATCH: mscratch <= csr_write_data;
                    csr::MCYCLE:   mcycle   <= csr_write_data;
                    csr::MCYCLEH:  mcycleh  <= csr_write_data;
                    csr::MINSTRET: minstret <= csr_write_data;
                    csr::MINSTRETH:minstreth<= csr_write_data;
                    default: ;
                endcase
            end

            // Instruction retired counter
            if (is_valid && !is_trap)
                {minstreth, minstret} <= {minstreth, minstret} + 64'b1;
        end
    end

endmodule