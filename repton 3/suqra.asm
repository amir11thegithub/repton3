; square

.transporter_square_pattern
 LDA #&06
 JSR make_sound
 LDA #&0F
 STA pages
 LDA #&01
 STA pages + &01
.capit
 LDA pages
 STA tempx
 STA tempy
 LDA #19
 JSR osbyte
 LDX #&03
 STX pages + &02
.square
 JSR transporter_square_edge
 DEC pages + &02
 BPL square
 LDA pages
 STA tempx
 STA tempy
 LDA #&01                               ;place four corner pieces on
 JSR transporter_square
 LDA pages
 CLC
 ADC pages + &01
 STA tempx
 LDA #&03
 JSR transporter_square
 INC pages + &01
 INC pages + &01
 LDA tempx
 STA tempy
 LDA #&07
 JSR transporter_square
 LDA pages
 STA tempx
 LDA #&06
 JSR transporter_square
 DEC pages
 BPL capit
 RTS

.transporter_square_edge                ;render a transporter side
 LDX pages + &01
.lines
 PHX
 LDY pages + &02
 LDA strip,Y
 STA tempa
 JSR transporter_square
 LDX pages + &02
 LDA tempx
 CLC
 ADC xdire,X
 STA tempx
 LDA tempy
 CLC
 ADC ydire,X
 STA tempy
 PLX
 DEX
 BNE lines
 RTS

.xdire
 EQUB 0
 EQUB -1
 EQUB 0
 EQUB 1

.ydire
 EQUB -1
 EQUB 0
 EQUB 1
 EQUB 0

.strip
 EQUB &04
 EQUB &08
 EQUB &05
 EQUB &02

.square_block
 EQUD &F7F7F0F0
 EQUD &C6C6C7C7
 EQUD &FFFFF0F0
 EQUD &00000F0F
 EQUD &FEFEF0F0
 EQUD &36363E3E
 EQUD &C6C6C6C6
 EQUD &C6C6C6C6
 EQUD &36363636
 EQUD &36363636
 EQUD &C7C7C6C6
 EQUD &F0F0F7F7
 EQUD &3E3E3636
 EQUD &F0F0FEFE
 EQUD &0F0F0000
 EQUD &F0F0FFFF

.transporter_square                     ;put one of eight diffrent graphics on screen
 ASL A                                  ;left/right/top/bottom/corners
 ASL A
 ASL A
 PHA
 LDA tempx
 ASL A
 ASL A
 ASL A
 CLC
 ADC start
 STA indir
 LDA tempy
 ADC start + &01
 BPL square_posit
 SEC
 SBC #&20
.square_posit
 STA indir + &01
 LDY #&07
 PLX
.seven
 LDA square_block - &01,X
 STA (indir),Y
 DEX
 DEY
 BPL seven
 RTS
