; monst

 octave_02=0
 octave_03=&10
 octave_04=&20
 b=0
 a_dash=1
 a=2
 g_dash=3
 g=4
 f_dash=5
 f=6
 e=7
 d_dash=8
 d=9
 c_dash=10
 c=11

.hatch_monsters                         ;check eggs to see if can be hatched
 LDX #&03
.chick
 LDA anoth,X
 BMI enabl
 BEQ enabl
 DEC anoth,X
 BNE enabl
 LDA movie
 CMP #&04
 BCC crack
 STX aloof
 LDY ycoor,X
 LDA xcoor,X
 TAX
 LDA #6
 STA paras
 JSR write_map_byte 
 LDX aloof
 LDA #32
 STA bornm,X
 LDA xcoor,X
 STA tempa
 LDA ycoor,X
 STA tempy
 LDA #0
 STZ tempx
 STZ tempz
 STZ monsc,X
 STZ direc,X
 JSR calculate_sprite_plot_mask
 BCS eggon
 JSR place_a_sprite
 LDX aloof
 LDA framc,X
 STA paras
 JSR eor_a_sprite
 JMP rock_maintenance
.crack
 INC anoth,X
.enabl
 DEX
 BPL chick
.eggon
 RTS

.repton_yolks
 LDX #&03
.yolks
 LDA #&03
 STA monsf,X
 LDA #33
 STA framc,X
 LDA #&FF
 STA anoth,X
 DEX
 BPL yolks
 LDX #7
.spirt
 STX aloof
 LDY #&FF
 STY spirp,X
 INY
 STY spirc,X
 INY
 STY spird,X
 LDA #&03
 STA count,X
 LDA #31
 STA spirf,X
 JSR find_byte_in_map
 BCC whisk
 TXA
 LDX aloof
 STA spirx,X
 STY spiry,X
 INC spirp,X
 TAX
 LDA #code_space
 JSR write_map_byte
 JSR adjust_spirits
.whisk
 LDX aloof
 DEX
 BPL spirt
 RTS

.monsters
 LDX #&03
.moors
 LDA anoth,X
 BNE notri
 STX aloof
 LDA framc,X
 STA paras
 LDA xcoor,X
 STA tempa
 LDA monsc,X
 STA tempx
 LDA ycoor,X
 STA tempy
 LDA direc,X
 STA tempz
 JSR calculate_sprite_plot_mask
 BCS monst_leafs
 JSR eor_a_sprite
.monst_leafs
 LDX aloof
.notri
 DEX
 BPL moors
 RTS

.control_spirits
 LDX #&07
.vodka
 LDA spirp,X
 BMI tonic
 STX aloof
 LDA spirf,X
 STA paras
 LDA spirx,X
 STA tempa
 LDA spirc,X
 STA tempx
 LDA spiry,X
 STA tempy
 LDA spird,X
 STA tempz
 JSR calculate_sprite_plot_mask
 BCS water
 JSR eor_a_sprite
.water
 LDX aloof
.tonic
 DEX
 BPL vodka
 RTS

.monster_chase
 LDA #19
 JSR osbyte
 JSR monsters
 LDX #&03
.jiger
 STX aloof
 LDA anoth,X
 BMI negat
 BNE tiger
 LDA bornm,X
 BEQ alive_chase
 DEC bornm,X
 BNE tiger
.alive_chase
 LDA monsc,X
 BNE ammun
 LDA randy 
 AND #&01
 BNE slide 
 TAY
 LDA reptx 
 CMP xcoor,X 
 BCS chock
 INY 
 BNE chock
.slide
 LDY #&03
 LDA repty 
 CMP ycoor,X 
 BCS chock
 DEY
.chock
 STY direc,X
 LDA ycoor,X 
 CLC 
 ADC monst_yadin,Y 
 PHA
 LDA xcoor,X 
 CLC 
 ADC monst_xadin,Y
 TAX 
 PLA 
 JSR get_map_byte 
 LDX aloof
 CMP #&02 
 BEQ ammun
 CMP #&03 
 BEQ ammun
 CMP #code_space 
 BEQ ammun
 CMP #code_repton 
 BNE tiger
 INC death
.ammun
 INC monsc,X 
 LDA monsc,X
 AND #&03 
 STA monsc,X 
 BNE tiger
 JSR ADDEM
.tiger
 JSR has_monster_caught_repton
 DEC monsf,X 
 BNE negat
 LDA #&03 
 STA monsf,X
 LDA framc,X 
 EOR #&03 
 STA framc,X
.negat
 DEX
 BPL jiger
 JSR monsters
 JSR control_spirits
 LDX #&07
.wines
 LDA spirp,X
 BMI beers
 STX aloof
 LDA reptx 
 CMP spirx,X 
 BNE enter
 LDA repty 
 CMP spiry,X 
 BNE enter
 INC death
.enter
 LDA spirc,X
 BNE flash
 JSR monsters_sides
 JSR spirit_front
 JSR spirit_front
