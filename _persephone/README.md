# Testcase Results 

**Repository:** hades-v_11_Navadhikannan  
**Test Run:** 31.05.2026 06:36  
**Test Deadline:** 02.06.2026 00:00  
### Tested Commit Information
**Date:** 31.05.2026 06:23  
**Hash:** 17dfe13  
**Message:** Fix memory stage latching  
**Committer Email:** navadhi2306k@gmail.com  

# Module Under Test:  Fetch Stage  
<details><summary>Details for the  Fetch Stage</summary>

**Points:**   8.00 /  8  


</details>


# Module Under Test:  Decode Stage  
<details><summary>Details for the  Decode Stage</summary>

**Points:**   3.48 /  4  

## OPC_FENCE  
  
Test input: FENCE with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| rs1_data_reg_out | 0x00000000 | 0x00000190 | 
| instruction_reg_out.rs1_address | 0 | 4 | 
  
Test input: FENCE with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| rs1_data_reg_out | 0x00000000 | 0x0000012c | 
| instruction_reg_out.rd_address | 0 | 1 | 
| instruction_reg_out.rs1_address | 0 | 3 | 
| instruction_reg_out.immediate | 0x00000000 | 0x00000001 | 
  
Test input: FENCE with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| rs1_data_reg_out | 0x00000000 | 0x000000c8 | 
| instruction_reg_out.rd_address | 0 | 2 | 
| instruction_reg_out.rs1_address | 0 | 2 | 
| instruction_reg_out.immediate | 0x00000000 | 0xffffffff | 
  
Test input: FENCE_I with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| rs1_data_reg_out | 0x00000000 | 0xfffff4ac | 
| instruction_reg_out.rd_address | 0 | 31 | 
| instruction_reg_out.rs1_address | 0 | 29 | 
| instruction_reg_out.immediate | 0x00000000 | 0xfffff800 | 
  
Test input: FENCE_I with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| rs1_data_reg_out | 0x00000000 | 0xfffff448 | 
| instruction_reg_out.rd_address | 0 | 30 | 
| instruction_reg_out.rs1_address | 0 | 30 | 
| instruction_reg_out.immediate | 0x00000000 | 0xfffffabc | 
  
Test input: FENCE_I with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| rs1_data_reg_out | 0x00000000 | 0xfffff3e4 | 
| instruction_reg_out.rd_address | 0 | 29 | 
| instruction_reg_out.rs1_address | 0 | 31 | 
| instruction_reg_out.immediate | 0x00000000 | 0xfffff876 | 
## OPC_SYSTEM  
### ECALL  
  
Test input: ECALL with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 9 | 
### EBREAK  
  
Test input: EBREAK with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 10 | 
## raise ILLEGAL_INSTRUCTION  
### invalid OPC  
  
Test input: ILLEGAL with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
  
Test input: ILLEGAL with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
### invalid FUNCT3 for OPC_BRANCH  
  
Test input: ILLEGAL with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
  
Test input: ILLEGAL with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
### invalid FUNCT3 for OPC_LOAD  
  
Test input: ILLEGAL with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
  
Test input: ILLEGAL with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
### invalid FUNCT3 for OPC_STORE  
  
Test input: ILLEGAL with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
  
Test input: ILLEGAL with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
### invalid FUNCT3 + FUNCT7 for IMM  
  
Test input: ILLEGAL with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
  
Test input: ILLEGAL with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
  
Test input: ILLEGAL with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
### invalid FUNCT3 + FUNCT7 for ALU  
  
Test input: ILLEGAL with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
  
Test input: ILLEGAL with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
  
Test input: ILLEGAL with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
  
Test input: ILLEGAL with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
### invalid CSR-address  
  
Test input: CSRRW with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
  
Test input: CSRRS with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
  
Test input: CSRRC with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
  
Test input: CSRRW with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
### invalid CSR access  
  
Test input: CSRRS with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
  
Test input: CSRRCI with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
### trigger error after STALL  
  
Test input: ILLEGAL with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
### trigger error after JUMP  
  
Test input: ILLEGAL with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
## STALL error  
### trigger new error  
  
Test input: ILLEGAL with status_backwards_in = READY and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
### STALL error  
  
Test input: SLTU with status_backwards_in = STALL and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
### STALL error => ignore "new error"  
  
Test input: ILLEGAL with status_backwards_in = STALL and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
### STALL error (old one)  
  
Test input: SRAI with status_backwards_in = STALL and status_forwards_in = VALID  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_forwards_out | 0 | 4 | 
</details>


