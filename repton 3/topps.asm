; topps

.xadin
 EQUB &01
 EQUB &FF
 EQUB &00
 EQUB &00

.yadin
 EQUB &00
 EQUB &00
 EQUB &FF
 EQUB &01

.fungus_spread
 DEC slows
 BNE fungy
 LDA #&04
 STA slows
 DEC twent
 BPL justr
 LDA #23
 STA twent
.justr
 LDX #27
 STX pages + &02
.mushy
 LDA twent
 LDX pages + &02
 JSR get_map_byte
 CMP #26
 BNE spore
 LDA randy
 AND #&03
 TAY
 LDA xadin,Y
 CLC
 ADC pages + &02
 STA pages
 TAX
 LDA yadin,Y
 CLC
 ADC twent
 STA pages + &01
 JSR get_map_byte
 CMP #26
 BEQ spore
 CMP #&02
 BEQ can_spread_here
 CMP #&03
 BEQ can_spread_here
 CMP #code_space
 BEQ can_spread_here
 CMP #code_repton
 BEQ kill_repton
 BRA spore                              ;always

.can_spread_here
 STA paras
 LDA #26
 LDX pages
 LDY pages + &01
 JSR write_map_byte
 LDA pages
 STA tempa
 LDA pages + &01
 STA tempy
 STZ tempx
 STZ tempz
 LDA #&FF
 STA movie
 JSR calculate_sprite_plot_mask
 BCS fungy
 JSR eor_a_sprite
 LDA #26
 STA paras
 JMP eor_a_sprite

.spore
 DEC pages + &02
 BPL mushy
.fungy
 RTS

.kill_repton
 INC death
 RTS

.repton_x_coordinate
 LDA reptx
 ASL A
 ASL A
 ORA #&01
 STA paras + &01
 LDA movie
 CMP #&04
 BCS fungy
 LDX sting
 CPX #&02
 BCS fungy
 TXA
 BEQ topps_posit
 LDA paras + &01
 SEC
 SBC movie
 STA paras + &01
 RTS
.topps_posit
 LDA paras + &01
 CLC
 ADC movie
 STA paras + &01
 RTS

.repton_y_coordinate
 LDA repty
 ASL A
 SEC
 ROL A
 STA paras + &02
 LDA movie
 CMP #&04
 BCS fungy
 LDX sting
 CPX #&02
 BCC fungy
 BNE upper
 LDA paras + &02
 SEC
 SBC movie
 STA paras + &02
 RTS

.upper
 LDA paras + &02
 CLC
 ADC movie
 STA paras + &02
 RTS

.monster_x_coordinate
 LDA tempa
 ASL A
 SEC
 ROL A
 STA tempa
 LDX tempz
 CPX #&02
 BCS fungy
 TXA
 BNE zeros
 LDA tempa
 CLC
 ADC tempx
 STA tempa
 RTS
.zeros
 LDA tempa
 SEC
 SBC tempx
 STA tempa
 RTS

.monster_y_coordinate
 LDA tempy
 ASL A
 SEC
 ROL A
 STA tempy
 LDY tempz
 CPY #&02
 BCC fungy
 BEQ douze
 LDA tempy
 CLC
 ADC tempx
 STA tempy
 RTS

.douze
 LDA tempy
 SEC
 SBC tempx
 STA tempy
 RTS

.calculate_sprite_plot_mask
 JSR repton_x_coordinate
 JSR repton_y_coordinate
 JSR monster_x_coordinate
 JSR monster_y_coordinate
 LDA paras + &01
 SEC
 SBC #17
 STA paras + &01
 LDA tempa
 SEC
 SBC paras + &01
 CMP #35
 BCS opens
 STA paras + &01
 STA indir
 TAX
 LDA topps_masks,X
 STA paras + &03
 LDA paras + &02
 SEC
 SBC #17
 STA paras + &02
 LDA tempy
 SEC
 SBC paras + &02
 CMP #35
 BCS opens
 STA paras + &02
 STA indir+1
 TAY
 LDA topps_masks,Y
 STA paras + &04
 CLC
.opens
 RTS

.topps_masks
 EQUB &01
 EQUB &03
 EQUB &07
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0F
 EQUB &0E
 EQUB &0C
 EQUB &08

.transform_safe_to_diamond
 LDA #code_safe                         ;find safe
 JSR find_byte_in_map
 BCC opens                              ;c=0 not found
 STX paras + &01
 STY paras + &02
 LDA #&01
 STA paras
 JSR write_map_byte
 LDA paras + &01
 STA tempa
 LDA paras + &02
 STA tempy
 STZ tempx
 STZ tempz
 LDA #&FF
 STA movie
 JSR calculate_sprite_plot_mask
 BCS transform_safe_to_diamond          ;c=1 off screen
 JSR place_a_sprite
 BRA transform_safe_to_diamond          ;keep looking