.flash
 DEC count,X
 BNE nofla
 LDA #&03
 STA count,X
 LDA spirf,X
 EOR #63
 STA spirf,X
.nofla
 INC spirc,X
 LDA spirc,X
 AND #&03
 STA spirc,X
 BNE beers
 LDY spird,X
 LDA spirx,X
 CLC
 ADC monst_xadin,Y
 STA spirx,X
 LDA spiry,X
 CLC
 ADC monst_yadin,Y
 STA spiry,X
.beers
 DEX
 BPL wines
 JMP control_spirits

.monst_xadin
 EQUB &01
 EQUB &FF
.monst_yadin
 EQUB &00
 EQUB &00
 EQUB &FF
 EQUB &01
.xdash
 EQUB &00
 EQUB &00
.ydash
 EQUB &FF
 EQUB &01
 EQUB &00
 EQUB &00
.sides
 EQUB &02
 EQUB &03
 EQUB &01
 EQUB &00

.monsters_sides
 LDA spirp,X
 BMI siout
 LDY spird,X
 LDA spiry,X
 CLC
 ADC ydash,Y
 STA pages + &01
 LDA spirx,X
 CLC
 ADC xdash,Y
 STA pages
 TAX
 LDA pages + &01
 JSR get_map_byte
 LDX aloof
 CMP #&02
 BEQ forwd
 CMP #&03
 BEQ forwd
 CMP #code_space
 BEQ forwd
 CMP #23
 BEQ spirit_hit_cage
 CMP #code_repton
 BNE siout
.deded
 INC death
 RTS

.forwd
 LDY spird,X
 LDA sides,Y
 STA spird,X
.siout
 RTS

.spirit_hit_cage
 DEC spirp,X
 LDX pages
 LDY pages + &01
 LDA #&01
 STA paras
 JSR write_map_byte
 LDA pages
 STA tempa
 LDA pages + &01
 STA tempy
 LDA #&00
 STZ tempx
 STZ tempz
 JSR calculate_sprite_plot_mask
 BCS pling
 JSR place_a_sprite
.pling
 LDA #&03
 JMP make_sound

.holly
 PLA
 PLA
 JMP beers

.spirit_front
 LDA spirp,X
 BMI front
 LDY spird,X
 LDA spiry,X
 CLC
 ADC monst_yadin,Y
 STA pages + &01
 LDA spirx,X
 CLC
 ADC monst_xadin,Y
 STA pages
 TAX
 LDA pages + &01
 JSR get_map_byte
 LDX aloof
 CMP #&02 
 BEQ front
 CMP #&03 
 BEQ front
 CMP #code_space 
 BEQ front
 CMP #23 
 BEQ spirit_hit_cage
 CMP #code_repton 
 BNE chang
 BRA deded                              ;always
.chang
 LDY spird,X
 LDA insid,Y
 STA spird,X
.front
 RTS

.has_monster_caught_repton
 LDA reptx
 EOR xcoor,X
 BNE spots
 LDA repty
 EOR ycoor,X                            ;test for monster catching repton
 BNE spots
 INC death
.spots
 LDY ycoor,X
 LDA xcoor,X
 TAX
 TYA
 JSR get_map_byte
 LDX #&02
.steel
 CMP hamer,X
 BEQ kilit
 DEX
 BPL steel
 BRA stink                              ;always
.kilit
 LDX aloof
 DEC anoth,X
 LDA #&05
 JSR make_sound
 DEC monst
 LDA score
 CLC
 ADC #20
 STA score
 BCC stink
 INC score + &01
.stink
 LDX aloof
 RTS

.ADDEM
 LDY direc,X
 LDA xcoor,X
 CLC
 ADC monst_xadin,Y
 STA xcoor,X
 LDA ycoor,X
 CLC
 ADC monst_yadin,Y
 STA ycoor,X
 RTS

.music_bar_01
.music_bar_05
 EQUB c OR octave_04
 EQUB &FF
 EQUB e OR octave_04
 EQUB d OR octave_04
 EQUB e OR octave_04
 EQUB d OR octave_04
 EQUB c OR octave_04
 EQUB &FF
 EQUB &FF
 EQUB &FF
 EQUB e OR octave_04
 EQUB d OR octave_04
 EQUB e OR octave_04
 EQUB f OR octave_04
 EQUB g OR octave_04
 EQUB &FF
 EQUB g OR octave_04
 EQUB &FF
 EQUB c OR octave_02
 EQUB &FF
 EQUB c OR octave_03
 EQUB &FF
 EQUB g OR octave_02
 EQUB &FF
 EQUB c OR octave_03
 EQUB &FF
 EQUB c OR octave_02
 EQUB &FF
 EQUB c OR octave_03
 EQUB &FF
 EQUB g OR octave_02
 EQUB &FF
 EQUB c OR octave_03
 EQUB &FF

