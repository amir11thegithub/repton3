; jingl

.jingle_notes                           ;note/length
 EQUB 96
 EQUB 10
 EQUB 108
 EQUB 5
 EQUB 96
 EQUB 10
 EQUB 96
 EQUB 10
 EQUB 108
 EQUB 5
 EQUB 96
 EQUB 10
 EQUB 100
 EQUB 5
 EQUB 108
 EQUB 5
 EQUB 100
 EQUB 5
 EQUB 88
 EQUB 10
 EQUB 96
 EQUB 5
 EQUB 100
 EQUB 5
 EQUB 96
 EQUB 5
 EQUB 80
 EQUB 10
.jingle_end

.jingle
 LDA tunes                              ;exit if music turned off
 BNE no_jingle
 LDA #((jingle_end - jingle_notes) / &02) - &01
 STA tempa
.jingle_loop
 LDA #128                               ;read sound channle space
 LDX #&FA
 JSR osbyte
 CPX #&04                               ;space in buffer?
 BCC jingle_loop
 LDA #((jingle_end - jingle_notes) / &02 ) - &01
 SBC tempa                              ;c=1
 ASL A
 TAX
 LDA jingle_notes,X
 ADC #24
 STA melody + &04
 LDA jingle_notes + &01,X
 LSR A
 STA melody + &06
 LDX #LO(melody)                        ;make the note
 LDY #HI(melody)
 LDA #&07
 JSR osword
 DEC tempa
 BPL jingle_loop
.no_jingle
 RTS

.melody
 EQUW &02
 EQUW &01
 EQUW &00
 EQUW &03
