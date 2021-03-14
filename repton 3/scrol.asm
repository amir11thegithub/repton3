; scrol

.check_screen_address
 LDA start + &01
 BMI subtr
 CMP #&60
 BCS chack
 LDA #&7F
 STA start + &01
 RTS
.subtr
 LDA #&60
 STA start + &01
 RTS

.scroll_bytes_lsb
 EQUB LO(&08)
 EQUB LO(-&08)
 EQUB LO(-&100)
 EQUB LO(&100)

.scroll_bytes_msb
 EQUB HI(&08)
 EQUB HI(-&08)
 EQUB HI(-&100)
 EQUB HI(&100)

.scroll_screen
 LDX sting
 LDA start
 CLC
 ADC scroll_bytes_lsb,X
 STA start
 LDA start + &01
 ADC scroll_bytes_msb,X
 STA start + &01
 JSR check_screen_address
 LDA #19
 JSR osbyte
 SEI
 LDX #&0C
 STX sheila
 LDA start + &01
 STA tempa
 LSR A
 LSR A
 LSR A
 STA sheila + &01
 INX
 STX sheila
 LDA start
 LSR tempa
 ROR A
 LSR tempa
 ROR A
 LSR tempa
 ROR A
 STA sheila + &01
.chack
 RTS

.setup_interrupt_and_event
 SEI
 LDA #LO(event)
 STA eventv
 LDA #HI(event)
 STA eventv + &01
 LDA #LO(repton_music)
 STA irq2v
 LDA #HI(repton_music)
 STA irq2v + &01
 CLI
 LDA #14                                ;enable event
 LDX #&04
 JMP osbyte

.apple
 EQUB &03
.timer
 EQUB &07

.event
 PHP
 PHA
 PHX
 PHY

 LDA #&0E                               ;set up one shot interrupt
 STA sheila + &66
 LDA #&27
 STA sheila + &67
 STA sheila + &65
 LDA #&C0
 STA sheila + &6E
 
 CLC
 LDY #&29
 LDX #&FC
.scrol_loops
 TYA
 LDY rand_plus,X
 ADC rand_plus,X
 STA rand_plus,X
 INX
 BNE scrol_loops
 DEC apple
 BNE exits
 LDA #&03
 STA apple
 LDA death
 BNE exits
 LDA watch                              ;decrement timer
 BNE decrement_lsb
 DEC watch + &01
.decrement_lsb
 DEC watch
 LDA watch
 ORA watch + &01
 BNE exits                              ;timer still active
 INC death
.exits
 PLY
 PLX
 PLA
 PLP
 RTS

.repton_music
 LDA interrupt_accumulator              ;save all registers
 PHA
 PHX
 PHY
 LDA sheila + &64                       ;clear interrupt condition
 DEC timer
 BNE scrol_quiet
 LDA #&07
 STA timer
 ;JSR play_repton_music
.scrol_quiet
 PLY
 PLX
 PLA
 STA interrupt_accumulator
 RTI

.datac
 EQUW map_buffer
 EQUW -672

.get_number_of_characters
 LDX #&04
.scrol_getit
 LDA datac - &01,X
 STA tempa - &01,X
 DEX
 BNE scrol_getit
 TXA
 LDY #32
.alzer
 STA field - &01,Y
 STA fielh - &01,Y
 DEY
 BNE alzer
.trace
 LDA (tempa),Y
 CMP #32
 BCS notin
 TAX
 INC field,X
 BNE notin
 INC fielh,X
.notin
 INY
 BNE posit
 INC tempx
.posit
 INC tempy
 BNE trace
 INC tempz
 BNE trace
 RTS

.loads
 EQUW diary
 EQUD &31E0
 EQUD 0
 EQUD 0
 EQUD 0
.block
 EQUW diary
 EQUB 12
 EQUB 32
 EQUB 126
.futhr
 EQUD &00
 EQUD &00
.files
 EQUW &211
 EQUW &81F
 EQUB 7
 EQUS "ENTER  FILENAME"
 EQUW &111
 EQUW &171F
 EQUB 12
 EQUS "!"
 EQUW &71F
 EQUB 12
 EQUS "! "
 EQUW &311

.load_repton_map
 JSR all_colours_to_black
 JSR setup_custom_mode
 LDA #124
 JSR osbyte
 LDX #LO(files)
 LDY #HI(files)
 LDA #load_repton_map - files
 JSR write_characters
 JSR set_physical_colours
 LDA #21                                ;clear keyboard buffer
 LDX #&00
 JSR osbyte
 LDX #LO(block)
 LDY #HI(block)
 LDA #&00
 JSR osword
 JSR alternate
 LDX #LO(loads)
 LDY #HI(loads)
 LDA #&FF
 JSR osfile
 JMP rotate_all_screen_bytes

.alternate
 LDA diary
 CMP #&0D
 BEQ made_a_mistake
 LDA diary
 CMP #32
 BNE cards
 LDX #&00
.shove
 LDA diary + &01,X
 STA diary,X
 INX
 CPX #12
 BCC shove
 BCS alternate
.cards
 LDA diary
 CMP #ascii_colon
 BNE nodri
 LDA diary + &02
 CMP #ascii_full_stop
 BNE made_a_mistake
 LDA diary + &01
 JSR select_drive
 LDX #&00
.shufl
 LDA diary + &03,X
 STA diary,X
 INX
 CPX #12
 BCC shufl
.nodri
 RTS

.drive
 EQUS "DRIVE *", &0D

.select_drive
 STA drive + &06
 LDX #LO(drive)
 LDY #HI(drive)
 JMP oscli

.mistake
 EQUB &00
 EQUB &07
 EQUS "Syntax error"
 EQUB &00

.made_a_mistake
 LDX #made_a_mistake - mistake
.pushs
 LDA mistake,X
 STA stack,X
 DEX
 BPL pushs
 BRK
