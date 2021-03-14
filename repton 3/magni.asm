; magni

.expand_screen
 LDA #17
 STA pages
 LDA #&01
 STA pages + &01
.magni_capit
 LDA pages
 STA sidex
 STA sidey
 LDX #&03
 STX pages + &02
.magni_square
 JSR display_sides
 DEC pages + &02
 BPL magni_square
 INC pages + &01
 INC pages + &01
 DEC pages
 LDA pages
 CMP #&02
 BCS magni_capit
 RTS

.display_sides
 LDX pages + &01
.magni_lines
 PHX
 LDA sidex
 LSR A
 LSR A
 STA tempa
 LDA reptx
 SEC
 SBC #&04
 CLC
 ADC tempa
 TAX
 LDA sidey
 LSR A
 LSR A
 STA tempa
 LDA repty
 SEC
 SBC #&04
 CLC
 ADC tempa
 JSR get_map_byte
 CMP #code_repton
 BNE accum
 LDA #&06
.accum
 STA paras
 LDA sidex
 AND #&FC
 ORA #&01
 STA paras + &01
 LDA sidey
 AND #&FC
 ORA #&01
 STA paras + &02
 LDA sidex
 AND #&03
 TAX
 LDA tabbx,X
 STA paras + &03
 LDA sidey
 AND #&03
 TAY
 LDA tabbx,Y
 STA paras + &04
 JSR place_a_sprite
 LDX pages + &02
 LDA sidex
 CLC
 ADC magni_xdire,X
 STA sidex
 LDA sidey
 CLC
 ADC magni_ydire,X
 STA sidey
 PLX
 DEX
 BNE magni_lines
 RTS

.magni_xdire
 EQUB 0
 EQUB -1
 EQUB 0
 EQUB 1

.magni_ydire
 EQUB &FF
 EQUB &00
 EQUB &01
 EQUB &00

.tabbx
 EQUB &08
 EQUB &04
 EQUB &02
 EQUB &01

.find_byte_in_map                       ;a = byte to find
 STA tempy
 LDX #23
.fresh_row
 LDY #27
 LDA times28_lsb,X
 STA tempa
 LDA times28_msb,X
 STA tempx
 LDA tempy                              ;byte to search for
.search_row
 CMP (tempa),Y
 BEQ grabs                              ;found byte so exit
 DEY
 BPL search_row
 DEX
 BPL fresh_row
 INX                                    ;x/y = 0
 INY
 CLC                                    ;not found so exit, c=0
 RTS

.grabs                                  ;found byte, return x,y coordinates
 PHX
 TYA                                    ;x << y
 TAX
 PLY                                    ;y << x
 SEC                                    ;found c=1
 RTS

.find_repton_in_map                     ;find repton, if not found store repton at 0,0
 LDA #code_repton
 JSR find_byte_in_map
 STX reptx
 STX copyx
 STY repty
 STY copyy
 LDA #code_repton                       ;store repton in map at 0,0 or found coordinates
 JMP write_map_byte

.where                                  ;parameter block for unpack
 EQUW map_buffer
 EQUW &00
 EQUB 84

.map_address_list_lsb
 EQUB LO(map_address_start)
 EQUB LO(map_address_start + (map_compressed_size * &01))
 EQUB LO(map_address_start + (map_compressed_size * &02))
 EQUB LO(map_address_start + (map_compressed_size * &03))
 EQUB LO(map_address_start + (map_compressed_size * &04))
 EQUB LO(map_address_start + (map_compressed_size * &05))
 EQUB LO(map_address_start + (map_compressed_size * &06))
 EQUB LO(map_address_start + (map_compressed_size * &07))
.map_address_list_msb
 EQUB HI(map_address_start)
 EQUB HI(map_address_start + (map_compressed_size * &01))
 EQUB HI(map_address_start + (map_compressed_size * &02))
 EQUB HI(map_address_start + (map_compressed_size * &03))
 EQUB HI(map_address_start + (map_compressed_size * &04))
 EQUB HI(map_address_start + (map_compressed_size * &05))
 EQUB HI(map_address_start + (map_compressed_size * &06))
 EQUB HI(map_address_start + (map_compressed_size * &07))

.get_map_data_into_buffer               ;get address of map and unpack data to map buffer
 LDX grids                              ;current map number
 LDA map_address_list_lsb,X
 STA where + &02
 LDA map_address_list_msb,X
 STA where + &03
 LDX #LO(where)                         ;unpack map bytes
 LDY #HI(where)
 STX tempa
 STY tempx
 LDX #&04
 LDY #&04
.trans
 LDA (tempa),Y
 STA pages,X
 DEY
 DEX
 BPL trans
.mishs
 LDY #&04
.quatr
 LDA (pages + &02),Y
 STA sorks,Y
 DEY
 BPL quatr
 INY
.relod
 LDA #&05
 STA pages + &05
.again
 LDX #&04
.rotat
 ROR sorks,X
 DEX
 BPL rotat
 ROR A
 DEC pages + &05
 BNE again
 LSR A
 LSR A
 LSR A
 STA works,Y
 INY
 CPY #&08
 BCC relod
 LDY #&07
.strch
 LDA works,Y
 STA (pages),Y
 DEY
 BPL strch
 LDA pages
 CLC
 ADC #&08
 STA pages
 BCC crate
 INC pages + &01
.crate
 LDA pages + &02
 CLC
 ADC #&05
 STA pages + &02
 BCC crabs
 INC pages + &03
.crabs
 DEC pages + &04
 BNE mishs
 RTS
