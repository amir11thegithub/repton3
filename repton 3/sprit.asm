; sprit

.place_a_sprite
 JSR calculate_sprite
.other
 TXA
 AND #&03
 TAY
 LDA masks,Y 
 AND paras + &03 
 BEQ sprit_finit
 TXA 
 LSR A 
 LSR A 
 TAY 
 LDA masks,Y 
 AND paras + &04
 BEQ sprit_finit
 LDY #&07
.sprit_sectn
 LDA (paras + &05),Y
 STA (paras + &07),Y
 DEY
 LDA (paras + &05),Y
 STA (paras + &07),Y
 DEY
 LDA (paras + &05),Y
 STA (paras + &07),Y
 DEY
 LDA (paras + &05),Y
 STA (paras + &07),Y
 DEY 
 BPL sprit_sectn
.sprit_finit
 LDA paras + &05
 CLC
 ADC #&08
 STA paras + &05
 TXA 
 AND #&03 
 ASL A 
 TAY 
 LDA paras + &07
 CLC 
 ADC addit,Y 
 STA paras + &07
 LDA paras + &08 
 ADC addit + &01,Y
 BPL nexts 
 SEC 
 SBC #&20
.nexts
 STA paras + &08
 INX 
 CPX #16 
 BCC other 
 RTS

.addit
 EQUW &08
 EQUW &08
 EQUW &08
 EQUW 232
.masks
 EQUD &1020408

.eor_a_sprite
 JSR calculate_sprite
.tuthr
 TXA
 AND #&03
 TAY
 LDA masks,Y
 AND paras + &03
 BEQ finis
 TXA
 LSR A
 LSR A
 TAY
 LDA masks,Y
 AND paras + &04
 BEQ finis
 LDY #&07
.paper
 LDA (paras + &05),Y
 EOR (paras + &07),Y
 STA (paras + &07),Y
 DEY
 LDA (paras + &05),Y
 EOR (paras + &07),Y
 STA (paras + &07),Y
 DEY
 BPL paper
.finis
 LDA paras + &05
 CLC
 ADC #&08
 STA paras + &05
 TXA
 AND #&03
 ASL A
 TAY
 LDA paras + &07
 CLC
 ADC addit,Y
 STA paras + &07
 LDA paras + &08
 ADC addit + &01,Y
 BPL vests
 SEC
 SBC #&20
.vests
 STA paras + &08
 INX
 CPX #&10
 BCC tuthr
 RTS

.calculate_sprite
 LDA start
 SEC
 SBC #LO(map_sprite_offset)
 STA indir
 LDA start + &01
 SBC #HI(map_sprite_offset)
 STA indir + &01
 LDA paras
 LSR A
 TAX
 ROR A
 AND #&80
 CLC
 ADC #LO(map_sprites)
 STA paras + &05
 TXA
 ADC #HI(map_sprites)
 STA paras + &06
 LDA paras + &01
 ASL A
 ASL A
 ASL A
 ROL paras + &08
 CLC
 ADC indir
 STA paras + &07
 LDA paras + &08
 AND #&01
 ADC indir + &01
 STA paras + &08
 LDA paras + &02
 CLC
 ADC paras + &08
 BPL thats
 SEC
 SBC #&20
.thats
 STA paras + &08
 LDX #&00
 RTS
