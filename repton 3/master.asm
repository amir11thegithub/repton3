; master build assembler
;
; repton1 - basic loader
; repton2 - game code
; repton3 - game code
; repton4 - game code
; repton5 - game code

; prelude
; a PRELUDE 56882
; b CITADEL 48042
; c MORNING 13330
; d AWKWARD 33023
; e FRITTER 24656
; f LAWLESS  8515
; g RATION   3447
; h TOBACCO  2303
; 
; toccata
; a TOCCATA 48042
; b UPSTART  6527
; c OCTAGON 27492
; d CHAOTIC 20312
; e MAJESTY  1356
; f REVENUE 16713
; g FORESEE 50190
; h RESERVE 65280
; 
; finale
; a FINALE  27246
; b ENLIVEN 24937
; c CONTEST  3200
; d ILLEGAL 19786
; e APPEASE  3346
; f STUDENT 20055
; g AVERAGE 16660
; h PHOENIX 51762

; constants
 repton1_limit = &1200
 repton2_limit = &31E0
 repton3_limit = &0800
 repton4_limit = &6000
 repton5_limit = &C000

; addresses
 mode_5_start                           = &5800
 repton5_loaded_at                      = &2000
 repton5_relocated_to                   = &8000
 
 first_swr_ram                          = &8000

 INCLUDE "operating system.asm"         ;data files for main assembly
 INCLUDE "page zero.asm"                ;all declarations in here to prevent duplication
 
 ; envelope data
MACRO envelope n, t, pi1, p12, pi3, pn1, pn2, pn3, aa, ad, as, ar, ala, ald
 EQUB n
 EQUB t
 EQUB pi1
 EQUB p12
 EQUB pi3
 EQUB pn1
 EQUB pn2
 EQUB pn3
 EQUB aa
 EQUB ad
 EQUB as
 EQUB ar
 EQUB ala
 EQUB ald
ENDMACRO

 CPU 1

 ORG   &0E00
 CLEAR &0E00, &11FF
 GUARD &1200

.repton1                                ;repton loader
 EQUS "BBC Master 128 Repton 3 © Superior Software Ltd 1986, © Superior Interactive 2021."
 EQUS "Version 1.0 assembled on "
 EQUS TIME$

.repton1_execute
 LDX #&FF                               ;flatten stack for loader
 TXS
 JSR machine_type                       ;must be master 128
 JSR find_swr_ram_slot                  ;find a bank of ram
 JSR setup_screen                       ;mode 5, turn cursor and colours off
 JSR set_up_envelopes                   ;initialise envelopes
 JSR initialise_page_zero               ;initial game variables
 JSR repton_misc                        ;odds and sods
 LDA #ascii_05                          ;load repton5
 STA repton_name + &06
 LDA #&FF                               ;load repton5 file to &2000
 LDX #LO(load_repton_file)
 LDY #HI(load_repton_file)
 JSR osfile
 JSR select_swr_ram_slot                ;page in swr
 LDX #&40                               ;transfer to swr
 LDY #&00
.transfer_repton5_00
 LDA repton5_loaded_at,Y
.transfer_repton5_01
 STA repton5_relocated_to,Y
 DEY
 BNE transfer_repton5_00
 INC transfer_repton5_00 + &02
 INC transfer_repton5_01 + &02
 DEX
 BNE transfer_repton5_00
 JSR create_sprite_masks                ;now transferred so create mask data
 LDA #ascii_04                          ;load repton4
 STA repton_name + &06
 LDA #&FF
 LDX #LO(load_repton_file)
 LDY #HI(load_repton_file)
 JSR osfile
 LDA #ascii_03                          ;load repton3
 STA repton_name + &06
 LDA #&FF
 LDX #LO(load_repton_file)
 LDY #HI(load_repton_file)
 JSR osfile
 LDA #ascii_02                          ;*run repton2
 STA repton_name + &06
 LDA #&04
 LDX #LO(repton_name)
 LDY #HI(repton_name)
 JMP (fscv)

.load_repton_file
 EQUW repton_name
 EQUD &00
 EQUD &FF
 EQUD &00
 EQUD &00
.repton_name
 EQUS "repton0", &0D

