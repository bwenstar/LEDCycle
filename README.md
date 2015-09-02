## LEDCycle
Tiva TM4C123GXL - GPIO LED Cycle program

------------------------------------------------------------------

**Microprocessor**: TIVA TM4C123GXL
**GIPO**: Port D
**Pins**: 3-0
8mA Source

------------------------------------------------------------------
**Function**: 
Output a value from Register 3 (R3) to GPIO Port D Pins 3-0.
Value is incremented from 0x0 to 0xF (2_0000 to 2_1111).

**Info**:
Basic assembly code written for Keil (IDE-Version: µVision V5.15).
Initialises GPIO Port D.  

------------------------------------------------------------------
**Notes**:

Increments 0x0 to 0xF with a delay of one second between each 
iteration. Link register is saved into the stack.

-------------------------------------------------------------------     
