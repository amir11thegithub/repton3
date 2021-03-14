; sqeze

.write_vector_patch                     ;patch in write character routine
 LDA wrchv + &01
 CMP #HI(patch_character)               ;if already patched then ignore
 BEQ already_patched
 STA vectr + &01
 LDA wrchv
 STA vectr
 LDA #LO(patch_character)
 STA wrchv
 LDA #HI(patch_character)
 STA wrchv + &01
.already_patched
 RTS

.setup_custom_mode                      ;modify mode 5 to use 8k of memory with start address at &6000
 STZ start
 STZ indir
 LDA #HI(himem)                         ;clear screen memory
 STA start + &01
 STA indir + &01
 LDX #&00
.video

 FOR screen_page, 0, 31
   STZ himem + screen_page * &100,X
 NEXT

 DEX
 BNE video
 
 LDX #&0C
 STX sheila
 LDA #HI(himem)
 STA tempa
 LSR A
 LSR A
 LSR A
 STA sheila + &01
 LDX #13
 STX sheila
 LDA #LO(himem)
 LSR tempa
 ROR A 
 LSR tempa
 ROR A 
 LSR tempa
 ROR A 
 STA sheila + &01
 LDA #&01
 STA sheila
 LDA #32
 STA sheila + &01
 LDA #&02
 STA sheila
 LDA #45
 STA sheila + &01
 SEI
 LDX sheila + &42
 LDA #&FF
 STA sheila + &42
 LDA #&C
 STA sheila + &40
 LDA #&05
 STA sheila + &40
 STX sheila + &42
 CLI
 RTS

.write_characters                       ;write a characters to oswrch pointed at by x/y
 STX indir
 STY indir + &01
 TAX
 LDY #&00
.round
 LDA (indir),Y
 JSR oswrch
 INY
 DEX
 BNE round
 RTS

.sqeze_bytes
 EQUD &100
 EQUD &00
 EQUD &00
 EQUD &00
 EQUD &5028100
 EQUD &9010000
 EQUD &508
 EQUD &82000404

.vectr                                  ;vector store
 EQUW &00

.save_a_reg
 EQUB &00
.save_x_reg
 EQUB &00
.save_y_reg
 EQUB &00
.flaps
 EQUB &00
.sqeze_count
 EQUB &00

.sqeze_addrs EQUW himem
.sqeze_masks EQUW &00
.sqeze_store EQUW &00
.sqeze_works EQUB &00

.patch_character
 STA save_a_reg
 STX save_x_reg
 STY save_y_reg
 LDA flaps
 BNE traps
 LDA sqeze_count
 BNE not_zero
 LDA save_a_reg
 CMP #32
 BCS chars
 TAY
 LDA sqeze_bytes,Y
 AND #&0F
 STA sqeze_count
 LDA sqeze_bytes,Y
 BPL wings
 STY flaps
.wings
 LDA save_a_reg
 LDX save_x_reg
 LDY save_y_reg
 JMP (vectr)

.not_zero
 LDA save_a_reg
 DEC sqeze_count
 JMP (vectr)

.traps
 LDX sqeze_count
 LDA save_a_reg
 STA sqeze_store - &01,X
 DEC sqeze_count
 BNE wings
 LDA flaps
 CMP #31
 BNE cotin
 LDA sqeze_store + &01
 ASL A
 ASL A
 ASL A
 ROL sqeze_addrs + &01
 STA sqeze_addrs
 LDA sqeze_addrs + &01
 AND #1
 ADC sqeze_store
 ADC #&60
 STA sqeze_addrs + &01
.comms
 STZ flaps
 LDA save_a_reg
 LDX save_x_reg
 LDY save_y_reg
 JMP (vectr)

.cotin
 LDA sqeze_store
 ROL A
 ROL A
 AND #&01
 TAX
 LDA sqeze_store
 AND #&0F
 STA sqeze_masks,X
 BRA comms

.chars
 SEC
 SBC #32
 PHA
 CMP #95
 BNE nodel
 LDA sqeze_addrs
 SEC
 SBC #&08
 STA sqeze_addrs
 LDA sqeze_addrs + &01
 SBC #&00
 CMP #HI(himem)
 BCS lower
 LDA #&80
.lower
 STA sqeze_addrs + &01
 LDA #&00
.nodel
 ASL A
 ROL trubl + &01
 ASL A
 ROL trubl + &01
 ASL A
 ROL trubl + &01
 STA trubl
 CLC
 LDA trubl + &01
 AND #&07
 ADC #&12
 STA trubl + &01
 LDA sqeze_addrs
 STA teeth
 LDA sqeze_addrs + &01
 STA teeth + &01
 LDY #&07
.celit
 LDA (trubl),Y
 LSR A
 LSR A
 LSR A
 LSR A
 TAX
 PHA
 LDA table,X
 LDX sqeze_masks
 AND sqeze_small,X
 STA sqeze_works
 PLA
 EOR #&0F
 TAX
 LDA table,X
 LDX sqeze_masks + &01
 AND sqeze_small,X
 ORA sqeze_works
 STA (teeth),Y
 DEY
 BPL celit
 PLA
 CMP #95
 BEQ delet
 LDA sqeze_addrs
 CLC
 ADC #&08
 STA sqeze_addrs
 LDA sqeze_addrs + &01
 ADC #&00
 BPL sqeze_wraps
 LDA #HI(himem)
.sqeze_wraps
 STA sqeze_addrs + &01
.delet
 LDA save_a_reg
 LDX save_x_reg
 LDY save_y_reg
 RTS

.table
 EQUD &33221100
 EQUD &77665544
 EQUD &BBAA9988
 EQUD &FFEEDDCC
.sqeze_small
 EQUD &FFF00F00
