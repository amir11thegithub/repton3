; rocks

.rock_maintenance                       ;control all rocks in map
 LDX #&00
 STX pages + &04
 LDA repty
 STA pages + &01
 JSR rocks_lines
 LDY repty
 DEY
 DEY
 STY pages + &01
 JSR rocks_lines                        ;test rocks on repton's row and fall if any can fall
 LDA kicks                              ;are we moving a rock?
 BNE exit_rocks                         ;yes so exit
 LDY repty
 DEY
 STY pages + &01
 JSR rocks_lines
 DEC quart                              ;scan a quarter of the map at a time, as too
 LDA quart                              ;slow to scan all the map for rocks at once
 AND #&03
 TAX
 LDA piece,X                            ;get starting point
 STA pages + &01
 LDX #&05
 STX pages + &04
.rocks_lines
 LDA #27                                ;map x coordinate
 STA pages
.cross
 LDA pages + &01                        ;map y coordinate
 LDX pages
 JSR get_map_byte
 TAX
 BEQ drops                              ;empty
 CMP #24
 BNE bashm
.drops
 STA worka
 JSR check_hit_monsters
 LDX pages
 LDY pages + &01
 INY
 TYA
 JSR get_map_byte                       ;get map byte at this location
 TAY
 LDX reason,Y                           ;get reason/jump code
 BEQ resume                             ;do nothing
 LDA #HI(resume - &01)                  ;push resume address on stack
 PHA
 LDA #LO(resume - &01)
 PHA
 JMP (polyc - &02,X)                    ;execute reason routine

.resume
 JSR check_hit_monsters
.bashm
 DEC pages
 BPL cross
 INC pages + &01
 LDY repty
 CPY pages + &01
 BNE rocks
 INC pages + &01
.rocks
 DEC pages + &04
 BPL rocks_lines
.exit_rocks
 RTS

.piece                                  ;starting point
 EQUB &00
 EQUB &06
 EQUB &0C
 EQUB &12

.polyc                                  ;vector table of routines
 EQUW rock_falling
 EQUW rock_fall_left_and_right
 EQUW rock_fall_left
 EQUW rock_fall_right

.reason
 EQUB &02 << &01
 EQUB &02 << &01
 EQUB &00 << &01
 EQUB &00 << &01
 EQUB &02 << &01 
 EQUB &02 << &01 
 EQUB &01 << &01 
 EQUB &00 << &01
 EQUB &00 << &01 
 EQUB &00 << &01 
 EQUB &00 << &01 
 EQUB &00 << &01
 EQUB &03 << &01 
 EQUB &04 << &01 
 EQUB &00 << &01 
 EQUB &00 << &01
 EQUB &00 << &01 
 EQUB &03 << &01 
 EQUB &04 << &01 
 EQUB &00 << &01
 EQUB &00 << &01 
 EQUB &00 << &01 
 EQUB &00 << &01 
 EQUB &00 << &01
 EQUB &02 << &01 
 EQUB &02 << &01 
 EQUB &00 << &01 
 EQUB &02 << &01
 EQUB &00 << &01 
 EQUB &02 << &01 
 EQUB &00 << &01 
 EQUB &00 << &01
 EQUB &00 << &01 
 EQUB &00 << &01 
 EQUB &00 << &01 
 EQUB &00 << &01
 EQUB &00 << &01 
 EQUB &00 << &01 
 EQUB &00 << &01 
 EQUB &00 << &01
 EQUB &00 << &01 
 EQUB &00 << &01 
 EQUB &00 << &01 
 EQUB &00 << &01
 EQUB &00 << &01 
 EQUB &00 << &01 
 EQUB &00 << &01 
 EQUB &00 << &01

.rock_falling
 JSR move_rock
 LDX pages
 LDY pages + &01
 INY
 JSR stone
 LDX pages
 LDY pages + &01
 INY
 INY
 TYA
 JSR get_map_byte
 CMP #code_repton
 BEQ bonks
 RTS

.rock_fall_left_and_right
 LDA kicks
 BNE nears
 LDX pages
 DEX
 LDA pages + &01
 JSR get_map_byte
 CMP #code_space
 BNE rock_fall_right
 LDX pages
 DEX
 LDY pages + &01
 INY
 TYA
 JSR get_map_byte
 CMP #code_space
 BNE rock_fall_right
 JSR move_rock
 LDX pages
 DEX
 LDY pages + &01
 INY
 JSR stone
 LDX pages
 DEX
 LDY pages + &01
 INY
 INY
 TYA
 JSR get_map_byte                       ;get map byte to see if repton
 CMP #code_repton
 BEQ bonks                              ;it's repton so kill him
 INC pages + &01
 INC pages + &01
 RTS
.bonks
 INC death
.nears
 RTS

