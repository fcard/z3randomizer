; -- Ancilla Example --

!AssembleExampleAncilla = 1 ; Boolean to enable assembling the subroutines
                            ; for the Example ancilla object.
                            ; 1 = Yes; 0 = No

if !AssembleExampleAncilla != 0
AncillaExt_AddExample: ; Subroutine to create ancilla object
    LDA #$44 ; `A` register must be the ancilla object's id/index
    JSL AddAncillaLong ; Call this to actually create the object
    BCS .noOpenSlots ; Upon calling AddAncillaLong, Carry will be set to one if no
                     ; slots are available. There are 10* slots available at a time.

   ; On Success, the X register will be set to the slot carrying the object.
   ; We can now use it to set certain memory locations reserved for ancilla objects.

   LDA #$80 : STA $0BF0, X ; Like this one
   LDA #$40 : STA $0C54, X ; Or this
   LDA #$20 : STA $0C5E, X ; Or this
   LDA #$10 : STA $0C72, X ; Or this

   ; For the purposes of this example, we will get a random value between 0 and 7
   ; into one of our general purpose memory locations.

   JSL GetRandomInt : AND #$07 : STA $0BF0, X

   ; We can also use this special memory location;
   ; it's a timer that automatically decrements each frame!
   ; It will stop at zero, and start again once a new value is set.
   LDA #$78 : STA $0C68, X

   ; Once the object is created, the subroutine associated with it will be called
   ; periodically. What subroutine that is can be set with the tables in the tables.asm
   ; file! Remember to put your new ones at the end or it will break the game. You also
   ; need to add an entry to AncillaMaxSpriteCount, the third table there; see it for
   ; more details. Now, see the subroutine AncillaExt_Example for more!

   .noOpenSlots
   ; Remember to put all cleanups within the case where no open slots were available!
RTL
;*Ancilla slots are complicated, see: https://alttp-wiki.net/index.php/Ancilla_glitches
; archive: https://web.archive.org/web/20191104142903/https://alttp-wiki.net/index.php/Ancilla_glitches
; Note that as long as you don't use special memory locations designed
; for specific slots, you don't need to check which slot you're on.
; All the ones listed above are available for all 10 slots.

AncillaExt_Example: ; Subroutine called for every Example ancilla object
    ; We again have `X` set to the slot our object is in,
    ; so we can access the memory locations we set in
    ; the Add function, among other things.

    LDA $0C68, X : BNE .dontTerminate ; Each Example object will exist for 120 frames
        STZ $0C4A, X ; This will terminate the ancilla object
                     ; If you're wondering what's in $0C4A, X, it's the object's id,
                     ; and "0" means "no object."

    .dontTerminate
    ; Here, we will draw a random sprite above link.
    ; It has to be different but stay the same for each individual object,
    ; which is why we generated a number at the Add function, which we will
    ; now use to pick and draw the sprite.

    REP #$20

    LDA $20 : SEC : SBC $E8 ; Get link's Y coordinate on the screen
    SEC : SBC #$0010 : STA $00 ; $00 will be used as the sprite's Y coordinates

    LDA $22 : SEC : SBC $E2 ; Get link's X coordinate on the screen
    CLC : ADC #$0004 : STA $02 ; $02 will be used as the sprite's X coordinates

    SEP #$20

    PHX

    PHB : PHK : PLB
    LDA $0BF0, X : TAX ; Load up our random number so we can index our tables

    LDA .y_offset, X : CLC : ADC $00 : STA $00 ; Add Y offset (tables are below)
    LDA .x_offset, X : CLC : ADC $02 : STA $02 ; Add X offset

    LDY #$00 ; OAM Buffer index; since this is the sprite we will draw,
             ; it should be 0
    JSL Ancilla_SetSafeOam_XY_Long ; We can optionally use this function to write the
                                   ; x and y coordinates of our sprites to OAM. It
                                   ; reads $00 as x, $02 as y, and the `Y` register
                                   ; to index into the OAM buffer. The advantage
                                   ; of using this routine instead of doing it
                                   ; ourselves is that this will do a boundscheck
                                   ; for us, handling offscreen sprites.
                                   ;
                                   ; Side note: Ancilla_SetOam_XY_Long is
                                   ; similar to this routine but it doesn't
                                   ; handle offscreen object as well and it
                                   ; won't fix the bank pointer
                                   ; (and consequently will break if it was changed!)

    LDA .sprite, X ; Load character table information

    STA ($90), Y : INY ; write character table data to the OAM buffer.

    ; Same as above, with sprite properties
    LDA .properties, X : STA ($90), Y

    ; write final data to high bytes in OAM
    LDA .extended, X : STA ($92)

    ; Now, if the sprite has a bottom part, we draw it,
    ; otherwise we cleanup and end the routine
    LDA .has_bottom_sprite, X : BEQ .done

    ; Draw bottom sprite!
    LDY #$04 ; Starting at OAM buffer index 4 (add 4 for each sprite)
    LDA $00 : CLC : ADC #$08 : STA $00 ; We use the same coordinates
    JSL Ancilla_SetSafeOam_XY_Long     ; but shift y down a little

    LDA .bottom_sprite, X : STA ($90), Y : INY
    LDA .properties, X : STA ($90), Y
    LDA .extended, X : LDY #$01 : STA ($92), Y
    ; when setting $92, you add 1 per sprite,
    ; instead of 4. We can use the utility
    ; function AncillaExt_CalculateHiOamIndex(index)
    ; to generate a high index from a low index,
    ; or the macro %AncillaExt_CalculateHiOamIndex()
    ; if your index is dynamically generated;
    ; for the latter,  remember to push your `Y`
    ; register to the stack beforehand if you
    ; need it later!

    ; We're done!
    ; Setting values to ($90) with the appropriate index is
    ; enough to draw sprites into the game, the engine will
    ; handle the rest. If you're sure you did that correctly
    ; and the sprites are flickering or otherwise glitching,
    ; make sure you setup the values at AncillaMaxSpriteCount
    ; correctly for your ancilla object.

.done
    ; Cleanup
    PLB : PLX ; We must return `X` to its original state at the end of the routine
JML AncillaExt_Return ; End with this always! Since we arrived with a jump, we must jump
                      ; back to the original bank so it can return locally with an RTS.

; Sprites, in order:
; Big Magic, Apple, Heart, Fairy, Key, Bomb, Arrow, Rupee

.y_offset
    db   0,   0,   8,   0,   0,   0,   0,  0

.x_offset
    db   0,  -4,   0,  -4,   0,  -4,   0,  0

.sprite
    db $62, $E5, $29, $EA, $6B, $6E, $63, $0B

.properties
    db $28, $22, $22, $28, $28, $24, $24, $22

.extended
    db $00, $02, $00, $02, $00, $02, $00, $00

.has_bottom_sprite
    db $01, $00, $00, $00, $01, $00, $01, $01

.bottom_sprite
    db $72, $00, $00, $00, $7B, $00, $73, $1B


else
AncillaExt_AddExample:
RTL

AncillaExt_Example:
    STZ $0C4A, X
JML AncillaExt_Return
endif