# Module Under Test:  Register File  
<details><summary>Details for the  Register File</summary>

**Points:**   4.00 /  4  


</details>


# Module Under Test:  Instruction Decoder  
<details><summary>Details for the  Instruction Decoder</summary>

**Points:**   3.73 /  4  

## OPC_FENCE  
  
Test input: FENCE  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| instruction_out.immediate | 0x00000000 | 0x00000001 | 
  
Test input: FENCE  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| instruction_out.immediate | 0x00000000 | 0xffffffff | 
  
Test input: FENCE_I  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| instruction_out.immediate | 0x00000000 | 0xfffff800 | 
  
Test input: FENCE_I  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| instruction_out.immediate | 0x00000000 | 0xfffffabc | 
  
Test input: FENCE_I  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| instruction_out.immediate | 0x00000000 | 0xfffff876 | 
## raise ILLEGAL_INSTRUCTION  
### invalid CSR-address  
  
Test input: CSRRW  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| instruction_out.op | 41 | 49 | 
  
Test input: CSRRS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| instruction_out.op | 42 | 49 | 
  
Test input: CSRRC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| instruction_out.op | 43 | 49 | 
  
Test input: CSRRW  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| instruction_out.op | 41 | 49 | 
### invalid CSR access  
  
Test input: CSRRS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| instruction_out.op | 42 | 49 | 
  
Test input: CSRRCI  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| instruction_out.op | 46 | 49 | 
</details>


# Module Under Test:  Execute Stage  
<details><summary>Details for the  Execute Stage</summary>

**Points:**   4.65 / 10  


</details>


# Module Under Test:  Memory Stage  
<details><summary>Details for the  Memory Stage</summary>

**Points:**   3.07 / 10  


</details>


# Module Under Test:  Writeback Stage  
<details><summary>Details for the  Writeback Stage</summary>

**Points:**   9.71 / 16  

## CSR-operations  
### MSTATUS - do only consider MPIE and MIE  
  
Test input: CSRRWI with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00000080 | 
  
Test input: CSRRSI with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00000008 | 
  
Test input: CSRRCI with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000088 | 0x00000008 | 
  
Test input: CSRRS with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000088 | 0x00000080 | 
### MTVEC - set LSBs = 0  
  
Test input: CSRRWI with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MTVEC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0xdabbad00 | 
  
Test input: CSRRSI with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MTVEC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0xaaaabbb8 | 0x00000008 | 
  
Test input: CSRRCI with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MTVEC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0xeeeefffc | 0x0000001c | 
  
Test input: CSRRS with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MTVEC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x77778888 | 0xccaaaacc | 
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MTVEC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0xffffbbb8 | 0xceaabacc | 
### MIE - do only consider MEIE and MTIE  
  
Test input: CSRRS with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MIE  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000880 | 0x00000800 | 
### MSCRATCH  
  
Test input: CSRRWI with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSCRATCH  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0xbaadf00d | 
  
Test input: CSRRSI with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSCRATCH  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0xaaaabbbb | 0x00000008 | 
  
Test input: CSRRCI with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSCRATCH  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0xeeeeffff | 0x0000001f | 
  
Test input: CSRRW with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSCRATCH  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0xeeeedddd | 0x00000003 | 
  
Test input: CSRRS with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSCRATCH  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x77778888 | 0xccaaaacc | 
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSCRATCH  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0xffffbbbb | 0xceaabacd | 
### MEPC - set LSBs = 0!  
  
Test input: CSRRWI with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MEPC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0xfaceb00c | 
  
Test input: CSRRSI with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MEPC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x11112220 | 0x00000008 | 
  
Test input: CSRRCI with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MEPC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x7777aaa8 | 0x0000001c | 
  
Test input: CSRRS with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MEPC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0xeeeefffc | 0xccaaaacc | 
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MEPC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0xfffffffc | 0xceaabacc | 
### MCAUSE  
  
Test input: CSRRSI with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MCAUSE  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0xaaaabbbb | 0x00000008 | 
  
Test input: CSRRCI with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MCAUSE  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0xeeeeffff | 0x0000001f | 
  
Test input: CSRRW with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MCAUSE  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0xeeeedddd | 0x00000003 | 
  
Test input: CSRRS with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MCAUSE  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x77778888 | 0xccaaaacc | 
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MCAUSE  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0xffffbbbb | 0xceaabacd | 
### Check result of modified CSR-registers  
  
