; page zero addresses
;
; &EE - &EF    - current program
; &F0 - &F1    - hex accumulator
; &F2 - &F3    - top of memory
; &F4 - &F5    - address of byte transfer address, nmi addr or trans
; &F6 - &F7    - data transfer address
; &F8 - &F9    - string pointer, osword control block
; &FA - &FB    - ctrl - osfile, osgbpb control block, prtext string pointer
; &FC          - interrupt accumulator
; &FD - &FE    - brk program counter
; &FF          - escape flag
;
; normal workspace
; &A8 - &AF    - os workspace
; &B0 - &BF    - file system scratch space
; &E4 - &E6    - os workspace
; &E7          - auto repeat countdown byte
; &E8 - &E9    - osword &00 input pointer
; &EC          - last key press
; &ED          - penultimate key press
; &EE - &EF    - current program
; &F2 - &F3    - command line pointer
; &F4          - paged rom
; &FC          - interrupt accumulator
; &FD - &FE    - brk program counter
; &FF          - escape flag

 userp                                  = &00
 bomba                                  = &01
 monst                                  = &02
 trubl                                  = &03
 teeth                                  = &05
 index                                  = &08
 randu                                  = &0C
 randy                                  = &0F
 xcoor                                  = &10
 rand_plus                              = &10
 ycoor                                  = &14
 framc                                  = &18
 direc                                  = &1C
 monsc                                  = &20
 anoth                                  = &24
 monsf                                  = &28
 bornm                                  = &2C
 spirp                                  = &30
 spirx                                  = &38
 spiry                                  = &40
 spirc                                  = &48
 spirf                                  = &50
 spird                                  = &58
 pages                                  = &60
 works                                  = &66
 quart                                  = &6C
 aloof                                  = &6E
 kicks                                  = &6F
 tempa                                  = &70
 tempx                                  = &71
 tempy                                  = &72
 tempz                                  = &73
 indir                                  = &74
 tunes                                  = &76
 gates                                  = &77
 death                                  = &78
 grids                                  = &79
 worka                                  = &7A
 start                                  = &7B
 watch                                  = &7D
 lives                                  = &7F
 score                                  = &80
 tiara                                  = &82
 diamn                                  = &83
 twent                                  = &85
 slows                                  = &86
 paras                                  = &87
 movie                                  = &90
 mcode                                  = &91
 cosit                                  = &92
 shift                                  = &93
 reptn                                  = &94
 reptx                                  = &95
 repty                                  = &96
 sting                                  = &97
 copyx                                  = &98
 copyy                                  = &99
 lenth                                  = &9A
 cornx                                  = &9B
 corny                                  = &9C
 sidex                                  = &9E
 xxadj                                  = &9E
 sidey                                  = &9F
 yyadj                                  = &9F
 count                                  = &B0
 sorks                                  = &B0
 found_a_slot                           = &140
 
 combined_block_start                   = &C0

 combined_space                         = &C0
 combined_escape                        = &C1
 combined_m                             = &C2
 combined_z                             = &C3
 combined_x                             = &C4

 combined_block_end                     = &CF

 stack                                  = &0100
 
 field                                  = &0C00
 fielh                                  = &0C20
 diary                                  = &0C80

 map_compressed_size                    = &01A4
 map_buffer                             = &0900

; map file addresses
 map_sprite_offset                      = &318
 map_passwords                          = &31E0
 map_timers                             = &3220
 map_edits                              = &3230
 map_transporters                       = &3240
 map_physical_colours                   = &32C0
 map_address_start                      = &32E0
 map_sprites                            = &4000
 
 himem                                  = &6000

; os
 paged_rom                              = &F4
 interrupt_accumulator                  = &FC

; op codes
 bit_op                                 = &2C

; graphic codes
 code_space                             = &06
 code_wall                              = &07
 code_safe                              = 22
 code_repton                            = 30

; ascii characters
 ascii_space                            = 32
 ascii_pling                            = 33
 ascii_full_stop                        = 46
 ascii_00                               = 48
 ascii_01                               = 49
 ascii_02                               = 50
 ascii_03                               = 51
 ascii_04                               = 52
 ascii_05                               = 53
 ascii_06                               = 54
 ascii_07                               = 55
 ascii_08                               = 56
 ascii_09                               = 57
 ascii_under_score                      = 60
 ascii_equals                           = 61
 ascii_greater_than                     = 62
 ascii_upper_a                          = 65
 ascii_upper_z                          = 90
 ascii_a                                = 97
 ascii_3                                = 51
 ascii_4                                = 52
 ascii_colon                            = 58
 ascii_z                                = 122
