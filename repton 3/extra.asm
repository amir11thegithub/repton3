; extra

 MACRO create_mask_table                ;sprite mask table
 FOR j, 0, 255
  IF j AND &03 = &00
    pixel_00 = &00
  ELSE
    pixel_00 = &03
  ENDIF
  IF j AND &0C = &00
    pixel_01 = &00
  ELSE
    pixel_01 = &0C
  ENDIF
  IF j AND &30 = &00
    pixel_02 = &00
  ELSE
    pixel_02 = &30
  ENDIF
  IF j AND &C0 = &00
    pixel_03 = &00
  ELSE
    pixel_03 = &C0
  ENDIF
  EQUB pixel_00 + pixel_01 + pixel_02 + pixel_03
 NEXT
 ENDMACRO

.mask_sprites                           ;sprite masks, must be on a page boundary
 SKIP 48 * 128

.mask_table
 create_mask_table
 
.map_table                              ;map unpacked and used here
 SKIP &300
 
.title_sprite                           ;storage for main sprite

; sprite routine for multiple row based sprite operations
; + 00 screen address offset
; + 02 sprite address
; + 04 number of rows
; + 05 number of bytes in row

.multiple_row_sprite
 STX tempa
 STY tempx
 LDY #&01
 LDA (tempa)                            ;screen address
 STA fast_store + &01
 LDA (tempa),Y
 STA fast_store + &02
 INY
 LDA (tempa),Y                          ;sprite address
 STA fast_load + &01
 INY
 LDA (tempa),Y
 STA fast_load + &02
 INY
 LDA (tempa),Y                          ;number of rows
 TAX
 INY
 LDA (tempa),Y                          ;number of bytes in row
 STA fast_add + &01
 TAY
 STY fast_bytes + &01
.fast_bytes
 LDY #&00
.fast_load
 LDA fast_load,Y
.fast_store
 STA fast_store,Y
 DEY
 BNE fast_load
 INC fast_store + &02                   ;next screen row
 LDA fast_load + &01
 CLC
.fast_add
 ADC #&00
 STA fast_load + &01
 BCC fast_no_inc
 INC fast_load + &02
.fast_no_inc
 DEX
 BNE fast_bytes
 RTS

.create_sprite_masks
 STZ tempa                              ;initialise pointers
 STZ tempy
 LDA #HI(map_sprites)
 STA tempx
 LDA #HI(mask_sprites)
 STA tempz
 LDY #&00
.create_mask
 LDA (tempa),Y                          ;get sprite byte
 TAX
 LDA mask_table,X                       ;get mask byte
 STA (tempy),Y
 DEY
 BNE create_mask
 INC tempz
 INC tempx
 CMP #HI(mode_5_start)                  ;convert all 48 sprites
 BCC create_mask
 RTS

.restore_sprite_background
 RTS
 
.mask_sprite
 RTS