Test input: CSRRW with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00000080 | 
  
Test input: CSRRW with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MTVEC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x11110000 | 0x4ea8b84c | 
  
Test input: CSRRW with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSCRATCH  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x11110000 | 0x4ea8b84d | 
  
Test input: CSRRW with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MEPC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x88887774 | 0x4ea8b84c | 
  
Test input: CSRRW with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MCAUSE  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x11110000 | 0x4ea8b84d | 
## CSR-operation with rd=x0/src=0/imm=0  
### source register = x0  
  
Test input: CSRRS with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00000080 | 
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00000080 | 
  
Test input: CSRRS with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MTVEC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0xdabbad00 | 
  
Test input: CSRRW with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MTVEC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0xaaaabbb8 | 0xdabbad00 | 
### immediate = 0  
  
Test input: CSRRSI with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSCRATCH  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0xbaadf00d | 
  
Test input: CSRRCI with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSCRATCH  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x11112222 | 0xbaadf00d | 
  
Test input: CSRRSI with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MEPC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0xfaceb00c | 
  
Test input: CSRRWI with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MEPC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0xaaaabbb8 | 0xfaceb00c | 
### source register != x0, but source data = 0  
  
Test input: CSRRS with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSCRATCH  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00002222 | 0xbaadf00d | 
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSCRATCH  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x11112222 | 0xbaadf00d | 
  
Test input: CSRRS with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MEPC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0xeeeefffc | 0xfaceb00c | 
  
Test input: CSRRW with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MEPC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0xeeeefffc | 0xfaceb00c | 
### Check result of modified CSR-registers  
  
Test input: CSRRS with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00000080 | 
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSCRATCH  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00002222 | 0xbaadf00d | 
## raise Exception (Interrupts enabled)  
### status_forwards_in = ECALL  
  
Test input: ECALL with status_forwards_in = ECALL and external/timer interrupt = 0/0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| jump_address_backwards_out | 0x00000000 | 0xdabbad00 | 
### check CSRs  
  
Test input: CSRRW with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00000080 | 
### status_forwards_in = EBREAK  
  
Test input: EBREAK with status_forwards_in = EBREAK and external/timer interrupt = 0/0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| jump_address_backwards_out | 0x00000000 | 0xdabbad00 | 
### check CSRs  
  
Test input: CSRRW with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00000080 | 
### check CSRs  
  
Test input: CSRRS with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MEPC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0xaaaebbb8 | 0x00040020 | 
  
Test input: CSRRS with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MCAUSE  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0xeeeeffff | 0x00000003 | 
  
Test input: CSRRW with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00000088 | 
### status_forwards_in = FETCH_FAULT  
  
Test input: CSRRW with status_forwards_in = FETCH_FAULT and external/timer interrupt = 0/0, csr = MCAUSE  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| jump_address_backwards_out | 0x00000000 | 0xdabbad00 | 
### check CSRs  
  
Test input: CSRRW with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00000080 | 
### status_forwards_in = LOAD_FAULT  
  
Test input: LB with status_forwards_in = LOAD_FAULT and external/timer interrupt = 0/0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| jump_address_backwards_out | 0x00000000 | 0xdabbad00 | 
### check CSRs  
  
Test input: CSRRW with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00000080 | 
### status_forwards_in = STORE_MISALIGNED  
  
Test input: SH with status_forwards_in = STORE_MISALIGNED and external/timer interrupt = 0/0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| jump_address_backwards_out | 0x00000000 | 0xdabbad00 | 
### check CSRs  
  
Test input: CSRRW with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00000080 | 
## raise Exception (Interrupts disabled)  
### status_forwards_in = ECALL  
  
Test input: ECALL with status_forwards_in = ECALL and external/timer interrupt = 0/0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| jump_address_backwards_out | 0x00000000 | 0xdabbad00 | 
### status_forwards_in = EBREAK  
  
Test input: EBREAK with status_forwards_in = EBREAK and external/timer interrupt = 0/0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| jump_address_backwards_out | 0x00000000 | 0xdabbad00 | 
### status_forwards_in = FETCH_MISALIGNED  
  
Test input: BEQ with status_forwards_in = FETCH_MISALIGNED and external/timer interrupt = 0/0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| jump_address_backwards_out | 0x00000000 | 0xdabbad00 | 
### status_forwards_in = ILLEGAL_INSTRUCTION  
  
Test input: XORI with status_forwards_in = ILLEGAL_INSTRUCTION and external/timer interrupt = 0/0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| jump_address_backwards_out | 0x00000000 | 0xdabbad00 | 
### status_forwards_in = LOAD_MISALIGNED  
  