.rock_fall_left
 LDX pages
 DEX
 LDA pages + &01 
 JSR get_map_byte
 CMP #code_space 
 BNE nears 
 LDX pages 
 DEX
 LDY pages + &01 
 INY 
 TYA 
 JSR get_map_byte
 CMP #code_space 
 BNE nears
 JSR move_rock
 LDX pages 
 DEX
 LDY pages + &01
 INY
 JSR stone
 LDX pages
 DEX
 LDY pages + &01
 INY
 INY
 TYA
 JSR get_map_byte
 CMP #code_repton
 BEQ bonks
 INC pages + &01
 INC pages + &01
 RTS

.rock_fall_right
 LDX pages
 INX
 LDA pages + &01
 JSR get_map_byte
 CMP #6
 BNE nears
 LDX pages
 INX
 LDY pages + &01
 INY
 TYA
 JSR get_map_byte
 CMP #code_space
 BNE nears
 JSR move_rock
 LDX pages
 INX
 LDY pages + &01
 INY
 JSR stone
 LDX pages
 INX
 LDY pages + &01
 INY
 INY
 TYA
 JSR get_map_byte
 CMP #code_repton
 BEQ bonks
 INC pages + &01
 INC pages + &01
.nifes
 RTS

.stone
 STX pages + &02
 STY pages + &03
 LDA worka
 STA paras
 JSR write_map_byte
 LDA pages + &02
 STA tempa
 LDA pages + &03
 STA tempy
 LDA #&00
 STA tempx
 STA tempz
 JSR calculate_sprite_plot_mask
 BCS hatch
 JSR eor_a_sprite
 LDA #&06
 STA paras
 JSR eor_a_sprite
.hatch
 LDA worka
 CMP #24
 BNE nifes
 LDX pages + &02
 LDY pages + &03
 INY
 TYA
 JSR get_map_byte
 CMP #code_space
 BEQ nifes
 LDA #47
 STA paras
 LDX pages + &02
 LDY pages + &03
 JSR write_map_byte
 LDA pages + &02
 STA tempa
 LDA pages + &03
 STA tempy
 LDA #&00
 STA tempx
 STA tempz
 JSR calculate_sprite_plot_mask
 BCS depth 
 JSR eor_a_sprite
 LDA #24
 STA paras
 JSR eor_a_sprite
.depth
 LDX #&03
.lucid
 LDA anoth,X
 BPL stein
 LDA #32 
 STA anoth,X
 LDA pages + &02
 STA xcoor,X
 LDA pages + &03
 STA ycoor,X
 LDA #&04 
 JMP make_sound
.stein
 DEX
 BPL lucid
 RTS

.move_rock
 LDA #&01
 JSR make_sound
 LDA #&06
 STA paras
 LDX pages
 LDY pages + &01
 JSR write_map_byte
 LDA pages
 STA tempa
 LDA pages + &01
 STA tempy
 LDA #&00
 STA tempx
 STA tempz
 JSR calculate_sprite_plot_mask
 BCS rocks_other
 JSR eor_a_sprite
 LDA worka
 STA paras
 JMP eor_a_sprite

.check_hit_monsters
 LDX #&03
.clobr
 LDA anoth,X
 BNE nomos
 LDA xcoor,X
 CMP pages
 BNE nomos
 LDA ycoor,X
 CMP pages + &01
 BNE nomos
 LDA #20
 CLC
 ADC score
 STA score
 LDA #&00
 ADC score + &01
 STA score + &01
 DEC monst
 PHX
 LDA #&05
 JSR make_sound
 JSR monsters
 PLX
 PHX
 DEC anoth,X
 JSR monsters
 PLX
.nomos
 DEX
 BPL clobr
.rocks_other
 RTS

.rocks_finis
 EQUW &11F
 EQUB 14
 EQUS "Amazing, you have completed all"
 EQUW &11F
 EQUB 16
 EQUS "the screens."
 EQUW &11F
 EQUB 18
 EQUS "To enter the competition, make a"
 EQUW &11F
 EQUB 20
 EQUS "note of the number below and"
 EQUW &11F
 EQUB 22
 EQUS "which set of screens you used."
 EQUW &211
 EQUW &71F
 EQUB 25
 EQUS "COMPETITION NUMBER"
 EQUW &B1F
 EQUB 27
.nofin
 EQUW &31F
 EQUB 14
 EQUS "Now try and do that from the"
 EQUW &21F
 EQUB 16
 EQUS "start without using any of the"
 EQUW &31F
 EQUB 18
 EQUS "passwords and picking up all"
 EQUW &81F
 EQUB 20
 EQUS "the eight crowns."
.rocks_retun
 EQUW &111
 EQUW &51F
 EQUB 30
 EQUS "Press       to continue"
 EQUW &61F
 EQUB 11
 EQUS "HAS BEEN COMPLETED ''"
 EQUW &211
 EQUW &B1F
 EQUB 30
 EQUS "SPACE"
 EQUW &311

