# Testcase Results 

**Repository:** hades-v_11_Navadhikannan  
**Test Run:** 14.04.2026 00:05  
**Test Deadline:** 04.06.2026 00:00  
### Tested Commit Information
**Date:** 13.04.2026 08:28  
**Hash:** 3ca3a4a  
**Message:** Fix register file: add reset initialization  
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