; some return values for machine type
; x = &00 bbc a/b with os 0.10
; x = &01 acorn electron os
; x = &f4 master 128 mos 3.26
; x = &f5 master compact mos 5
; x = &fb bbc b+ 64/128 (os 2.00)
; x = &fc bbc micro (west german mos)
; x = &fd master 128 mos 3.20/3.50
; x = &fe bbc micro (american os a1.0)
; x = &ff bbc micro os 1.00/1.20/1.23

.machine_type
 LDA #&81                               ;which machine are we running on?
 LDX #&00
 LDY #&FF
 JSR osbyte
 CPX #&F4
 BEQ master_only
 CPX #&F5
 BEQ master_only
 CPX #&FD
 BEQ master_only
 BRK                                    ;error message
 EQUB &FF
 EQUS "Master 128 machines only.", &00

.master_only
 RTS

.set_up_envelopes                       ;sound envelopes
 LDY envelope_index
 LDX envelope_data_address_start,Y      ;set up x/y address of envelope data
 INY
 LDA envelope_data_address_start,Y
 INY
 STY envelope_index
 TAY
 LDA #&08                               ;define an envelope
 JSR osword
 DEC envelope_counter
 BNE set_up_envelopes
 RTS

.envelope_counter
 EQUB (envelope_data_address_end - envelope_data_address_start) DIV 2
.envelope_index
 EQUB &00
.envelope_data_address_start
 EQUW env_01
 EQUW env_02
 EQUW env_03
 EQUW env_04
.envelope_data_address_end

.env_01
 envelope 1, 1, 0, 0, 0, 0, 0, 0, 126, -1, 0, -1, 126, 0
.env_02
 envelope 2, 3, 0, 0, 0, 1, 1, 1, 90, -20, -20, -2, 90, 0
.env_03
 envelope 3, 2, 1, 1, 0, 5, 10, 40, 30, -10, -10, -15, 127, 0
.env_04
 envelope 4, 131, 0, 0, 0, 25, 2, -2, 110, 0, -4, -8, 110, 80

.initialise_page_zero
 LDX #page_zero_variables_end - page_zero_variables
.initial_repton
 LDA page_zero_variables - &01,X
 STA tempa,X
 DEX
 BPL initial_repton
 RTS
 
.page_zero_variables
 EQUD &00000000
 EQUD &00000000
 EQUD &00000000
 EQUD &03000060
 EQUD &00000000
.page_zero_variables_end

.setup_screen
 LDA #&90                               ;turn interlace on
 LDX #&00
 LDY #&00
 JSR osbyte
 LDX #&00                               ;clear screen ram before mode change
.clear_screen_page
 STZ mode_5_start,X
 DEX
 BNE clear_screen_page
 INC clear_screen_page + &02
 BPL clear_screen_page
 LDX #&00
.vdu_bytes
 LDA vdu_codes,X
 JSR oswrch
 INX
 CPX #vdu_codes_end - vdu_codes
 BNE vdu_bytes
 RTS
 
.vdu_codes
 EQUB 22                                ;set mode 5
 EQUB 5
 EQUB 23                                ;turn cursor off
 EQUB 1
 EQUD &00
 EQUD &00
 EQUB 19                                ;change logical colours 1-3 to black
 EQUB &01
 EQUD &00
 EQUB 19
 EQUB &02
 EQUD &00
 EQUB 19
 EQUB &03
 EQUD &00
.vdu_codes_end

.repton_misc
 LDA #181                               ;rs423 off
 LDX #&00
 LDY #&00
 JSR osbyte
 LDA #&09                               ;flashing colour 0
 LDX #&00
 LDY #&00
 JSR osbyte                             ;flashing colour 1
 LDA #&0A
 LDX #&00
 LDY #&00
 JSR osbyte
 LDA #&04                               ;disable cursor editing
 LDX #&02
 LDY #&00
 JSR osbyte
 LDA #&10                               ;two adc channels only
 LDX #&02
 LDY #&00
 JMP osbyte
 
.select_swr_ram_slot                    ;select swr
 SEI
 LDA found_a_slot
 STA paged_rom
 STA bbc_romsel
 CLI
 RTS

.find_swr_ram_slot                      ;find swr slot to use
 LDX #&0D
.bbc_swr_loop
 STX bbc_romsel
 LDA first_swr_ram
 INC first_swr_ram
 CMP first_swr_ram
 BEQ next_slot
 LDY #swr_test_end - swr_self_write_test - &01
