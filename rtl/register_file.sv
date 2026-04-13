module register_file (
    input logic clk,
    input logic rst,
    input  logic [4:0]  read_address1,
    output logic [31:0] read_data1,
    input  logic [4:0]  read_address2,
    output logic [31:0] read_data2,
    input  logic [4:0]  write_address,
    input  logic [31:0] write_data,
    input  logic        write_enable
);
    logic [31:0] regs [0:31];

    always_ff @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < 32; i++) begin
                regs[i] <= 32'b0;
            end
        end
        else if (write_enable && write_address != 5'b0) begin
            regs[write_address] <= write_data;
        end
    end

    assign read_data1 = (read_address1 == 5'b0) ? 32'b0 : regs[read_address1];
    assign read_data2 = (read_address2 == 5'b0) ? 32'b0 : regs[read_address2];

endmodule
