; make_sound

.color
 EQUB &00
 EQUB &04
 EQUB &03
 EQUB &02

.decimal_convert
 LDA #31
 JSR oswrch
 TXA
 JSR oswrch
 TYA
 JSR oswrch
 LDA #17
 JSR oswrch
 LDA #&02
 JSR oswrch
 LDX #&00
.volum
 LDY #&10
 LDA #&00
.shape
 ASL tempa
 ROL tempx
 ROL A
 CMP #10
 BCC slipy
 SBC #10
 INC tempa
.slipy
 DEY
 BNE shape
 PHA
 INX
 LDA tempa
 ORA tempx
 BNE volum
.words
 PLA
 CLC
 ADC #48
 JSR oswrch
 DEX
 BNE words
.silen
 RTS

.test_key
 LDA #129
 TAY
 JSR osbyte
 TYA
 RTS

.noise
 EQUW &11
 EQUW 1
 EQUW 200
 EQUW 20

 EQUW &10
 EQUW -8
 EQUW 4
 EQUW 7

 EQUW &10
 EQUW -10
 EQUW 0
 EQUW 4

 EQUW &11
 EQUW 1
 EQUW 100
 EQUW 10

 EQUW &10
 EQUW -15
 EQUW 2
 EQUW 3

 EQUW &10
 EQUW -12
 EQUW 6
 EQUW 3

 EQUW &11
 EQUW 3
 EQUW 50
 EQUW 15

 EQUW &10
 EQUW 4
 EQUW 5
 EQUW 4

 EQUW &10
 EQUW -15
 EQUW 1
 EQUW 3

 EQUW &11
 EQUW -15
 EQUW 80
 EQUW &02
 EQUW &10
 EQUW -12
 EQUW 0
 EQUW 4

.make_sound
 LDX gates
 BNE silen
 LDY #HI(noise)
 ASL A
 ASL A
 ASL A
 ADC #LO(noise)
 BCC no_noise_inc
 INY
.no_noise_inc
 TAX
 LDA #&07
 JMP osword

.get_colours_from_map                   ;get four physical colours from map and store
 LDA grids
 ASL A
 ASL A
 TAX
 LDY #&00
.get_colours
 LDA map_physical_colours,X
 STA color,Y
 INX
 INY
 CPY #&04
 BCC get_colours                        ;roll into routine

.set_screen_colours                     ;get physical colours from saved colours and set screen
 LDA #19                                ;wait for vertical sync
 JSR osbyte
 LDX #&03                               ;change all four colours
.physical
 LDA #19
 JSR oswrch
 TXA
 JSR oswrch
 LDA color,X
 JSR oswrch
 LDA #&00
 JSR oswrch
 JSR oswrch
 JSR oswrch
 DEX
 BPL physical
 RTS

.machine_code_name
 EQUS "REPTON ", &0D

.run_machine_code                       ;run machine code file
 STA machine_code_name + &06
 LDX #LO(machine_code_name)
 LDY #HI(machine_code_name)
 LDA #&04
 JMP (fscv)

.pause_game
 LDX #&8F
 JSR test_key
 BPL deads
 INC death
.deads
 RTS

.logic
 EQUB &00
 EQUB &04
 EQUB &03
 EQUB &02

.set_physical_colours
 LDX #&03
.pastl
 LDA logic,X
 STA color,X
 DEX
 BPL pastl
 JMP set_screen_colours

.ticks
 EQUB &09
.toggl
 EQUB &00

.countdown
 LDA watch + &01
 BNE deads
 DEC ticks
 BNE deads
 LDA #&09
 STA ticks
 INC toggl
 LDY #&07
 LDA toggl
 AND #&01
 BNE selet
 LDA grids
 ASL A
 ASL A
 TAX
 LDY map_physical_colours,X
.selet
 STY fasts + &01
 LDA #19
 JSR osbyte
 LDX #LO(fasts)
 LDY #HI(fasts)
 LDA #&0C
 JSR osword
 LDA toggl
 AND #&01
 BEQ deads
 LDA #10
 JMP make_sound

.fasts
 EQUD &00
 EQUB &00

.test_space_key
 LDX #&9D
 JSR test_key
 BMI keyin
 LDA #128
 LDX #&00
 JSR osbyte
 TXA
 AND #&01
 BNE keyin
.minus
 LDY #&FF
 RTS
.keyin
 LDY #&02
 RTS