.transfer_test
 LDA swr_self_write_test,Y
 STA first_swr_ram,Y
 DEY
 BPL transfer_test
 JSR first_swr_ram                      ;z = result
 BNE found_bbc_swr_slot
.next_slot
 DEX
 BPL bbc_swr_loop
 LDA paged_rom                          ;restore basic
 STA bbc_romsel
 BRK
 EQUB &FF
 EQUS "Sideways RAM not found on this machine.", &00
.found_bbc_swr_slot
 STX found_a_slot
 RTS

.swr_self_write_test                    ;try to increment memory
 INC first_swr_ram + (swr_test_location - swr_self_write_test)
 LDA first_swr_ram + (swr_test_location - swr_self_write_test)
 RTS                                    ;z = 1 no change z = 0 can use

.swr_test_location
 EQUB &00
.swr_test_end

.repton1_end
 SAVE "repton1", repton1, repton1_end, repton1_execute

 ORG &1200
 CLEAR &1200, &57FF
 GUARD &5800
.repton2
 INCBIN  "chara.bin"                    ;character data must be loaded at &1200
 INCLUDE "keybd.asm"
 INCLUDE "sqeze.asm"
 INCLUDE "noise.asm"
 INCLUDE "setup.asm"
 INCLUDE "edits.asm"
 INCLUDE "scrol.asm"
 INCLUDE "sprit.asm"
 INCLUDE "score.asm"
 INCLUDE "suqra.asm"
 INCLUDE "magni.asm"
 INCLUDE "chart.asm"
 INCLUDE "topps.asm"
 INCLUDE "rocks.asm"
 INCLUDE "jingl.asm"
 INCLUDE "ctrlm.asm"
 INCLUDE "adjus.asm"
.repton2_code_end

 ORG &31E0                              ;<--- include first map file
 INCBIN "prelude.bin"

.repton2_end
 SAVE "repton2", repton2, &5800, mastr

 ORG &0400
 CLEAR &0400, &07FF
 GUARD &0800
.repton3
 INCLUDE "monst.asm"

.repton3_end
 SAVE "repton3", repton3, repton3_end
 ORG &5810
 CLEAR &5810, &5FFF
 GUARD &6000
.repton4
 INCLUDE "reptn.asm"

.repton4_end
 SAVE "repton4", repton4, repton4_end
 
 ORG &8000
 CLEAR &8000, &BFFF
 GUARD &C000
.repton5
 INCLUDE "extra.asm"

.repton5_end
 SAVE "repton5", repton5, repton5_end, repton5, repton5_loaded_at

;                                       <--- save three map files to disc start
 ORG &31E0
 CLEAR &31E0, &5800
 INCBIN "prelude.bin"
 SAVE "prelude", &31E0, &5800, &0000

 ORG &31E0
 CLEAR &31E0, &5800
 INCBIN "toccata.bin"
 SAVE "toccata", &31E0, &5800, &0000

 ORG &31E0
 CLEAR &31E0, &5800
 INCBIN "finale.bin"
 SAVE "finale", &31E0, &5800, &0000
;                                       <--- save three map files to disc end

 total_free_space = (repton1_limit - repton1_end) + (repton2_limit - repton2_code_end) + (repton3_limit - repton3_end) + (repton4_limit - repton4_end) + (repton5_limit - repton5_end)

 PRINT "           >      <      |      ><"
 PRINT " repton1  ", ~repton1, " ", ~repton1_end,       "" , ~repton1_limit, ""  , repton1_limit - repton1_end
 PRINT " repton2  ", ~repton2, "",  ~repton2_code_end,  "" , ~repton2_limit, ""  , repton2_limit - repton2_code_end
 PRINT " repton3  ", ~repton3, " ", ~repton3_end,      " " , ~repton3_limit, " " , repton3_limit - repton3_end
 PRINT " repton4  ", ~repton4, "",  ~repton4_end,       "" , ~repton4_limit, ""  , repton4_limit - repton4_end
 PRINT " repton5  ", ~repton5, "",  ~repton5_end,       "" , ~repton5_limit, ""  , repton5_limit - repton5_end

 PRINT "                               ",  total_free_space
