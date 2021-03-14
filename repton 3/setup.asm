; setup

.perip
 EQUB &00
.setup
 EQUW &311
 EQUW &11F
 EQUB 30
 EQUS "(c) Superior Software Ltd. 1986"
 EQUW &21F
 EQUB 31
 EQUS "(c) Superior Interactive 2021"
 EQUW &111
 EQUW &A1F
 EQUB 13
 EQUS "Sound :"
 EQUW &A1F
 EQUB 15
 EQUS "Music :"
 EQUW &41F
 EQUB 17
 EQUS "View status :"
 EQUW &71F
 EQUB 19
 EQUS "Controls :"
 EQUW &C1F
 EQUB 21
 EQUS "Map :"
 EQUW &81F
 EQUB 23
 EQUS "Restart :"
 EQUW &21F
 EQUB 25
 EQUS "Press"
 EQUW &F1F
 EQUB 25
 EQUS "to LOAD DATA FILE"
 EQUW &21F
 EQUB 26
 EQUS "Press"
 EQUW &F1F
 EQUB 26
 EQUS "to ENTER PASSWORD"

.section_start
 EQUW &111
 EQUW &21F
 EQUB 27
 EQUS "Press"
 EQUW &F1F
 EQUB 27
 EQUS "to KILL YOURSELF"
 EQUW &21F
 EQUB 28
 EQUS "Press"
 EQUW &F1F
 EQUB 28
 EQUS "to PLAY GAME"
 EQUW &211
 EQUW &1B1F
 EQUB 13
 EQUS "(Q/S)"
 EQUW &1B1F
 EQUB 15
 EQUS "(W/D)"
 EQUW &121F
 EQUB 17
 EQUS "Return"
 EQUW &1B1F
 EQUB 19
 EQUS "(J/K)"
 EQUW &121F
 EQUB 21
 EQUS "M"
 EQUW &1B1F
 EQUB 21
 EQUS "(A-E)"
 EQUW &121F
 EQUB 23
 EQUS "Shift-R"
 EQUW &81F
 EQUB 25
 EQUS "L"
 EQUW &81F
 EQUB 26
 EQUS "P"
 EQUW &81F
 EQUB 27
 EQUS "ESCAPE"
 EQUW &81F
 EQUB 28
 EQUS "SPACE"
.section_end

.general_setup
 JSR write_vector_patch
 JSR setup_custom_mode
 STZ grids
 STZ tiara
 STZ score
 STZ score + &01
 LDA #&03
 STA lives
 LDA #&FF
 STA slows
 JSR all_colours_to_black
 LDX #LO(setup)
 LDY #HI(setup)
 LDA #section_start - setup
 JSR write_characters
 JSR print_repton_sign
 LDX #LO(section_start)
 LDY #HI(section_start)
 LDA #section_end - section_start
 JSR write_characters
 JSR set_physical_colours
 JSR switch_on
.loops
 JSR flip_keys
 JSR switch_update
 JSR select
 TYA
 BMI loops                              ;exit a = set up
 RTS

.datas
 EQUS "On  "
 EQUS "Off "
.types
 EQUS "KeyboardJoystick"
.swtch
 EQUW &121F
 EQUB 13
 EQUS "***"
 EQUW &121F
 EQUB 19
.shows
 EQUS "********"

.switch_update
 LDA #19
 JSR osbyte
.switch_on
 LDA #13
 STA swtch + &02
 LDA gates
 ASL A
 ASL A
 TAX
 LDY #&00
.sound
 LDA datas,X
 STA swtch + &03,Y
 INX
 INY
 CPY #&03
 BCC sound
 LDA perip
 ASL A
 ASL A
 ASL A
 TAX
 LDY #&00
.finish_it
 LDA types,X
 STA shows,Y
 INX
 INY
 CPY #&08
 BCC finish_it
 JSR switch_common
 LDA #15
 STA swtch + &02
 LDA tunes
 ASL A
 ASL A
 TAX
 LDY #&00
.music
 LDA datas,X
 STA swtch + &03,Y
 INX
 INY
 CPY #&03
 BCC music
 
.switch_common
 LDX #LO(swtch)
 LDY #HI(swtch)
 LDA #switch_update-swtch
 JMP write_characters

.all_colours_to_black                   ;blank all colours
 LDA #19
 JSR osbyte
 LDX #&03
.colour_off
 LDA #19
 JSR oswrch
 TXA
 JSR oswrch
 LDA #&00
 JSR oswrch
 JSR oswrch
 JSR oswrch
 JSR oswrch
 DEX
 BPL colour_off
 RTS

.quirk
 EQUB &EF
 EQUB &AE
.bachs
 EQUB &DE
 EQUB &CD
.chose
 EQUB &BA
 EQUB &B9

.flip_keys                              ;test keys for options
 LDY gates
 LDX quirk,Y
 JSR test_key
 BPL wobbl
 LDA gates
 EOR #&01
 STA gates
.wobbl
 LDY tunes
 LDX bachs,Y
 JSR test_key
 BPL leafs
 LDA tunes                              ;music on/off
 EOR #&01
 STA tunes
.leafs
 LDY perip
 LDX chose,Y
 JSR test_key
 BPL retun
 LDA perip                              ;keyboard/joystick
 EOR #&01
 STA perip
.retun
 RTS

.setup_select
 EQUB &A9
 EQUB &C8

.select
 LDY #&02
.ketty
 PHY
 LDX setup_select,Y
 JSR test_key
 BMI press
 PLY
 DEY
 BPL ketty
 JMP test_space_key

.press
 PLY
 RTS

.rotate_all_screen_bytes                ;fade screen
 LDY #&08
.setup_another
 PHY
 LDA #19
 JSR osbyte
 PLY
 LDX #&00
 LDA #HI(himem)
 STA rotate_left + &02
 INA
 STA rotate_right + &02
.rotate_left
 ASL himem,X
.rotate_right
 LSR himem,X
 DEX
 BNE rotate_left
 INC rotate_left + &02
 INC rotate_left + &02
 INC rotate_right + &02
 INC rotate_right + &02
 BPL rotate_left
 DEY
 BNE setup_another
 RTS

.sprite_block
 EQUW himem + &18
 EQUW &4000
 EQUB &0C
 EQUB &DF

.print_repton_sign                      ;repton title graphic
 LDX #LO(sprite_block)
 LDY #HI(sprite_block)
 JMP multiple_row_sprite
