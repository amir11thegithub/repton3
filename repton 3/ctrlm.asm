; ctrlm

.mastr                                  ;main game start
 LDX #LO(flexi)
 LDY #HI(flexi)
 LDA #flexi_end - flexi
 JSR write_characters
 JSR disc_directory
 JSR decode_passwords
 LDA #LO(patch_brk_vector)              ;patch brk vector
 STA brkv
 LDA #HI(patch_brk_vector)
 STA brkv + &01
 JSR write_vector_patch

.master_control
 JSR select_swr_ram_slot
 LDX #&FF                               ;flatten stack
 TXS
 INC barit
 STZ userp                              ;clear password used flag
 LDA #178
 LDX #&FF
 LDY #&00
 JSR osbyte
 JSR setup_custom_mode
 JSR setup_interrupt_and_event
 JSR general_setup
 ASL A
 TAX
 JMP (addrs,X)

.addrs
 EQUW cabinet
 EQUW enter_password
 EQUW play_game

.cabinet
 JSR rotate_all_screen_bytes
 JSR load_repton_map
 JSR decode_passwords
 JSR disc_directory
 BRA master_control

.password_entered
 JSR rotate_all_screen_bytes
 BRA master_control

.enter_password
 JSR rotate_all_screen_bytes
 JSR repton_password
 BCC password_entered
 INC userp                              ;password used flag

.play_game
 JSR jingle
 LDA tunes                              ;if no music then bypass wait
 BEQ ctrlm_waits
 LDX #100
 JSR wait_state
.ctrlm_waits
 LDA #178
 LDX #&00
 LDY #&00
 JSR osbyte
 JSR rotate_all_screen_bytes
 JSR setup_custom_mode
 JSR setup_interrupt_and_event
 JSR get_map_data_into_buffer
 JSR get_colours_from_map
 JSR number_of_diamonds_and_monsters
 JSR repton_yolks
 JSR find_repton_in_map
 JSR expand_screen
 JSR place_repton
 JSR monsters
 JSR control_spirits

.next_screen
 LDA #&FF
 STA slows
 LDA tiara
 STA crown

.start_game
 JSR initialise_game_timer
 STZ death
.games
 STZ barit
 JSR repton_running
 JSR monster_chase
 JSR rock_maintenance
 JSR flip_keys
 JSR fungus_spread
 JSR hatch_monsters
 JSR display_repton_map
 JSR status_screen
 JSR pause_game
 JSR reset_repton
 JSR countdown
 LDA death
 BEQ alive
 JMP repton_out_of_time

.alive
 LDA diamn
 ORA diamn + &01
 ORA monst
 BNE games
 LDA tiara
 CMP crown
 BEQ games
 JSR bombs
 LDA bomba
 BMI games
 INC barit
 JSR get_colours_from_map
 JSR rotate_all_screen_bytes
 LDA grids
 ASL A
 TAX
 LDA map_edits,X
 ORA map_edits + &01,X
 BEQ fedup
 JSR editor_codes
.shado
 JSR test_space_key
 TYA
 BMI shado
 JSR rotate_all_screen_bytes
.fedup
 INC grids
 LDA grids
 CMP #&08
 BCS finished_all_screens
 JSR get_map_data_into_buffer
 JSR number_of_diamonds_and_monsters
 JSR repton_yolks
 JSR find_repton_in_map
 JSR initialise_game_timer
 JSR stars_repton
 JMP next_screen

.finished_all_screens
 JSR congratulations_finished
 JMP master_control

.display_repton_map
 LDX #&9A
 JSR test_key
 BPL ctrlm_mapps
 LDA grids
 CMP #&05
 BCS ctrlm_mapps
 LDA #13
 LDX #&04
 JSR osbyte
 INC barit
 JSR rotate_all_screen_bytes
 JSR display_map
.paces
 JSR test_space_key
 TYA
 BMI paces
 JSR rotate_all_screen_bytes
 JSR expand_screen
 JSR place_repton
 JSR control_spirits
 JSR monsters
 JMP setup_interrupt_and_event

.range                                  ;keys r/m
 EQUB &CC
 EQUB &9A

