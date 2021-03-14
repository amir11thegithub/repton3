; reptn

.hopin
 EQUB 30
 EQUB 35
 EQUB 30
 EQUB 36

.ctrlk
 EQUB &BD
 EQUB &9E
 EQUB &B7
 EQUB &97

.store
 EQUB &00
 EQUB &00
 EQUB &00

.cover
 EQUB twoes-onnes
 EQUB three-twoes
 EQUB infom-three

.roads
 EQUB &FF
 EQUB &01
 EQUB &00
 EQUB &00
 EQUB &01
 EQUB &FF
.lists
 EQUW onnes
 EQUW twoes
 EQUW three
.onnes
 EQUB 37
 EQUB 37
 EQUB 37
 EQUB 37
 EQUB 37
 EQUB 38
 EQUB 38
 EQUB 39
 EQUB 39
 EQUB 40
 EQUB 40
 EQUB 40
 EQUB 40
 EQUB 40
 EQUB 39
 EQUB 39
 EQUB 38
 EQUB 38
.twoes
 EQUB 41
 EQUB 41
 EQUB 41
 EQUB 41
 EQUB 41
 EQUB 42
 EQUB 42
 EQUB 43
 EQUB 43
 EQUB 44
 EQUB 44
 EQUB 44
 EQUB 44
 EQUB 44
 EQUB 43
 EQUB 43
 EQUB 42
 EQUB 42
.three
 EQUB 45
 EQUB 45
 EQUB 45
 EQUB 45
 EQUB 46
 EQUB 46
 EQUB 46
 EQUB 46
.infom
 EQUD &00000201
 EQUD &80000703
 EQUD &80808080
 EQUD &80808080
 EQUD &80808080
 EQUD &80808080
 EQUD &80070401
 EQUD &80800605
 EQUD &80808080
 EQUD &80808080
 EQUD &80808080
 EQUD &80808080
.reptn_shove
 EQUB 21
 EQUB 13
.reptn_pushs
 EQUB 25
 EQUB 9
.super
 EQUB 2
 EQUB -2

.idler
 DEC shift
 BNE updat
 LDA #21
 STA shift
 LDA #19
 JSR osbyte
 LDA reptn
 JSR repton_share
 INC cosit
 LDA cosit
 AND #&03
 TAX
 LDA hopin,X
 JSR repton_share
 JMP rock_maintenance

.right
 EQUB &FF
 EQUB &00
 EQUB &00
 EQUB &FF
.chanl
 EQUW &0101
 EQUW &0202

.repton_running                         ;repton moving
 LDA #&04
 STA movie
 DEA
 STA sting
 STZ kicks
.reads
 LDA perip                              ;using joystick?
 BNE joysk
 LDY sting
 LDX ctrlk,Y
 JSR test_key
 BMI route
 BRA lockd

.joysk
 LDY sting
 LDX chanl,Y
 LDA #128
 JSR osbyte
 TYA
 LDX sting
 EOR right,X
 CMP #&A0
 BCS route
.lockd
 DEC sting
 BPL reads
 LDA mcode
 BEQ idler
 DEC mcode
.updat
 JMP rock_maintenance

.route
 LDY sting
 LDA reptx
 CLC
 ADC adjux,Y
 TAX
 LDA repty
 CLC
 ADC adjuy,Y
 JSR get_map_byte
 TAX
 LDA infom,X
 BMI lockd
 CMP #&01
 BNE earth
 LDY sting
 CPY #&02
 BCS lockd
 STX accum
 LDA reptn_shove,Y
 STA paras + &01
 LDA #17
 STA paras + &02
 LDA #&F
 STA paras + &03
 STA paras + &04
 LDA reptx
 CLC
 ADC super,Y
 TAX
 LDA repty
 JSR get_map_byte
 CMP #code_space
 BNE lockd
 STA paras
 JSR place_a_sprite
 INC kicks
 LDY sting
 LDA reptx
 CLC
 ADC adjux,Y
 TAX
 LDY repty
 LDA #code_space
 JSR write_map_byte
 LDY sting
 LDA reptn_pushs,Y
 STA paras + &01
 LDA reptx
 CLC
 ADC super,Y
 TAX
 LDY repty
 LDA accum
 STA paras
 JSR write_map_byte
 JSR eor_a_sprite
 LDA #code_space
 STA paras
 JSR eor_a_sprite
.earth
 LDA #80
 STA mcode
 STZ movie
.worth
 LDA death
 BNE minit
 JSR rock_maintenance
 JSR spirits_off
 JSR monsters_off
 JSR hatch_monsters
 JSR scroll_screen
 JSR repton_jumps
 CLI
 JSR update_edges
 INC movie
 LDA movie
 CMP #&04
 BCS reptn_slide
 JSR countdown
 JSR monster_on
 JSR spirit_on
 JSR monster_chase
 JMP worth