.music_bar_02
.music_bar_06
 EQUB &FF
 EQUB &FF
 EQUB f_dash OR octave_04
 EQUB g OR octave_04
 EQUB a OR octave_04
 EQUB g OR octave_04
 EQUB f_dash OR octave_04
 EQUB g OR octave_04
 EQUB a OR octave_04
 EQUB &FF
 EQUB &FF
 EQUB &FF
 EQUB &FF
 EQUB &FF
 EQUB &FF
 EQUB &FF
 EQUB d OR octave_02
 EQUB &FF
 EQUB d OR octave_03
 EQUB &FF
 EQUB a OR octave_02
 EQUB &FF
 EQUB d OR octave_03
 EQUB &FF
 EQUB d OR octave_02
 EQUB &FF
 EQUB c OR octave_03
 EQUB &FF
 EQUB b OR octave_02
 EQUB &FF
 EQUB a OR octave_02
 EQUB &FF

.music_bar_03
 EQUB &FF
 EQUB &FF
 EQUB b OR octave_04
 EQUB a OR octave_04
 EQUB g OR octave_04
 EQUB a OR octave_04
 EQUB g OR octave_04
 EQUB f OR octave_04
 EQUB e OR octave_04
 EQUB f OR octave_04
 EQUB e OR octave_04
 EQUB d OR octave_04
 EQUB e OR octave_04
 EQUB d OR octave_04
 EQUB c OR octave_04
 EQUB d OR octave_04
 EQUB g OR octave_02
 EQUB &FF
 EQUB g OR octave_03
 EQUB &FF
 EQUB d OR octave_02
 EQUB &FF
 EQUB g OR octave_03
 EQUB &FF
 EQUB g OR octave_02
 EQUB &FF
 EQUB g OR octave_03
 EQUB &FF
 EQUB d OR octave_02
 EQUB &FF
 EQUB g OR octave_03
 EQUB &FF

.music_bar_04
 EQUB g OR octave_03
 EQUB a OR octave_03
 EQUB c OR octave_04
 EQUB d OR octave_04
 EQUB e OR octave_04
 EQUB d OR octave_04
 EQUB c OR octave_04
 EQUB a OR octave_03
 EQUB c OR octave_04
 EQUB &FF
 EQUB &FF
 EQUB &FF
 EQUB &FF
 EQUB &FF
 EQUB &FF
 EQUB &FF
 EQUB c OR octave_02
 EQUB &FF
 EQUB c OR octave_03
 EQUB &FF
 EQUB g OR octave_02
 EQUB &FF
 EQUB c OR octave_03
 EQUB &FF
 EQUB c OR octave_02
 EQUB &FF
 EQUB g OR octave_02
 EQUB &FF
 EQUB a OR octave_02
 EQUB &FF
 EQUB b OR octave_02
 EQUB &FF

.music_bar_07
 EQUB g OR octave_04
 EQUB b OR octave_04
 EQUB f OR octave_04
 EQUB a OR octave_04
 EQUB e OR octave_04
 EQUB g OR octave_04
 EQUB d OR octave_04
 EQUB f OR octave_04
 EQUB c OR octave_04
 EQUB e OR octave_04
 EQUB b OR octave_03
 EQUB d OR octave_04
 EQUB a OR octave_03
 EQUB c OR octave_04
 EQUB g OR octave_03
 EQUB b OR octave_03
 EQUB g OR octave_02
 EQUB &FF
 EQUB g OR octave_03
 EQUB &FF
 EQUB d OR octave_02
 EQUB e OR octave_02
 EQUB f OR octave_02
 EQUB g OR octave_02
 EQUB f OR octave_02
 EQUB &FF
 EQUB f OR octave_03
 EQUB &FF
 EQUB d OR octave_02
 EQUB e OR octave_02
 EQUB f OR octave_02
 EQUB d OR octave_02

.music_bar_08
 EQUB e OR octave_04
 EQUB d OR octave_04
 EQUB c OR octave_04
 EQUB d OR octave_04
 EQUB g OR octave_03
 EQUB a OR octave_03
 EQUB c OR octave_04
 EQUB d OR octave_04
 EQUB c OR octave_04
 EQUB &FF
 EQUB b OR octave_03
 EQUB c OR octave_04
 EQUB d OR octave_04
 EQUB b OR octave_03
 EQUB a OR octave_03
 EQUB g OR octave_03
 EQUB e OR octave_02
 EQUB &FF
 EQUB e OR octave_03
 EQUB &FF
 EQUB d OR octave_02
 EQUB &FF
 EQUB d OR octave_03
 EQUB &FF
 EQUB c OR octave_02
 EQUB &FF
 EQUB g OR octave_02
 EQUB a OR octave_02
 EQUB b OR octave_02
 EQUB g OR octave_02
 EQUB f OR octave_02
 EQUB e OR octave_02

.hamer
 EQUB 0
 EQUB 24
 EQUB 26

.insid
 EQUB 3
 EQUB 2
 EQUB 0
 EQUB 1
