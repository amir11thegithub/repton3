; chart

.write_map_graphic
 ASL A
 ASL A
 ASL A
 ROL tempz
 CLC
 ADC #LO(squez)
 STA tempy
 LDA tempz
 AND #&01
 ADC #HI(squez)
 STA tempz
 TXA
 ASL A
 ASL A
 ASL A
 ROL tempx
 CLC
 ADC start
 STA tempa
 LDA tempx
 AND #&01
 ADC start + &01
 STA tempx
 TYA
 CLC
 ADC tempx
 BPL wraps
 SEC
 SBC #&20
.wraps
 STA tempx
 LDY #&07
.mored
 LDA (tempy),Y
 STA (tempa),Y
 DEY
 BPL mored
.outas
 RTS

.messa_chart
 EQUW &111
 EQUW &C1F
 EQUB &01
 EQUS "SCREEN"
 EQUW &71F
 EQUB 30
 EQUS "Press       to PLAY"
 EQUW &211
 EQUW &D1F 
 EQUB 30
 EQUS "SPACE"
 EQUW &131F
 EQUB &01
.pokes
 EQUB 32
.messa_chart_end

.display_map
 LDA grids
 CLC
 ADC #65
 STA pokes
 JSR all_colours_to_black
 JSR setup_custom_mode
 LDA #24
 STA pages + &05
 LDA #25
 STA pages + &07
.relod_chart
 LDA #28
 STA pages + &04
 LDA #29
 STA pages + &06
.small
 LDA pages + &05
 ASL A
 TAY
 LDX pages + &04
 LDA pages + &05
 JSR get_map_byte
.mottl
 LDX pages + &04
 INX
 INX
 LDY pages + &05
 INY
 INY
 INY
 INY
 JSR write_map_graphic
 DEC pages + &04
 DEC pages + &06
 BPL small
 DEC pages + &05
 DEC pages + &07
 BPL relod_chart
 LDX #LO(messa_chart)
 LDY #HI(messa_chart)
 LDA #messa_chart_end - messa_chart
 JSR write_characters
 JMP get_colours_from_map

.squez
 EQUD &1F1F2600
 EQUD &60F0F0F
 EQUD &F0703010
 EQUD &80C0E0F0
 EQUD &4020000
 EQUD &40001
 EQUD &1040000
 EQUD &40002
 EQUD &A4A00000
 EQUD &A0A4
 EQUD &F060F060
 EQUD &6060F0F0
 EQUD &00
 EQUD &00
 EQUD &B000D00
 EQUD &B000D00
 EQUD &83808580
 EQUD &83808580
 EQUD &1A101C10
 EQUD &1A101C10
;10
 EQUD &B000DF0
 EQUD &B000D00
 EQUD &B000D00
 EQUD &F0000D00
 EQUD &43603010
 EQUD &83808540
 EQUD &2860C080
 EQUD &1A101C20
 EQUD &83808580
 EQUD &30604140
 EQUD &1A101C10
 EQUD &C0602C20
 EQUD &FA50F5A
 EQUD &FA50F5A
 EQUD &F250712
 EQUD &FA50F5A
 EQUD &FA40E48
 EQUD &FA50F5A
 EQUD &FA50F5A
 EQUD &325075A
;20
 EQUD &FA50F5A
 EQUD &CA40E5A
 EQUD &A0A000
 EQUD &A0A000
 EQUD &4FA74F0F
 EQUD &F2FC72F
 EQUD &A1A0A0E0
 EQUD &E0A0A082
 EQUD &F0606060
 EQUD &60F0F0F0
 EQUD &30000000
 EQUD &B0D0
 EQUD &2C440609
 EQUD &9062243
 EQUD &6448800
 EQUD &60F0F0F
 EQUD &A4A4E000
 EQUD &E0A4A4
 EQUD &A000000
 EQUD &E0E0E0A0
;30
 EQUD &F0666600
 EQUD &F0696F0
 EQUD &A040000
 EQUD &40A
 EQUD &20E0000
 EQUD &E080608
 EQUD &66F90000
 EQUD &88FF6666
 EQUD &66F90000
 EQUD &11FF6666
 EQUD &60CCCC00
 EQUD &F0696F0
 EQUD &60333300
 EQUD &F0696F0
 EQUD &60666600
 EQUD &B062470
 EQUD &60666600
 EQUD &6040460
 EQUD &60666600
 EQUD &6040460
;40
 EQUD &60666600
 EQUD &B062470
 EQUD &60666600
 EQUD &D0642E0
 EQUD &60666600
 EQUD &6020260
 EQUD &60666600
 EQUD &6020260
 EQUD &60666600
 EQUD &D0642E0
 EQUD &E0666600
 EQUD &1090F70
 EQUD &70666600
 EQUD &8090FE0
 EQUD &A0604060
 EQUD &60D02050
 EQUD &F0F0F0F0
 EQUD &F0F0F0F0

.effects
 LDA watch
 ORA watch + &01
 BNE cords
 LDX #61
.effxs
 PHX
 LDY #&29
 LDX #&00
.chart_loops
 TYA
 LDY randu,X
 ADC randu,X
 STA randu,X
 INX
 CPX #&04
 BCC chart_loops
 LDA randu + &01
 AND #31
 TAX
 LDA randu + &02
 AND #31
 TAY
 LDA #48
 JSR write_map_graphic
 PLX
 DEX
 BPL effxs
.cords
 LDX #&08
 JMP wait_state
