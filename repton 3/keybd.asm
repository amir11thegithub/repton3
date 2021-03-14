; keybd

 bbc_m_key                              = 101     ;make inkey value positive and subtract 1
 bbc_x_key                              = 66
 bbc_z_key                              = 97
 bbc_escape                             = 112
 bbc_space                              = 98

; direct key press on the bbc
MACRO read_key_bbc key_value
 LDA #key_value
 STA sheila + &4F
 LDA sheila + &4F                       ;n flag = key pressed
ENDMACRO

; store unbounced key press result on bbc
MACRO store_unbounced_bbc unbounced_address
 STA unbounced_address
ENDMACRO

; debounce bbc key press
MACRO debounce_bbc_key key_address
 BPL clear_key                          ;y=&ff
 BIT key_address
 BMI clear_key                          ;if pressed last time clear bit 7
 BVS debounce_end                       ;debounce
 STY key_address                        ;set key pressed flag and debounce flag
 BRA debounce_end
.clear_key
 LSR key_address                        ;key not pressed, second pass clears debounce flag
.debounce_end
ENDMACRO

.read_keyboard_out_game                 ;all keys outside of game
 LDY #&FF                               ;key reset, y=&ff
 SEI
 LDA #&7F                               ;system via port a data direction register a
 STA sheila + &43                       ;bottom 7 bits are outputs and the top bit is an input
 LDA #&0F
 STA sheila + &42                       ;allow write to addressable latch
 LDA #&03
 STA sheila + &40                       ;set bit 3 to 0
 LDX #bbc_key_values_end - bbc_key_values - &01
.bbc_read_keys
 LDA bbc_key_values,X                   ;bit 0 = debounce
 LSR A
 STA sheila + &4F
 LDA sheila + &4F
 BPL clear_key
 LDA combined_block_start,X
 BCS no_debounce                        ;do not debounce key
 BMI clear_key                          ;if pressed last time clear bit 7
 ASL A
 BMI debounce_end                       ;debounce
.no_debounce
 STY combined_block_start,X             ;set key pressed flag and debounce flag
 BRA debounce_end
.clear_key
 LSR combined_block_start,X             ;key not pressed, second pass clears debounce flag
.debounce_end
 DEX
 BPL bbc_read_keys

.read_keyboard_in_game                  ;read individually for speed
 LDY #&FF                               ;key reset, y=&ff
 SEI
 LDA #&7F                               ;system via port a data direction register a
 STA sheila + &43                       ;bottom 7 bits are outputs and the top bit is an input
 LDA #&0F
 STA sheila + &42                       ;allow write to addressable latch
 LDA #&03
 STA sheila + &40                       ;set bit 3 to 0

 read_key_bbc bbc_z_key
 store_unbounced_bbc combined_z
 read_key_bbc bbc_x_key
 store_unbounced_bbc combined_x
 read_key_bbc bbc_escape
 store_unbounced_bbc combined_escape
 read_key_bbc bbc_space
 debounce_bbc_key combined_space

 CLI
 RTS

.bbc_key_values                         ;bit 0 = 1 then debounce
 EQUB bbc_x_key << &01

 ;EQUB &01 + (bbc_arrow_up    << &01)

.bbc_key_values_end

.reset_keyboard
 LDA #&40                               ;set key as previously pressed, bit 6
 LDX #combined_block_end - combined_block_start
.clear_combined_block
 STA combined_block_start - &01,X
 DEX
 BNE clear_combined_block
 RTS