.congratulations_finished
 JSR setup_custom_mode
 JSR all_colours_to_black
 JSR print_repton_sign
 LDX #LO(rocks_retun)
 LDY #HI(rocks_retun)
 LDA #congratulations_finished-rocks_retun
 JSR write_characters
 LDA tiara
 CMP #&08
 BCC nonum
 LDA userp
 BNE nonum
 LDX #LO(rocks_finis)
 LDY #HI(rocks_finis)
 LDA #nofin-rocks_finis
 JSR write_characters
 LDA score
 STA tempa
 LDA score + &01
 STA tempx
 LDA #LO(map_passwords)
 STA indir
 LDA #HI(map_passwords)
 STA indir + &01
 LDA #&FF
 STA tempy
 LDA #&EE
 STA tempz
 LDY #&00
.chexs
 LDA (indir),Y
 EOR tempy
 STA tempy
 EOR tempz
 STA tempz
 INY
 BNE chexs
 INC indir
 LDA indir
 CMP #&40
 BCC chexs
 LDX #&00
.rocks_volum
 LDY #32
 LDA #&00
.rocks_shape
 ASL tempa
 ROL tempx
 ROL tempy
 ROL tempz
 ROL A
 CMP #10
 BCC rocks_slipy
 SBC #10
 INC tempa
.rocks_slipy
 DEY
 BNE rocks_shape
 PHA
 INX
 LDA tempa
 ORA tempx
 ORA tempy
 ORA tempz
 BNE rocks_volum
.rocks_words
 PLA
 CLC
 ADC #48
 JSR oswrch
 DEX
 BNE rocks_words
 JMP waits

.nonum
 LDX #LO(nofin)
 LDY #HI(nofin)
 LDA #rocks_retun - nofin
 JSR write_characters
.waits
 JSR set_physical_colours
.rocks_press
 LDX #&9D
 JSR test_key
 BPL rocks_press
 JMP rotate_all_screen_bytes

.barit
 EQUB 0
.barrs
 EQUB 0
.notes
 EQUB 0
.black
 EQUW music_bar_01
 EQUW music_bar_02
 EQUW music_bar_03
 EQUW music_bar_04
 EQUW music_bar_05
 EQUW music_bar_06
 EQUW music_bar_07
 EQUW music_bar_08

.play_repton_music
 LDA barit
 BNE diabl
 LDA tunes
 BNE rocks_silen
 LDA barrs
 ASL A
 TAX
 LDA black,X
 STA index
 LDA black + &01,X
 STA index + &01
 LDY notes
 LDA (index),Y
 JSR decode
 STA channel_02 + &04
 LDA notes
 CLC
 ADC #16
 TAY
 LDA (index),Y
 JSR decode
 STA channel_03 + &04
 LDA channel_02 + &04
 CMP #&FF
 BEQ resto
 LDX #LO(channel_02)
 LDY #HI(channel_02)
 LDA #&07
 JSR osword
.resto
 LDA channel_03 + &04
 CMP #&FF
 BEQ rocks_silen
 LDX #LO(channel_03)
 LDY #HI(channel_03)
 LDA #&07
 JSR osword
.rocks_silen
 INC notes
 LDA notes
 CMP #16
 BCC diabl
 STZ notes
 INC barrs
 LDA barrs
 AND #&07
 STA barrs
.diabl
 RTS
.decode
 PHA
 LSR A
 LSR A
 LSR A
 LSR A
 TAX
 PLA
 AND #&0F
 TAY
 LDA octave_00,Y
 CMP #&FF
 BEQ diabl
 CPX #&00
 BEQ diabl
.addup
 CLC
 ADC #48
 DEX
 BNE addup
 RTS

.channel_02
 EQUW &12
 EQUW 2
 EQUW 0
 EQUW 1

.channel_03
 EQUW &13
 EQUW 2
 EQUW 0
 EQUW 1

.octave_00
 EQUB 49 
 EQUB 45 
 EQUB 41 
 EQUB 37
 EQUB 33 
 EQUB 29 
 EQUB 25 
 EQUB 21
 EQUB 17 
 EQUB 13 
 EQUB 9 
 EQUB 5
 EQUB &FF 
 EQUB &FF 
 EQUB &FF 
 EQUB &FF

.final
 EQUW &111
 EQUW &91F 
 EQUB 15
 EQUS "SCORE :"

.final_repton
 JSR setup_custom_mode
 JSR set_physical_colours
 LDX #LO(final)
 LDY #HI(final)
 LDA #final_repton - final
 JSR write_characters
 LDA score
 STA tempa
 LDA score + &01
 STA tempx
 LDX #17 
 LDY #15
 JSR decimal_convert
 LDX #100
 JSR wait_state
 JMP rotate_all_screen_bytes