Test input: LHU with status_forwards_in = LOAD_MISALIGNED and external/timer interrupt = 0/0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| jump_address_backwards_out | 0x00000000 | 0xdabbad00 | 
### status_forwards_in = STORE_FAULT  
  
Test input: SB with status_forwards_in = STORE_FAULT and external/timer interrupt = 0/0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| jump_address_backwards_out | 0x00000000 | 0xdabbad00 | 
## trigger Interrupt (already enabled)  
### now interrupt should be triggered  
  
Test input: ADDI with status_forwards_in = VALID and external/timer interrupt = 1/0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_backwards_out | 0 | 2 | 
| jump_address_backwards_out | 0x00000000 | 0xdabbad00 | 
### check CSRs  
  
Test input: CSRRW with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MEPC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00040014 | 
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MCAUSE  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x8000000b | 
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00000080 | 
### disable interrupts  
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00000080 | 
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MIE  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000880 | 0x00000800 | 
### check CSRs  
  
Test input: CSRRW with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MEPC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00040034 | 0xfaceb00c | 
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000080 | 0x00000088 | 
### disable interrupts  
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000080 | 0x00000088 | 
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MIE  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000880 | 0x00000080 | 
### now interrupt should be triggered  
  
Test input: ADDI with status_forwards_in = VALID and external/timer interrupt = 1/1  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_backwards_out | 0 | 2 | 
| jump_address_backwards_out | 0x00000000 | 0xdabbad00 | 
### check CSRs  
  
Test input: CSRRW with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MEPC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0xaaaabbb8 | 0x00040064 | 
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MCAUSE  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x8000000b | 
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00000080 | 
### disable interrupts  
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00000080 | 
## trigger Interrupt immediatly (enable when already pending)  
### MSTATUS[MIE] = 1  
  
Test input: CSRRS with status_forwards_in = VALID and external/timer interrupt = 1/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00000080 | 
| status_backwards_out | 0 | 2 | 
| jump_address_backwards_out | 0x00000000 | 0xdabbad00 | 
### check CSRs  
  
Test input: CSRRW with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MEPC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00040014 | 
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MCAUSE  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x8000000b | 
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00000080 | 
### disable interrupts  
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00000080 | 
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MIE  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000880 | 0x00000800 | 
### MSTATUS[MIE] = 1  
  
Test input: CSRRS with status_forwards_in = VALID and external/timer interrupt = 0/1, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00000080 | 
### MIE[MTIE] = 1  
  
Test input: CSRRS with status_forwards_in = VALID and external/timer interrupt = 0/1, csr = MIE  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_backwards_out | 0 | 2 | 
| jump_address_backwards_out | 0x00000000 | 0xdabbad00 | 
### check CSRs  
  
Test input: CSRRW with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MEPC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x77778888 | 0x00040038 | 
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MCAUSE  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x80000007 | 
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00000080 | 
### disable interrupts  
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00000080 | 
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MIE  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000880 | 0x00000080 | 
## simple MRET  
### check MSTATUS (MPIE == 1 && MIE == 0)  
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00000080 | 
### MRET  
  
Test input: MRET with status_forwards_in = VALID and external/timer interrupt = 0/0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| jump_address_backwards_out | 0x00000000 | 0xfaceb00c | 
### check MSTATUS (MPIE == 1 && MIE == 1)  
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000080 | 0x00000088 | 
## MRET after Exception with MSTATUS[MIE] = 0  
### disable interrupts  
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00000088 | 
### raise Exception  
  
Test input: XOR with status_forwards_in = FETCH_FAULT and external/timer interrupt = 0/0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| jump_address_backwards_out | 0x00000000 | 0xdabbad00 | 
## MRET after Interrupt with MSTATUS[MIE] = 1  
### now interrupt should be triggered  
  
Test input: ADDI with status_forwards_in = VALID and external/timer interrupt = 1/0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_backwards_out | 0 | 2 | 
| jump_address_backwards_out | 0x00000000 | 0xdabbad00 | 
### check MSTATUS (MPIE == 1 && MIE == 0)  
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 1/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000088 | 0x00000080 | 
### MRET  
  
Test input: MRET with status_forwards_in = VALID and external/timer interrupt = 0/0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| jump_address_backwards_out | 0x00040018 | 0x00040038 | 
## MRET while Interrupt pending  
### now interrupt should be triggered  
  
