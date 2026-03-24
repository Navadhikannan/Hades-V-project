# Testcase Results 

**Repository:** hades-v_11_Navadhikannan  
**Test Run:** 24.03.2026 00:00  
**Test Deadline:** 03.06.2026 00:00  
### Tested Commit Information
**Date:** 22.03.2026 17:47  
**Hash:** 0435daf  
**Message:** Exercise 2: Implement Fetch Stage  
**Committer Email:** navadhi2306k@gmail.com  

# Module Under Test:  Fetch Stage  
<details><summary>Details for the  Fetch Stage</summary>

**Points:**   6.54 /  8  

## delayed wishbone acknowledge  
### ack 1 cycle delayed  
  
Test input: status_backwards_in = READY, wb.ack = 1, wb.err = 0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| wb.adr | 0x00010001 | 0x00010000 | 
| program_counter_reg_out | 0x00040004 | 0x00040000 | 
### ack 2 cycles delayed  
  
Test input: status_backwards_in = READY, wb.ack = 0, wb.err = 0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| wb.adr | 0x00010002 | 0x00010001 | 
  
Test input: status_backwards_in = READY, wb.ack = 0, wb.err = 0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| wb.adr | 0x00010003 | 0x00010001 | 
  
Test input: status_backwards_in = READY, wb.ack = 1, wb.err = 0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| wb.adr | 0x00010004 | 0x00010001 | 
| program_counter_reg_out | 0x00040010 | 0x00040004 | 
### STALL + ack=0 => STALL  
  
Test input: status_backwards_in = STALL, wb.ack = 0, wb.err = 0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| wb.adr | 0x00010005 | 0x00010002 | 
| program_counter_reg_out | 0x00040010 | 0x00040004 | 
### READY + ack=0 => BUBBLE  
  
Test input: status_backwards_in = READY, wb.ack = 0, wb.err = 0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| wb.adr | 0x00010005 | 0x00010002 | 
### READY + ack=1 => VALID  
  
Test input: status_backwards_in = READY, wb.ack = 1, wb.err = 0  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| wb.adr | 0x00010006 | 0x00010002 | 
| program_counter_reg_out | 0x00040018 | 0x00040008 | 
## delayed wishbone error  
### err 1 cycle delayed  
  
Test input: status_backwards_in = READY, wb.ack = 0, wb.err = 1  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| wb.adr | 0x00010001 | 0x00010000 | 
| program_counter_reg_out | 0x00040004 | 0x00040000 | 
### STALL + err=1 => ignore error  
  
Test input: status_backwards_in = STALL, wb.ack = 0, wb.err = 1  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| wb.adr | 0x00010002 | 0x00010001 | 
### READY + err=1 => trigger error  
  
Test input: status_backwards_in = READY, wb.ack = 0, wb.err = 1  
| Signal | Is Value | Expected Value |   
| - | - | - |  
| wb.adr | 0x00010002 | 0x00010001 | 
| program_counter_reg_out | 0x00040008 | 0x00040004 | 
</details>