.status_screen
 LDX #&B6
 JSR test_key
 BPL ctrlm_mapps
.stars_repton
 LDA #13                                ;disable event
 LDX #&04
 JSR osbyte
 INC barit
 JSR rotate_all_screen_bytes
 JSR repton_game_status
.yregs
 LDY #&01
.going
 PHY
 LDX range,Y
 JSR test_key
 BMI yubet
 PLY
 DEY
 BPL going
 JSR test_space_key
 TYA
 BMI yregs
 PHA
.yubet
 PLA
 ASL A
 TAX
 JMP (jumps,X)
.ctrlm_mapps
 RTS

.paper_repton
 JSR rotate_all_screen_bytes
 JSR expand_screen
 JSR place_repton
 JSR control_spirits
 JSR monsters
 JMP setup_interrupt_and_event

.jumps
 EQUW clean_repton
 EQUW selected_map
 EQUW paper_repton

.selected_map
 LDA grids
 CMP #&05
 BCS yregs
 JSR rotate_all_screen_bytes
 JSR display_map
.walls
 JSR test_space_key
 TYA
 BMI walls
 JMP stars_repton

.out_of_time
 EQUW &211
 EQUW &A1F
 EQUB 15
 EQUS "Out of time."

.repton_out_of_time
 INC barit
 LDA #&07
 JSR make_sound
 JSR get_colours_from_map
 JSR repton_explodes
 JSR rotate_all_screen_bytes
 JSR setup_custom_mode
 JSR set_physical_colours
 LDA watch
 ORA watch + &01
 BNE sandy
 LDX #LO(out_of_time)
 LDY #HI(out_of_time)
 LDA #repton_out_of_time - out_of_time
 JSR write_characters
 LDX #100                               ;wait two seconds
 JSR wait_state
.sandy
 DEC lives
 BEQ trifl
 LDA #code_repton
 JSR find_byte_in_map                   ;fund repton in map and set to space
 BCC noval                              ;not found
 LDA #code_space
 JSR write_map_byte
.noval
 LDX copyx                              ;copy coordinates
 STX reptx
 LDY copyy
 STY repty
 LDA #code_repton                       ;now write him back into the map
 JSR write_map_byte
 JSR initialise_game_timer
 JSR stars_repton
 JMP start_game
.ctrlm_exits
 RTS

.trifl
 JSR final_repton
 JMP master_control
.reset_repton
 LDX #&FF
 JSR test_key
 BPL ctrlm_exits
 LDX #&CC
 JSR test_key
 BPL ctrlm_exits
 JSR rotate_all_screen_bytes
 JMP master_control

.clean_repton
 LDX #&FF
 JSR test_key
 BMI ctrlm_thats
 JMP yregs
.ctrlm_thats
 JSR rotate_all_screen_bytes
.reset
 JMP master_control

.ctrlm_mtake
 EQUB 7
 EQUB 31
.mtakx
 EQUB 0
 EQUB 17
 EQUW &211
.sweep
 EQUD &00
 EQUD &00
 EQUD &00
 EQUD &00
 EQUD &00
 EQUD &00

.patch_brk_vector
 LDX #&00
.messa_ctrlm
 LDA stack + &02,X
 STA sweep,X
 BEQ error
 INX
 CPX #24
 BCC messa_ctrlm
.error
 STX tempx
 LDA #32
 SEC
 SBC tempx
 LSR A
 STA mtakx
 LDX #patch_brk_vector - ctrlm_mtake
 LDY #&00
.ctrlm_notes
 LDA ctrlm_mtake,Y
 BEQ delay
 JSR oswrch
 INY
 DEX
 BPL ctrlm_notes
.delay
 LDX #180
 JSR wait_state
 JSR rotate_all_screen_bytes
 JMP master_control

.flexi
 EQUB 23
 EQUB 1
 EQUD 0
 EQUD 0
.flexi_end

.decode_passwords
 STZ tempa
 LDX #63
.exors
 LDA map_passwords,X
 EOR tempa
 STA map_passwords,X
 INC tempa
 DEX
 BPL exors
 RTS

.crown EQUB 0
