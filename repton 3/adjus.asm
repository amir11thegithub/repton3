; adjus

.spirit_y_adjust
 EQUD &000100FF

.spirit_x_adjust
 EQUD &FF000100

.paths
 EQUD &02010300

.adjust_spirits
 LDX aloof
 LDA spirx,X 
 STA xxadj
 LDA spiry,X 
 STA yyadj
 LDY #&03
.reptn_looks
 STY accum
 LDA xxadj
 CLC
 ADC spirit_x_adjust,Y                  ;calculate x coordinate
 TAX
 LDA yyadj
 CLC
 ADC spirit_y_adjust,Y                  ;calculate y coordinate
 JSR get_map_byte
 LDY accum
 CMP #31
 BEQ freds
 CMP #code_space 
 BEQ freds
 CMP #&02 
 BEQ freds
 CMP #&03 
 BEQ freds
 LDX aloof
 LDA paths,Y
 STA spird,X
.freds
 DEY
 BPL reptn_looks
 RTS