.reptn_slide
 JSR update_repton
 JSR monster_on
 JSR spirit_on
 JSR repton_action
 STZ kicks
.minit
 RTS

.repton_jumps
 LDA reptn
 STA paras
 LDX sting
 LDA #17
 CLC
 ADC roads,X
 STA paras + &01
 LDA #17
 CLC
 ADC roads + &02,X
 STA paras + &02
 LDA #&0F
 STA paras + &03
 STA paras + &04
 JSR eor_a_sprite
 LDX sting
 CPX #&03
 BCC frees
 DEX
.frees
 INC store,X
 LDA store,X
 CMP cover,X
 BNE skips
 STZ store,X
.skips
 TXA
 ASL A
 TAY
 LDA lists,Y
 STA tempa
 LDA lists + &01,Y
 STA tempx
 LDY store,X
 LDA (tempa),Y
 JMP repton_share

.update_edges                           ;update the edges of the screen when repton is moving
 JSR initialise_edges
.edges
 JSR calcaulate_mask_x
 JSR coordinate_x
 JSR coordinate_y
 JSR get_coordinate_map_byte
 JSR place_a_sprite
 INC lenth
 LDA lenth
 CMP #&09
 BCC edges
 RTS

.calcaulate_mask_x
 LDA sting
 ASL A
 ASL A
 ADC movie
 TAX
 LDA maskx,X
 STA paras + &03
 LDA masky,X
 STA paras + &04
 LDA lenth
 BEQ angle
 CMP #8
 BEQ angle
 RTS

.angle
 LSR A
 LSR A
 LSR A
 STA tempa
 LDA sting
 ASL A
 ADC tempa
 TAX
 LDA nintx,X
 BMI false
 STA paras + &03
.false
 LDA ninty,X
 BMI worse
 STA paras + &04
.worse
 RTS

.maskx
 EQUB &02
 EQUB &01
 EQUB &08
 EQUB &04
 EQUB &04
 EQUB &08
 EQUB &01
 EQUB &02

.masky
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &04
 EQUB &08
 EQUB &01
 EQUB &02
 EQUB &02
 EQUB &01
 EQUB &08
 EQUB &04

.nintx
 EQUB &FF
 EQUB &FF
 EQUB &FF
 EQUB &FF

.ninty
 EQUB 3
 EQUB 12
 EQUB 3
 EQUB 12
 EQUB &FF
 EQUB &FF
 EQUB &FF
 EQUB &FF

.coordinate_x
 LDA sting
 ASL A
 ASL A
 ORA movie
 TAX
 LDA cordx,X
 BMI calcs
 STA paras + &01
 RTS
.calcs
 LDA lenth
 ASL A
 SEC
 ROL A
 STA paras + &01
 RTS

.cordx
 EQUB 32
 EQUB 31
 EQUB 34
 EQUB 33
 EQUB 2
 EQUB 3
 EQUB 0
 EQUB 1
.cordy
 EQUB &FF
 EQUB &FF
 EQUB &FF
 EQUB &FF
 EQUB &FF
 EQUB &FF
 EQUB &FF
 EQUB &FF
 EQUB &02
 EQUB &03
 EQUB &00
 EQUB &01
 EQUB 32
 EQUB 31
 EQUB 34
 EQUB 33

.coordinate_y
 LDA sting
 ASL A
 ASL A
 ORA movie
 TAX
 LDA cordy,X
 BMI aline
 STA paras + &02
 RTS

.aline
 LDA lenth
 ASL A
 SEC
 ROL A
 STA paras + &02
 RTS

.get_coordinate_map_byte
 LDX sting
 LDA cornx
 CLC
 ADC direx,X
 STA cornx
 LDA corny
 CLC
 ADC direy,X
 STA corny
 LDX cornx
 JSR get_map_byte
 STA paras
 RTS

.direx
 EQUB &00
 EQUB &00
.direy
 EQUB &01
 EQUB &01
 EQUB &00
 EQUB &00

.adjux
 EQUB &01
 EQUB &FF
.adjuy
 EQUB &00
 EQUB &00
 EQUB &FF
 EQUB &01

.update_repton
 LDX reptx
 LDY repty
 LDA #code_space
 STA paras
 JSR write_map_byte
 LDX sting
 LDA traix,X
 STA paras + &01
 LDA traiy,X
 STA paras + &02
 LDA #&F
 STA paras + &03
 STA paras + &04
 JSR eor_a_sprite
 LDX sting
 LDA reptx
 CLC
 ADC adjux,X
 STA reptx
 LDA repty
 CLC
 ADC adjuy,X
 STA repty
 LDX reptx
 JSR get_map_byte
 STA accum
 TAX
 LDA infom,X
 CMP #code_wall
 BEQ initl
 LDA death
 BNE initl
 LDX reptx
 LDY repty
 LDA #code_repton
 JMP write_map_byte