Test input: ADDI with status_forwards_in = VALID and external/timer interrupt = 1/0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| status_backwards_out | 0 | 2 | 
| jump_address_backwards_out | 0x00000000 | 0xdabbad00 | 
### MRET -> directly trigger Interrupt again  
  
Test input: MRET with status_forwards_in = VALID and external/timer interrupt = 1/0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| jump_address_backwards_out | 0x00040054 | 0xdabbad00 | 
### check MEPC (no change)  
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 1/0, csr = MEPC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00040054 | 0x0004005c | 
### MRET -> jump to old MEPC  
  
Test input: MRET with status_forwards_in = VALID and external/timer interrupt = 0/0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| jump_address_backwards_out | 0x00000054 | 0x0004005c | 
## status_forwards_in != VALID  
### FENCE_I with status_forwards_in != VALID  
  
Test input: FENCE_I with status_forwards_in = FETCH_FAULT and external/timer interrupt = 0/0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| jump_address_backwards_out | 0x00000000 | 0xdabbad00 | 
### MRET with status_forwards_in != VALID  
  
Test input: MRET with status_forwards_in = FETCH_FAULT and external/timer interrupt = 0/0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| jump_address_backwards_out | 0x00000000 | 0xdabbad00 | 
### CSR-operations with status_forwards_in != VALID  
  
Test input: CSRRS with status_forwards_in = FETCH_FAULT and external/timer interrupt = 0/0, csr = MIE  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| jump_address_backwards_out | 0x00000000 | 0xdabbad00 | 
  
Test input: CSRRWI with status_forwards_in = FETCH_FAULT and external/timer interrupt = 0/0, csr = MTVAL  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| jump_address_backwards_out | 0x00000000 | 0xdabbad00 | 
  
Test input: CSRRCI with status_forwards_in = FETCH_FAULT and external/timer interrupt = 0/0, csr = MHPMCOUNTER9H  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| jump_address_backwards_out | 0x00000000 | 0xdabbad00 | 
### check CSRs  
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MTVEC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0xdabbad00 | 
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSCRATCH  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0xbaadf00d | 
## special Interrupt cases  
### FENCE_I when Interrupt triggered  
  
Test input: FENCE_I with status_forwards_in = VALID and external/timer interrupt = 1/0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| jump_address_backwards_out | 0x00040014 | 0xdabbad00 | 
### disable interrupts  
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00000080 | 
### status_forwards_in = Exception => Exception higher priority than Interrupt  
  
Test input: SLTIU with status_forwards_in = FETCH_FAULT and external/timer interrupt = 1/0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| jump_address_backwards_out | 0x00000000 | 0xdabbad00 | 
### check CSRs  
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 1/0, csr = MSTATUS  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00000080 | 
### MRET from Exception while Interrupt pending  
  
Test input: MRET with status_forwards_in = VALID and external/timer interrupt = 1/0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| jump_address_backwards_out | 0x00000000 | 0xdabbad00 | 
### check CSRs  
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 1/0, csr = MEPC  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0x00040018 | 
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 1/0, csr = MCAUSE  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000001 | 0x8000000b | 
## check MCYCLE and MINSTRET  
### status_forwards_in = Exception  
  
Test input: ADDI with status_forwards_in = FETCH_FAULT and external/timer interrupt = 0/0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| jump_address_backwards_out | 0x00000000 | 0xdabbad00 | 
### check MCYCLE  
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MCYCLE  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0xeeef0006 | 0x76543216 | 
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MCYCLEH  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x11112222 | 0xfedcba98 | 
### check MINSTRET  
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MINSTRET  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x0000000d | 0x76543213 | 
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MINSTRETH  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0xfedcba98 | 
## check MCYCLE: increment first, then write  
### write to MCYCLE  
  
Test input: CSRRW with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MCYCLE  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0xaaaabbbd | 0xffffffff | 
### check MCYCLE  
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MCYCLE  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x11112223 | 0xbaaaaaad | 
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MCYCLEH  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0xeeeeffff | 0xbadc0dee | 
## check MINSTRET  
### write to MINSTRET  
  
Test input: CSRRW with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MINSTRET  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000016 | 0xffffffff | 
### check MINSTRET  
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MINSTRET  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000017 | 0xbaaaaaad | 
  
Test input: CSRRC with status_forwards_in = VALID and external/timer interrupt = 0/0, csr = MINSTRETH  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| forwarding_out.data | 0x00000000 | 0xbadc0dee | 
</details>

