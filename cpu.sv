module cpu (
    input  logic clk,
    input  logic rst,

    // Wishbone master port - Instruction Fetch
    wishbone_interface.master memory_fetch_port,

    // Wishbone master port - Data Memory
    wishbone_interface.master memory_mem_port,

    // Interrupts
    input  logic external_interrupt_in,
    input  logic timer_interrupt_in
);

    localparam logic [6:0] OPC_LUI    = 7'b0110111;
    localparam logic [6:0] OPC_AUIPC  = 7'b0010111;
    localparam logic [6:0] OPC_JAL    = 7'b1101111;
    localparam logic [6:0] OPC_JALR   = 7'b1100111;
    localparam logic [6:0] OPC_BRANCH = 7'b1100011;
    localparam logic [6:0] OPC_LOAD   = 7'b0000011;
    localparam logic [6:0] OPC_STORE  = 7'b0100011;
    localparam logic [6:0] OPC_IMM    = 7'b0010011;
    localparam logic [6:0] OPC_REG    = 7'b0110011;
    localparam logic [6:0] OPC_SYSTEM = 7'b1110011;

    
    // ALU Operation Codes
   
    localparam logic [3:0] ALU_ADD  = 4'b0000;
    localparam logic [3:0] ALU_SUB  = 4'b0001;
    localparam logic [3:0] ALU_AND  = 4'b0010;
    localparam logic [3:0] ALU_OR   = 4'b0011;
    localparam logic [3:0] ALU_XOR  = 4'b0100;
    localparam logic [3:0] ALU_SLL  = 4'b0101;
    localparam logic [3:0] ALU_SRL  = 4'b0110;
    localparam logic [3:0] ALU_SRA  = 4'b0111;
    localparam logic [3:0] ALU_SLT  = 4'b1000;
    localparam logic [3:0] ALU_SLTU = 4'b1001;
    localparam logic [3:0] ALU_LUI  = 4'b1010;

   
    // Pipeline Registers (IF/ID)
   
    logic [31:0] if_id_pc;
    logic [31:0] if_id_instr;
    logic        if_id_valid;

        // Pipeline Registers (ID/EX)
    
    logic [31:0] id_ex_pc;
    logic [31:0] id_ex_rs1_data;
    logic [31:0] id_ex_rs2_data;
    logic [31:0] id_ex_imm;
    logic [4:0]  id_ex_rs1;
    logic [4:0]  id_ex_rs2;
    logic [4:0]  id_ex_rd;
    logic [3:0]  id_ex_alu_op;
    logic        id_ex_alu_src;
    logic        id_ex_mem_read;
    logic        id_ex_mem_write;
    logic        id_ex_reg_write;
    logic        id_ex_mem_to_reg;
    logic        id_ex_branch;
    logic        id_ex_jal;
    logic        id_ex_jalr;
    logic [2:0]  id_ex_funct3;
    logic        id_ex_valid;

    // ----------------------------------------------------------------
    // Pipeline Registers (EX/MEM)
    // ----------------------------------------------------------------
    logic [31:0] ex_mem_alu_result;
    logic [31:0] ex_mem_rs2_data;
    logic [31:0] ex_mem_pc_branch;
    logic [4:0]  ex_mem_rd;
    logic        ex_mem_mem_read;
    logic        ex_mem_mem_write;
    logic        ex_mem_reg_write;
    logic        ex_mem_mem_to_reg;
    logic        ex_mem_branch;
    logic        ex_mem_branch_taken;
    logic        ex_mem_jal;
    logic        ex_mem_jalr;
    logic [2:0]  ex_mem_funct3;
    logic        ex_mem_valid;

   
    // Pipeline Registers (MEM/WB)
 
    logic [31:0] mem_wb_alu_result;
    logic [31:0] mem_wb_mem_data;
    logic [4:0]  mem_wb_rd;
    logic        mem_wb_reg_write;
    logic        mem_wb_mem_to_reg;
    logic        mem_wb_valid;

    // ----------------------------------------------------------------
    // PC
    // ----------------------------------------------------------------
    logic [31:0] pc;
    logic [31:0] pc_next;
    logic        pc_stall;
    logic        flush;

    // ----------------------------------------------------------------
    // Register File (32 x 32-bit)
    // ----------------------------------------------------------------
    logic [31:0] regfile [0:31];
    logic [31:0] rf_rs1_data, rf_rs2_data;
    logic [31:0] wb_data;

    // Write-back data mux
    assign wb_data = mem_wb_mem_to_reg ? mem_wb_mem_data : mem_wb_alu_result;

    // Register file read (combinational)
    assign rf_rs1_data = (if_id_instr[19:15] == 5'b0) ? 32'b0 : regfile[if_id_instr[19:15]];
    assign rf_rs2_data = (if_id_instr[24:20] == 5'b0) ? 32'b0 : regfile[if_id_instr[24:20]];

    // Register file write + reset
    integer i;
    always_ff @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                regfile[i] <= 32'b0;
        end else if (mem_wb_reg_write && mem_wb_valid && (mem_wb_rd != 5'b0)) begin
            regfile[mem_wb_rd] <= wb_data;
        end
    end


    // Wishbone Fetch Port (Instruction Fetch)
    
    logic fetch_ack;
    logic [31:0] fetched_instr;

    assign memory_fetch_port.cyc      = 1'b1;
    assign memory_fetch_port.stb      = !pc_stall && !flush;
    assign memory_fetch_port.adr      = pc;
    assign memory_fetch_port.we       = 1'b0;
    assign memory_fetch_port.sel      = 4'b1111;
    assign memory_fetch_port.dat_mosi = 32'b0;

    assign fetch_ack     = memory_fetch_port.ack;
    assign fetched_instr = memory_fetch_port.dat_miso;

       // Wishbone Mem Port (Data Memory)
   
    logic mem_ack;
    logic [31:0] mem_rdata;

    assign memory_mem_port.cyc      = ex_mem_mem_read | ex_mem_mem_write;
    assign memory_mem_port.stb      = ex_mem_mem_read | ex_mem_mem_write;
    assign memory_mem_port.adr      = ex_mem_alu_result;
    assign memory_mem_port.we       = ex_mem_mem_write;
    assign memory_mem_port.dat_mosi = ex_mem_rs2_data;

    always_comb begin
        case (ex_mem_funct3[1:0])
            2'b00:   memory_mem_port.sel = 4'b0001;
            2'b01:   memory_mem_port.sel = 4'b0011;
            default: memory_mem_port.sel = 4'b1111;
        endcase
    end

    assign mem_ack   = memory_mem_port.ack;
    assign mem_rdata = memory_mem_port.dat_miso;

    // ----------------------------------------------------------------
    // Immediate Generator
    // ----------------------------------------------------------------
    logic [31:0] imm_val;
    always_comb begin
        case (if_id_instr[6:0])
            OPC_IMM, OPC_LOAD, OPC_JALR:
                imm_val = {{20{if_id_instr[31]}}, if_id_instr[31:20]};
            OPC_STORE:
                imm_val = {{20{if_id_instr[31]}}, if_id_instr[31:25], if_id_instr[11:7]};
            OPC_BRANCH:
                imm_val = {{19{if_id_instr[31]}}, if_id_instr[31], if_id_instr[7],
                           if_id_instr[30:25], if_id_instr[11:8], 1'b0};
            OPC_LUI, OPC_AUIPC:
                imm_val = {if_id_instr[31:12], 12'b0};
            OPC_JAL:
                imm_val = {{11{if_id_instr[31]}}, if_id_instr[31], if_id_instr[19:12],
                           if_id_instr[20], if_id_instr[30:21], 1'b0};
            default:
                imm_val = 32'b0;
        endcase
    end

    // ----------------------------------------------------------------
    // Control Unit
    // ----------------------------------------------------------------
    logic [3:0] ctrl_alu_op;
    logic       ctrl_alu_src;
    logic       ctrl_mem_read;
    logic       ctrl_mem_write;
    logic       ctrl_reg_write;
    logic       ctrl_mem_to_reg;
    logic       ctrl_branch;
    logic       ctrl_jal;
    logic       ctrl_jalr;

    always_comb begin
        ctrl_alu_op     = ALU_ADD;
        ctrl_alu_src    = 1'b0;
        ctrl_mem_read   = 1'b0;
        ctrl_mem_write  = 1'b0;
        ctrl_reg_write  = 1'b0;
        ctrl_mem_to_reg = 1'b0;
        ctrl_branch     = 1'b0;
        ctrl_jal        = 1'b0;
        ctrl_jalr       = 1'b0;

        case (if_id_instr[6:0])
            OPC_REG: begin
                ctrl_reg_write = 1'b1;
                case ({if_id_instr[30], if_id_instr[14:12]})
                    4'b0000: ctrl_alu_op = ALU_ADD;
                    4'b1000: ctrl_alu_op = ALU_SUB;
                    4'b0001: ctrl_alu_op = ALU_SLL;
                    4'b0010: ctrl_alu_op = ALU_SLT;
                    4'b0011: ctrl_alu_op = ALU_SLTU;
                    4'b0100: ctrl_alu_op = ALU_XOR;
                    4'b0101: ctrl_alu_op = ALU_SRL;
                    4'b1101: ctrl_alu_op = ALU_SRA;
                    4'b0110: ctrl_alu_op = ALU_OR;
                    4'b0111: ctrl_alu_op = ALU_AND;
                    default: ctrl_alu_op = ALU_ADD;
                endcase
            end
            OPC_IMM: begin
                ctrl_reg_write = 1'b1;
                ctrl_alu_src   = 1'b1;
                case (if_id_instr[14:12])
                    3'b000: ctrl_alu_op = ALU_ADD;
                    3'b010: ctrl_alu_op = ALU_SLT;
                    3'b011: ctrl_alu_op = ALU_SLTU;
                    3'b100: ctrl_alu_op = ALU_XOR;
                    3'b110: ctrl_alu_op = ALU_OR;
                    3'b111: ctrl_alu_op = ALU_AND;
                    3'b001: ctrl_alu_op = ALU_SLL;
                    3'b101: ctrl_alu_op = if_id_instr[30] ? ALU_SRA : ALU_SRL;
                    default: ctrl_alu_op = ALU_ADD;
                endcase
            end
            OPC_LOAD: begin
                ctrl_reg_write  = 1'b1;
                ctrl_alu_src    = 1'b1;
                ctrl_mem_read   = 1'b1;
                ctrl_mem_to_reg = 1'b1;
            end
            OPC_STORE: begin
                ctrl_alu_src   = 1'b1;
                ctrl_mem_write = 1'b1;
            end
            OPC_BRANCH: begin
                ctrl_branch = 1'b1;
                ctrl_alu_op = ALU_SUB;
            end
            OPC_LUI: begin
                ctrl_reg_write = 1'b1;
                ctrl_alu_src   = 1'b1;
                ctrl_alu_op    = ALU_LUI;
            end
            OPC_AUIPC: begin
                ctrl_reg_write = 1'b1;
                ctrl_alu_src   = 1'b1;
            end
            OPC_JAL: begin
                ctrl_reg_write = 1'b1;
                ctrl_jal       = 1'b1;
            end
            OPC_JALR: begin
                ctrl_reg_write = 1'b1;
                ctrl_jalr      = 1'b1;
                ctrl_alu_src   = 1'b1;
            end
            default: begin end
        endcase
    end

    // ----------------------------------------------------------------
    // Forwarding & ALU
    // ----------------------------------------------------------------
    logic [31:0] fwd_rs1, fwd_rs2;
    logic [31:0] alu_a, alu_b, alu_result;

    always_comb begin
        if (ex_mem_reg_write && ex_mem_valid &&
            (ex_mem_rd == id_ex_rs1) && (ex_mem_rd != 5'b0))
            fwd_rs1 = ex_mem_alu_result;
        else if (mem_wb_reg_write && mem_wb_valid &&
                 (mem_wb_rd == id_ex_rs1) && (mem_wb_rd != 5'b0))
            fwd_rs1 = wb_data;
        else
            fwd_rs1 = id_ex_rs1_data;
    end

    always_comb begin
        if (ex_mem_reg_write && ex_mem_valid &&
            (ex_mem_rd == id_ex_rs2) && (ex_mem_rd != 5'b0))
            fwd_rs2 = ex_mem_alu_result;
        else if (mem_wb_reg_write && mem_wb_valid &&
                 (mem_wb_rd == id_ex_rs2) && (mem_wb_rd != 5'b0))
            fwd_rs2 = wb_data;
        else
            fwd_rs2 = id_ex_rs2_data;
    end

    assign alu_a = (id_ex_jal || id_ex_jalr) ? id_ex_pc   :
                   (id_ex_alu_op == ALU_LUI)  ? 32'b0      : fwd_rs1;
    assign alu_b = id_ex_alu_src              ? id_ex_imm  : fwd_rs2;

    always_comb begin
        case (id_ex_alu_op)
            ALU_ADD:  alu_result = alu_a + alu_b;
            ALU_SUB:  alu_result = alu_a - alu_b;
            ALU_AND:  alu_result = alu_a & alu_b;
            ALU_OR:   alu_result = alu_a | alu_b;
            ALU_XOR:  alu_result = alu_a ^ alu_b;
            ALU_SLL:  alu_result = alu_a << alu_b[4:0];
            ALU_SRL:  alu_result = alu_a >> alu_b[4:0];
            ALU_SRA:  alu_result = $signed(alu_a) >>> alu_b[4:0];
            ALU_SLT:  alu_result = ($signed(alu_a) < $signed(alu_b)) ? 32'b1 : 32'b0;
            ALU_SLTU: alu_result = (alu_a < alu_b) ? 32'b1 : 32'b0;
            ALU_LUI:  alu_result = alu_b;
            default:  alu_result = 32'b0;
        endcase
    end

    // ----------------------------------------------------------------
    // Branch Condition
    // ----------------------------------------------------------------
    logic branch_taken;
    always_comb begin
        case (id_ex_funct3)
            3'b000: branch_taken = (fwd_rs1 == fwd_rs2);
            3'b001: branch_taken = (fwd_rs1 != fwd_rs2);
            3'b100: branch_taken = ($signed(fwd_rs1) < $signed(fwd_rs2));
            3'b101: branch_taken = ($signed(fwd_rs1) >= $signed(fwd_rs2));
            3'b110: branch_taken = (fwd_rs1 < fwd_rs2);
            3'b111: branch_taken = (fwd_rs1 >= fwd_rs2);
            default: branch_taken = 1'b0;
        endcase
    end

    logic [31:0] branch_target;
    assign branch_target = id_ex_jalr ? ((fwd_rs1 + id_ex_imm) & ~32'b1)
                                      : (id_ex_pc + id_ex_imm);

    // ----------------------------------------------------------------
    // Hazard Detection
    // ----------------------------------------------------------------
    logic load_use_hazard;
    assign load_use_hazard = id_ex_mem_read && id_ex_valid &&
                             ((id_ex_rd == if_id_instr[19:15]) ||
                              (id_ex_rd == if_id_instr[24:20]));

    assign pc_stall = load_use_hazard;
    assign flush    = (id_ex_branch && branch_taken) || id_ex_jal || id_ex_jalr;

    // ----------------------------------------------------------------
    // PC Update
    // ----------------------------------------------------------------
    always_comb begin
        if (rst)
            pc_next = 32'b0;
        else if (flush)
            pc_next = branch_target;
        else if (pc_stall || !fetch_ack)
            pc_next = pc;
        else
            pc_next = pc + 32'd4;
    end

    // ----------------------------------------------------------------
    // Sequential Pipeline Updates
    // ----------------------------------------------------------------
    always_ff @(posedge clk) begin
        if (rst) begin
            pc              <= 32'b0;
            if_id_pc        <= 32'b0;
            if_id_instr     <= 32'h00000013;
            if_id_valid     <= 1'b0;
            id_ex_pc        <= 32'b0;
            id_ex_rs1_data  <= 32'b0;
            id_ex_rs2_data  <= 32'b0;
            id_ex_imm       <= 32'b0;
            id_ex_rs1       <= 5'b0;
            id_ex_rs2       <= 5'b0;
            id_ex_rd        <= 5'b0;
            id_ex_alu_op    <= ALU_ADD;
            id_ex_alu_src   <= 1'b0;
            id_ex_mem_read  <= 1'b0;
            id_ex_mem_write <= 1'b0;
            id_ex_reg_write <= 1'b0;
            id_ex_mem_to_reg<= 1'b0;
            id_ex_branch    <= 1'b0;
            id_ex_jal       <= 1'b0;
            id_ex_jalr      <= 1'b0;
            id_ex_funct3    <= 3'b0;
            id_ex_valid     <= 1'b0;
            ex_mem_alu_result   <= 32'b0;
            ex_mem_rs2_data     <= 32'b0;
            ex_mem_pc_branch    <= 32'b0;
            ex_mem_rd           <= 5'b0;
            ex_mem_mem_read     <= 1'b0;
            ex_mem_mem_write    <= 1'b0;
            ex_mem_reg_write    <= 1'b0;
            ex_mem_mem_to_reg   <= 1'b0;
            ex_mem_branch       <= 1'b0;
            ex_mem_branch_taken <= 1'b0;
            ex_mem_jal          <= 1'b0;
            ex_mem_jalr         <= 1'b0;
            ex_mem_funct3       <= 3'b0;
            ex_mem_valid        <= 1'b0;
            mem_wb_alu_result   <= 32'b0;
            mem_wb_mem_data     <= 32'b0;
            mem_wb_rd           <= 5'b0;
            mem_wb_reg_write    <= 1'b0;
            mem_wb_mem_to_reg   <= 1'b0;
            mem_wb_valid        <= 1'b0;

        end else begin
            // PC
            pc <= pc_next;

            // IF/ID
            if (!pc_stall && fetch_ack) begin
                if_id_pc    <= pc;
                if_id_instr <= flush ? 32'h00000013 : fetched_instr;
                if_id_valid <= !flush;
            end

            // ID/EX
            if (load_use_hazard || flush) begin
                id_ex_alu_op    <= ALU_ADD;
                id_ex_alu_src   <= 1'b0;
                id_ex_mem_read  <= 1'b0;
                id_ex_mem_write <= 1'b0;
                id_ex_reg_write <= 1'b0;
                id_ex_branch    <= 1'b0;
                id_ex_jal       <= 1'b0;
                id_ex_jalr      <= 1'b0;
                id_ex_valid     <= 1'b0;
            end else if (if_id_valid) begin
                id_ex_pc        <= if_id_pc;
                id_ex_rs1_data  <= rf_rs1_data;
                id_ex_rs2_data  <= rf_rs2_data;
                id_ex_imm       <= imm_val;
                id_ex_rs1       <= if_id_instr[19:15];
                id_ex_rs2       <= if_id_instr[24:20];
                id_ex_rd        <= if_id_instr[11:7];
                id_ex_alu_op    <= ctrl_alu_op;
                id_ex_alu_src   <= ctrl_alu_src;
                id_ex_mem_read  <= ctrl_mem_read;
                id_ex_mem_write <= ctrl_mem_write;
                id_ex_reg_write <= ctrl_reg_write;
                id_ex_mem_to_reg<= ctrl_mem_to_reg;
                id_ex_branch    <= ctrl_branch;
                id_ex_jal       <= ctrl_jal;
                id_ex_jalr      <= ctrl_jalr;
                id_ex_funct3    <= if_id_instr[14:12];
                id_ex_valid     <= 1'b1;
            end

            // EX/MEM
            ex_mem_alu_result   <= (id_ex_jal || id_ex_jalr) ?
                                    (id_ex_pc + 32'd4) : alu_result;
            ex_mem_rs2_data     <= fwd_rs2;
            ex_mem_pc_branch    <= branch_target;
            ex_mem_rd           <= id_ex_rd;
            ex_mem_mem_read     <= id_ex_mem_read;
            ex_mem_mem_write    <= id_ex_mem_write;
            ex_mem_reg_write    <= id_ex_reg_write;
            ex_mem_mem_to_reg   <= id_ex_mem_to_reg;
            ex_mem_branch       <= id_ex_branch;
            ex_mem_branch_taken <= branch_taken;
            ex_mem_jal          <= id_ex_jal;
            ex_mem_jalr         <= id_ex_jalr;
            ex_mem_funct3       <= id_ex_funct3;
            ex_mem_valid        <= id_ex_valid;

            // MEM/WB
            mem_wb_alu_result <= ex_mem_alu_result;
            mem_wb_mem_data   <= mem_rdata;
            mem_wb_rd         <= ex_mem_rd;
            mem_wb_reg_write  <= ex_mem_reg_write;
            mem_wb_mem_to_reg <= ex_mem_mem_to_reg;
            mem_wb_valid      <= ex_mem_valid;
        end
    end

endmodule
