; score

.status_start
 EQUW &311
 EQUW &21F
 EQUB &06
 EQUS "REPTON 3 redux the story so far..."
 EQUW &111
 EQUW &61F
 EQUB 27
 EQUS "Press"
 EQUW &121F
 EQUB 27
 EQUS "to PLAY"
 EQUW &111
 EQUW &A1F
 EQUB 10
 EQUS "Time :"
 EQUW &91F
 EQUB 12
 EQUS "Lives :"
 EQUW &91F
 EQUB 14
 EQUS "Score :"
 EQUW &81F
 EQUB 16
 EQUS "Crowns :"
 EQUW &81F
 EQUB 18
 EQUS "Screen :"
 EQUW &61F
 EQUB 20
 EQUS "Diamonds :"
 EQUW &61F
 EQUB 22
 EQUS "Monsters :"
 EQUW &61F
 EQUB 24
 EQUS "Password :"
 EQUW &211
 EQUW &C1F
 EQUB 27
 EQUS "SPACE"
.status_end
 
.repton_game_status
 JSR setup_custom_mode
 JSR all_colours_to_black
 LDX #LO(status_start)
 LDY #HI(status_start)
 LDA #status_end - status_start
 JSR write_characters
 JSR time_left
 JSR lives_left
 JSR current_score
 JSR crowns_left
 JSR repton_playing_map
 JSR diamonds_left
 JSR map_password
 JSR eggs_left
 JMP get_colours_from_map

.repton_map_text
 EQUW &111F
 EQUB 18
.repton_screen_map
 EQUB &00
.lasts
 EQUW &8011
 EQUB 31
 EQUB 7
 EQUB 28
 EQUS "   "
 
.time_left
 LDA watch 
 STA tempa
 LDA watch + &01 
 STA tempx
 LDX #17 
 LDY #10
 JMP decimal_convert

.current_score
 LDA score 
 STA tempa
 LDA score + &01 
 STA tempx
 LDX #17 
 LDY #14
 JMP decimal_convert

.diamonds_left
 LDY diamn + &01 
 BNE enough 
 STY tempx
 LDX diamn 
 CPX #&07 
 BCS enough 
 STX tempa
 TXA 
 BEQ runer
 LDX #17 
 LDY #20
 JMP decimal_convert

.enough
 LDX #LO(plenty)
 LDY #HI(plenty)
 TYA
 STA tempx
 LDA #crowns_left - plenty 
 JMP write_characters
.runer
 LDX #LO(times)
 LDY #HI(times)
 LDA #plenty - times
 JMP write_characters

.times
 EQUW &211
 EQUW &111F 
 EQUB 20
 EQUS "Defuse Timebomb"

.plenty
 EQUW &111F
 EQUB 20
 EQUS "Plenty'"

.crowns_left
 LDA tiara
 STA tempa
 STZ tempx
 LDX #17
 LDY #16
 JMP decimal_convert

.lives_left
 LDA lives
 STA tempa
 STZ tempx
 LDX #17
 LDY #12
 JMP decimal_convert

.repton_playing_map                     ;print the current screen map
 LDA grids
 CLC
 ADC #65                                ;convert to upper case
 STA repton_screen_map
 LDX #LO(repton_map_text)
 LDY #HI(repton_map_text)
 LDA #lasts - repton_map_text
 JMP write_characters

.initialise_game_timer                  ;get timer from map file according to map number
 LDA grids
 ASL A
 TAX
 LDA map_timers,X
 STA watch
 LDA map_timers + &01,X
 STA watch + &01
 RTS

.number_of_diamonds_and_monsters
 JSR get_number_of_characters
 LDA #&00
 TAY
 CLC
 ADC field + &01
 TAX
 TYA
 ADC fielh + &01
 TAY
 TXA
 CLC
 ADC field + 22
 TAX
 TYA
 ADC fielh + 22
 TAY
 TXA
 CLC
 ADC field + 23
 STA diamn
 TYA
 ADC fielh + 23
 STA diamn + &01
 LDA field + 24
 STA monst
 RTS

.passw
 EQUW &111F 
 EQUB 24

.map_password
 LDX #LO(passw)
 LDY #HI(passw)
 LDA #map_password - passw 
 JSR write_characters
 LDA grids                              ;get map and index into map file
 ASL A
 ASL A
 ASL A
 TAX
 LDY #&07
.score_string
 LDA map_passwords,X 
 CMP #&0D 
 BEQ end_of_password
 JSR oswrch
 INX
 DEY
 BNE score_string
.end_of_password
 RTS

.eggs_left
 LDA monst 
 STA tempa
 STZ tempx
 LDX #17
 LDY #22
 JMP decimal_convert

.score_drive
 EQUS "DRIVE 0", &0D

.directory
 EQUS "DIR$", &0D

.disc_directory
 LDX #LO(directory)
 LDY #HI(directory)
 JSR oscli
 LDX #LO(score_drive)
 LDY #HI(score_drive)
 JMP oscli
