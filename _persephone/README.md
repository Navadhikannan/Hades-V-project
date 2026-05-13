# Testcase Results 

**Repository:** hades-v_11_Navadhikannan  
**Test Run:** 14.05.2026 00:05  
**Test Deadline:** 04.06.2026 00:00  
### Tested Commit Information
**Date:** 13.05.2026 22:46  
**Hash:** de113a9  
**Message:** Updated execute stage  
**Committer Email:** noreply@github.com  

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

