module fetch_stage (
    input logic clk,
    input logic rst,
    wishbone_interface.master wb,
    output logic [31:0] instruction_reg_out,
    output logic [31:0] program_counter_reg_out,
    output pipeline_status::forwards_t  status_forwards_out,
    input  pipeline_status::backwards_t status_backwards_in,
    input  logic [31:0] jump_address_backwards_in
);
    logic [31:0] pc;
    logic [31:0] pc_next;

    always_comb begin
        if (status_backwards_in == pipeline_status::JUMP)
            pc_next = jump_address_backwards_in;
        else if (status_backwards_in == pipeline_status::STALL)
            pc_next = pc;
        else if (wb.ack || wb.err)
            pc_next = pc + 32'd4;
        else
            pc_next = pc;
    end

    assign wb.cyc      = 1'b1;
    assign wb.stb      = 1'b1;
    assign wb.adr      = pc >> 2;
    assign wb.we       = 1'b0;
    assign wb.sel      = 4'b1111;
    assign wb.dat_mosi = 32'b0;

    always_ff @(posedge clk) begin
        if (rst) begin
            pc                      <= constants::RESET_ADDRESS;
            instruction_reg_out     <= constants::NOP;
            program_counter_reg_out <= constants::RESET_ADDRESS;
            status_forwards_out     <= pipeline_status::BUBBLE;
        end
        else begin
            pc <= pc_next;
            if (status_backwards_in == pipeline_status::STALL) begin
                instruction_reg_out     <= instruction_reg_out;
                program_counter_reg_out <= program_counter_reg_out;
                status_forwards_out     <= status_forwards_out;
            end
            else if (status_backwards_in == pipeline_status::JUMP) begin
                instruction_reg_out     <= constants::NOP;
                program_counter_reg_out <= pc;
                status_forwards_out     <= pipeline_status::BUBBLE;
            end
            else if (wb.err) begin
                instruction_reg_out     <= constants::NOP;
                program_counter_reg_out <= pc;
                status_forwards_out     <= pipeline_status::FETCH_FAULT;
            end
            else if (wb.ack) begin
                instruction_reg_out     <= wb.dat_miso;
                program_counter_reg_out <= pc;
                status_forwards_out     <= pipeline_status::VALID;
            end
            else begin
                instruction_reg_out     <= constants::NOP;
                program_counter_reg_out <= pc;
                status_forwards_out     <= pipeline_status::BUBBLE;
            end
        end
    end

endmodule