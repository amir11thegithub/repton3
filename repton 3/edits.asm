; edits

.cyphr
 EQUW &211
 EQUW &81F
 EQUB 7
 EQUS "ENTER  PASSWORD"
 EQUW &111
 EQUW &141F
 EQUB 12
 EQUS "!"
 EQUW &A1F
 EQUB 12
 EQUS "! "
 EQUW &311
.fails
 EQUW &211
 EQUW &41F
 EQUB 16
 EQUS "Password not recognised"
.catch
 EQUW &111
 EQUW &B1F
 EQUB 16
 EQUS "Screen "
 EQUW &211
.latch
 EQUS " "

.repton_password
 LDA #124
 JSR osbyte
 JSR all_colours_to_black
 JSR setup_custom_mode
 LDX #LO(cyphr)
 LDY #HI(cyphr)
 LDA #fails - cyphr
 JSR write_characters
 JSR set_physical_colours
 LDA #21                                ;clear keyboard buffer
 LDX #&00
 JSR osbyte
 LDX #LO(input)                         ;input text
 LDY #HI(input)
 LDA #&00
 JSR osword
 LDA #&07
 STA tempa
.huite
 LDX #&00
 LDA tempa
 ASL A
 ASL A
 ASL A
 TAY
 LDA pages
 CMP #&0D
 BEQ norec
.quiet
 LDA map_passwords,Y
 CMP #&0D
 BEQ strin
 EOR pages,X
 BNE norec
 INY
 INX
 CPX #&08
 BCC quiet
.norec
 DEC tempa
 BPL huite
 LDX #LO(fails)
 LDY #HI(fails)
 LDA #catch - fails
 JSR write_characters
 LDX #99
 JSR wait_state
 CLC
 RTS

.strin
 LDA pages,X
 CMP #&0D
 BNE norec
 LDA tempa
 STA grids
 CLC
 ADC #65
 STA latch
 LDX #LO(catch)
 LDY #HI(catch)
 LDA #repton_password - catch
 JSR write_characters
 SEC
 RTS

.wait_state                             ;x = delay .02 seconds
 PHX
 LDA #19
 JSR osbyte
 PLX
 DEX
 BNE wait_state
 RTS

.times28_lsb
 EQUB LO(&900)
 EQUB LO(&91C)
 EQUB LO(&938)
 EQUB LO(&954)
 EQUB LO(&970)
 EQUB LO(&98C)
 EQUB LO(&9A8)
 EQUB LO(&9C4)
 EQUB LO(&9E0)
 EQUB LO(&9FC)
 EQUB LO(&A18)
 EQUB LO(&A34)
 EQUB LO(&A50)
 EQUB LO(&A6C)
 EQUB LO(&A88)
 EQUB LO(&AA4)
 EQUB LO(&AC0)
 EQUB LO(&ADC) 
 EQUB LO(&AF8)
 EQUB LO(&B14)
 EQUB LO(&B30)
 EQUB LO(&B4C)
 EQUB LO(&B68)
 EQUB LO(&B84)

.times28_msb
 EQUB HI(&900)
 EQUB HI(&91C)
 EQUB HI(&938)
 EQUB HI(&954)
 EQUB HI(&970)
 EQUB HI(&98C)
 EQUB HI(&9A8)
 EQUB HI(&9C4)
 EQUB HI(&9E0)
 EQUB HI(&9FC)
 EQUB HI(&A18)
 EQUB HI(&A34)
 EQUB HI(&A50)
 EQUB HI(&A6C)
 EQUB HI(&A88)
 EQUB HI(&AA4)
 EQUB HI(&AC0)
 EQUB HI(&ADC) 
 EQUB HI(&AF8)
 EQUB HI(&B14)
 EQUB HI(&B30)
 EQUB HI(&B4C)
 EQUB HI(&B68)
 EQUB HI(&B84)

.input
 EQUW pages
 EQUB 7
 EQUB 32
 EQUB 122

.get_map_byte                           ;get map byte, a,x
 CMP #24                                ;exit if out of range
 BCS bites
 CPX #28
 BCS bites
 TAY
 LDA times28_lsb,Y
 STA tempa
 LDA times28_msb,Y
 STA tempx
 TXA
 TAY
 LDA (tempa),Y                          ;get map character
 RTS
.bites
 LDA #code_wall                         ;return with wall character
 RTS

.write_map_byte                         ;write map byte a,x,y
 CPY #24                                ;exit if out of range
 BCS tight
 CPX #28
 BCS tight
 PHX
 LDX times28_lsb,Y
 STX tempa
 LDX times28_msb,Y
 STX tempx
 PLY                                    ;x >> y
 STA (tempa),Y
.tight
 RTS
