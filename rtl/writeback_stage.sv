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
    logic [31:0] mstatus;
    logic [31:0] mtvec;
    logic [31:0] mepc;
    logic [31:0] mcause;
    logic [31:0] mip;
    logic [31:0] mie;
    logic [31:0] mscratch;
    logic [63:0] mcycle;
    logic [63:0] minstret;

    logic is_valid;
    logic is_exception;
    logic is_interrupt;
    logic is_trap;
    logic is_mret;
    logic is_fence_i;
    logic is_csr_op;
    logic mstatus_mie;
    logic [31:0] mcause_val;
    logic [31:0] trap_pc;

    assign is_valid    = (status_forwards_in == pipeline_status::VALID);
    assign mstatus_mie = mstatus[3];

    assign is_fence_i = is_valid && (instruction_in.op == op::FENCE_I);

    assign is_csr_op = is_valid && (
        instruction_in.op == op::CSRRW  ||
        instruction_in.op == op::CSRRS  ||
        instruction_in.op == op::CSRRC  ||
        instruction_in.op == op::CSRRWI ||
        instruction_in.op == op::CSRRSI ||
        instruction_in.op == op::CSRRCI);

    assign is_mret = is_valid && (instruction_in.op == op::MRET);

    logic timer_pending, external_pending;
    assign timer_pending    = timer_interrupt_in    && mie[7]  && mstatus_mie;
    assign external_pending = external_interrupt_in && mie[11] && mstatus_mie;
    assign is_interrupt     = timer_pending || external_pending;

    always_comb begin
        is_exception = 1'b0;
        mcause_val   = 32'b0;
        case (status_forwards_in)
            pipeline_status::FETCH_MISALIGNED:    begin is_exception=1'b1; mcause_val=32'h0; end
            pipeline_status::FETCH_FAULT:         begin is_exception=1'b1; mcause_val=32'h1; end
            pipeline_status::ILLEGAL_INSTRUCTION: begin is_exception=1'b1; mcause_val=32'h2; end
            pipeline_status::EBREAK:              begin is_exception=1'b1; mcause_val=32'h3; end
            pipeline_status::LOAD_MISALIGNED:     begin is_exception=1'b1; mcause_val=32'h4; end
            pipeline_status::LOAD_FAULT:          begin is_exception=1'b1; mcause_val=32'h5; end
            pipeline_status::STORE_MISALIGNED:    begin is_exception=1'b1; mcause_val=32'h6; end
            pipeline_status::STORE_FAULT:         begin is_exception=1'b1; mcause_val=32'h7; end
            pipeline_status::ECALL:               begin is_exception=1'b1; mcause_val=32'hB; end
            default: is_exception = 1'b0;
        endcase
    end

    // Exception has higher priority than interrupt
    assign is_trap = is_exception || (!is_exception && is_interrupt);

    // Trap vector
    always_comb begin
        if (mtvec[1:0] == 2'b01 && is_interrupt && !is_exception)
            trap_pc = {mtvec[31:2], 2'b00} + (timer_pending ? 32'd28 : 32'd44);
        else
            trap_pc = {mtvec[31:2], 2'b00};
    end

    // MRET: check if interrupt pending after restoring MIE from MPIE
    logic mret_int_pending;
    assign mret_int_pending = is_mret && (
        (timer_interrupt_in    && mie[7]  && mstatus[7]) ||
        (external_interrupt_in && mie[11] && mstatus[7]));

    // Backwards status
    always_comb begin
        if (is_trap) begin
            status_backwards_out       = pipeline_status::JUMP;
            jump_address_backwards_out = trap_pc;
        end
        else if (mret_int_pending) begin
            // Interrupt triggers immediately after MRET
            logic [31:0] mret_trap_pc;
            if (mtvec[1:0] == 2'b01)
                mret_trap_pc = {mtvec[31:2], 2'b00} +
                    ((timer_interrupt_in && mie[7] && mstatus[7]) ? 32'd28 : 32'd44);
            else
                mret_trap_pc = {mtvec[31:2], 2'b00};
            status_backwards_out       = pipeline_status::JUMP;
            jump_address_backwards_out = mret_trap_pc;
        end
        else if (is_mret) begin
            status_backwards_out       = pipeline_status::JUMP;
            jump_address_backwards_out = mepc;
        end
        else if (is_fence_i) begin
            status_backwards_out       = pipeline_status::JUMP;
            jump_address_backwards_out = next_program_counter_in;
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
            csr::MSTATUS:   csr_read_data = mstatus & 32'h88;
            csr::MTVEC:     csr_read_data = mtvec;
            csr::MEPC:      csr_read_data = mepc;
            csr::MCAUSE:    csr_read_data = mcause;
            csr::MIP:       csr_read_data = mip;
            csr::MIE:       csr_read_data = mie & 32'h880;
            csr::MSCRATCH:  csr_read_data = mscratch;
            csr::MCYCLE:    csr_read_data = mcycle[31:0];
            csr::MCYCLEH:   csr_read_data = mcycle[63:32];
            csr::MINSTRET:  csr_read_data = minstret[31:0];
            csr::MINSTRETH: csr_read_data = minstret[63:32];
            default:        csr_read_data = 32'b0;
        endcase
    end

    // CSR write data
    logic [31:0] csr_write_data;
    always_comb begin
        case (instruction_in.op)
            op::CSRRW, op::CSRRWI: csr_write_data = rd_data_in;
            op::CSRRS, op::CSRRSI: csr_write_data = csr_read_data | rd_data_in;
            op::CSRRC, op::CSRRCI: csr_write_data = csr_read_data & ~rd_data_in;
            default:                csr_write_data = 32'b0;
        endcase
    end

    // Only write CSR if source is non-zero (CSRRS/CSRRC with rs1=x0 don't write)
    logic csr_do_write;
    always_comb begin
        case (instruction_in.op)
            op::CSRRW, op::CSRRWI: csr_do_write = is_csr_op;
            op::CSRRS, op::CSRRSI: csr_do_write = is_csr_op && (rd_data_in != 32'b0);
            op::CSRRC, op::CSRRCI: csr_do_write = is_csr_op && (rd_data_in != 32'b0);
            default:                csr_do_write = 1'b0;
        endcase
    end

    // Forwarding
    logic fwd_valid;
    assign fwd_valid = is_valid && (instruction_in.rd_address != 5'b0) &&
                       !(instruction_in.op == op::SB ||
                         instruction_in.op == op::SH ||
                         instruction_in.op == op::SW);

    logic [31:0] wb_rd_data;
    assign wb_rd_data = is_csr_op ? csr_read_data : rd_data_in;

    always_comb begin
        forwarding_out.data_valid = fwd_valid;
        forwarding_out.data       = wb_rd_data;
        forwarding_out.address    = instruction_in.rd_address;
    end

    // Sequential logic
    always_ff @(posedge clk) begin
        if (rst) begin
            mstatus  <= 32'b0;
            mtvec    <= 32'b0;
            mepc     <= 32'b0;
            mcause   <= 32'b0;
            mip      <= 32'b0;
            mie      <= 32'b0;
            mscratch <= 32'b0;
            mcycle   <= 64'b0;
            minstret <= 64'b0;
        end
        else begin
            // Cycle counter always increments
            mcycle <= mcycle + 64'b1;

            // Update MIP
            mip[7]  <= timer_interrupt_in;
            mip[11] <= external_interrupt_in;

            if (is_trap) begin
                mepc    <= program_counter_in & ~32'b1;
                mcause  <= is_exception ?
                    mcause_val :
                    (timer_pending ? 32'h80000007 : 32'h8000000B);
                // Save MIE to MPIE, clear MIE
                mstatus <= {mstatus[31:8], mstatus[3], mstatus[6:4], 1'b0, mstatus[2:0]};
            end
            else if (mret_int_pending) begin
                // Re-trigger interrupt: MEPC stays, update cause, keep MIE=0
                mcause  <= (timer_interrupt_in && mie[7] && mstatus[7]) ?
                           32'h80000007 : 32'h8000000B;
                mstatus <= {mstatus[31:8], mstatus[7], mstatus[6:4], 1'b0, mstatus[2:0]};
            end
            else if (is_mret) begin
                // Restore MIE from MPIE, set MPIE=1
                mstatus <= {mstatus[31:8], 1'b1, mstatus[6:4], mstatus[7], mstatus[2:0]};
            end
            else if (csr_do_write) begin
                case (instruction_in.csr)
                    csr::MSTATUS:  mstatus  <= csr_write_data & 32'h88;
                    csr::MTVEC:    mtvec    <= {csr_write_data[31:2], 2'b00};
                    csr::MEPC:     mepc     <= {csr_write_data[31:2], 2'b00};
                    csr::MCAUSE:   mcause   <= csr_write_data;
                    csr::MIE:      mie      <= csr_write_data & 32'h880;
                    csr::MSCRATCH: mscratch <= csr_write_data;
                    csr::MCYCLE:   mcycle   <= {mcycle[63:32], csr_write_data} + 64'b1;
                    csr::MCYCLEH:  mcycle   <= {csr_write_data, mcycle[31:0]} + 64'b1;
                    csr::MINSTRET: minstret <= {minstret[63:32], csr_write_data};
                    csr::MINSTRETH:minstret <= {csr_write_data, minstret[31:0]};
                    default: ;
                endcase
            end

            // Instruction retired counter
            if (is_valid && !is_trap)
                minstret <= minstret + 64'b1;
        end
    end

endmodule