.traix
 EQUB 13
 EQUB 21
.traiy
 EQUB 17
 EQUB 17
 EQUB 21
 EQUB 13

.initialise_edges
 STX lenth
 LDX sting
 LDA reptx
 CLC
 ADC squax,X
 STA cornx
 LDA repty
 CLC
 ADC squay,X
 STA corny
 LDA movie
 CMP #2
 BCC initl
 LDA cornx
 CLC
 ADC adjux,X
 STA cornx
 LDA corny
 CLC
 ADC adjuy,X
 STA corny
.initl
 RTS

.squax
 EQUB 4
 EQUB -4
.squay
 EQUB -5
 EQUB -5
 EQUB -4
 EQUB 4

.repton_action
 LDY accum
 LDA infom,Y
 ASL A
 TAX
 JMP (reptn_addrs,X)

.reptn_addrs
 EQUW remove_graphic
 EQUW remove_graphic
 EQUW picked_diamond
 EQUW picked_capsule
 EQUW picked_keys
 EQUW picked_transporter
 EQUW picked_crown
 EQUW picked_death
 EQUW picked_time_bomb

.picked_diamond
 LDA #&00
 JSR make_sound
 LDA score
 CLC
 ADC #&05
 STA score
 LDA score + &01
 ADC #&00
 STA score + &01
 LDA #&04
 STA quart
 LDA diamn                              ;reduce diamond quantity by one
 SEC
 SBC #&01
 STA diamn
 BCS diamond_okay
 DEC diamn + &01
.diamond_okay
 LDA #&01
 JMP remove_graphic

.picked_capsule
 LDA #&09
 JSR make_sound
 JSR initialise_game_timer
 JSR get_colours_from_map
 LDA #4
 JMP remove_graphic

.picked_keys
 LDA #&02
 JSR make_sound
 JSR transform_safe_to_diamond
 LDA #25
 JMP remove_graphic

.picked_transporter
 JSR transporter_square_pattern         ;flood screen with squares
 LDX reptx                              ;remove repton from current location
 LDY repty
 LDA #code_space
 JSR write_map_byte
 LDA grids                              ;find out which transporter it is
 ASL A
 ASL A
 ASL A
 ASL A
 TAX
 LDY #&04
.looks
 LDA map_transporters,X
 BMI reptn_nexts                        ;transpoter not active
 CMP reptx                              ;compare repton x/y against transporter x/y
 BNE reptn_nexts
 LDA map_transporters + &01,X
 CMP repty
 BEQ slots                              ;found a matching transporter
.reptn_nexts
 INX                                    ;move to next transporter slot
 INX
 INX
 INX
 DEY
 BNE looks
.slots
 LDA map_transporters + &02,X           ;get destination x/y and store
 STA reptx
 STA copyx
 LDA map_transporters + &03,X
 STA repty
 STA copyy
 LDA repty
 LDX reptx
 JSR get_map_byte                       ;get byte at the target
 CMP #code_space
 BNE lefal                              ;anything other than blank space then die
 JSR expand_screen
 JSR place_repton
 JSR monsters
 JSR control_spirits
 LDA #code_repton                       ;set repton at location
 LDX reptx
 LDY repty
 JMP write_map_byte

.lefal
 INC death
 JSR expand_screen
 JSR place_repton
 LDX #50
 JMP wait_state

.picked_crown
 LDA #&08
 JSR make_sound
 LDA score
 CLC
 ADC #50
 STA score
 BCC picked_crown
 INC score + &01
.picked_crown_up
 INC tiara
 LDA #29
 JMP remove_graphic

.picked_death
 INC death
.siton
 RTS

.remove_graphic
 CMP #&00
 BEQ siton
 CMP #24
 BEQ siton
 CMP #27
 BEQ siton
 CMP #47
 BEQ siton
 STA paras
 LDA #17
 STA paras + &01
 STA paras + &02
 LDA #&0F
 STA paras + &03
 STA paras + &04
 JMP eor_a_sprite

.picked_time_bomb
 INC bomba
 RTS

.place_repton
 LDA #&FF
 STA sting
 STA twent
 STA bomba
 STA movie
 LDA #&80
 STA infom + 27
 LDX reptx
 LDY repty
 LDA #code_repton
 JSR write_map_byte
 LDA #code_repton
 JSR repton_share
 LDA #code_space
 STA paras
 JMP eor_a_sprite

.repton_share
 STA reptn
 STA paras
 LDA #17
 STA paras + &01
 STA paras + &02
 LDA #&F
 STA paras + &03
 STA paras + &04
 JMP eor_a_sprite

.flagm
 EQUD &00
.prest
 EQUD &00
.flags
 EQUD &00
 EQUD &00
.reptn_press
 EQUD &00
 EQUD &00

.monsters_off
 LDX #&03
.monof
 LDA #&00
 STA flagm,X
 STA prest,X
 LDA anoth,X
 BNE reptn_monst
 STX aloof
 LDA xcoor,X
 STA tempa
 LDA monsc,X
 STA tempx
 LDA ycoor,X
 STA tempy
 LDA direc,X
 STA tempz
 LDA framc,X
 STA paras
 JSR calculate_sprite_plot_mask
 BCS blind
 LDX aloof
 INC prest,X
 LDA indir
 CMP #4
 BCC place
 CMP #31
 BCS place
 LDA indir+1
 CMP #4
 BCC place
 CMP #31
 BCC blind
.place
 INC flagm,X
 JSR eor_a_sprite
.blind
 LDX aloof
.reptn_monst
 DEX
 BPL monof
 RTS

.monster_on
 LDX #&03
.monot
 LDA anoth,X
 BNE monon
 STX aloof
 LDA xcoor,X
 STA tempa
 LDA monsc,X
 STA tempx
 LDA ycoor,X
 STA tempy
 LDA direc,X
 STA tempz
 LDA framc,X
 STA paras
 JSR calculate_sprite_plot_mask
 BCS moron
 LDX aloof
 LDA flagm,X
 BNE plaic
 LDA prest,X
 BNE moron
.plaic
 JSR eor_a_sprite
.moron
 LDX aloof
.monon
 DEX
 BPL monot
 RTS

.spirits_off
 LDX #7
.spiof
 LDA #&00
 STA flags,X
 STA reptn_press,X
 LDA spirp,X
 BNE reptn_spirt
 STX aloof
 LDA spirx,X
 STA tempa
 LDA spirc,X
 STA tempx
 LDA spiry,X
 STA tempy
 LDA spird,X
 STA tempz
 LDA spirf,X
 STA paras
 JSR calculate_sprite_plot_mask
 BCS mugin
 LDX aloof
 INC reptn_press,X
 LDA indir
 CMP #&04
 BCC plaqu
 CMP #31
 BCS plaqu
 LDA indir+1
 CMP #4
 BCC plaqu
 CMP #31
 BCC mugin
.plaqu
 INC flags,X
 JSR eor_a_sprite
.mugin
 LDX aloof
.reptn_spirt
 DEX
 BPL spiof
 RTS

.spirit_on
 LDX #&07
.reptn_spots
 LDA spirp,X
 BNE spion
 STX aloof
 LDA spirx,X
 STA tempa
 LDA spirc,X
 STA tempx
 LDA spiry,X
 STA tempy
 LDA spird,X
 STA tempz
 LDA spirf,X
 STA paras
 JSR calculate_sprite_plot_mask
 BCS slogs
 LDX aloof
 LDA flags,X
 BNE fishs
 LDA reptn_press,X
 BNE slogs
.fishs
 JSR eor_a_sprite
.slogs
 LDX aloof
.spion
 DEX
 BPL reptn_spots
 RTS

.bangs
 EQUB 6
 EQUB 61
 EQUB 62
 EQUB 63
 EQUB 62
 EQUB 61
 EQUB 6

.repton_explodes
 LDA #&11
 STA paras + &01
 STA paras + &02
 LDA #&0F
 STA paras + &03
 STA paras + &04
 LDX #&06
.explo
 PHX
 LDA bangs,X
 STA paras
 JSR place_a_sprite
 JSR effects
 PLX
 DEX
 BPL explo
.noeds
 RTS

.bombs
 LDA #&08
 STA infom + 27
 RTS

.specy
 EQUW &0111
 EQUW &0B1F
 EQUB &04
 EQUS "SCREEN "
 EQUW &41F
 EQUB 22
 EQUS "Press       to CONTINUE"
 EQUW &0211
 EQUW &121F
 EQUB 4
.edits
 EQUB &00
 EQUW &A1F
 EQUB 22
 EQUS "SPACE"
 EQUW &311
 EQUW &A1F
 EQUB &08
 EQUS "EDITOR CODE"

.editor_codes
 JSR setup_custom_mode
 JSR set_physical_colours
 LDA grids
 CLC
 ADC #65
 STA edits
 LDX #LO(specy)
 LDY #HI(specy)
 LDA #editor_codes - specy
 JSR write_characters
 LDA grids
 ASL A
 TAX
 LDA map_edits,X
 STA tempa
 LDA map_edits + &01,X
 STA tempx
 LDX #13
 LDY #10
 JMP decimal_convert
