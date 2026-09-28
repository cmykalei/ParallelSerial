# COMPX203 Exercise 3, Question 1
# Program transmits the lowercase, then uppercase alphabet to Serial Port 2

.text
.global main                # Entry point main is global

main: 
    add   $2, $0, $0        # Set an index counter for the alphabet characters

loop:
    lw    $13, alphabet($2) # Get the next character to transmit
    beqz  $13, endloop      # Branch to end if there are no more characters

checktds:
    lw    $12, 0x71003($0)  # Get the contents of Status Register for Serial Port 2
    andi  $12, $12, 0x2     # Get the TDS bit, check the value
    beqz  $12, checktds     # If TDS '0' check again

    sw    $13, 0x71000($0)  # Save the character into the TDR bit
    addi  $2, $2, 1         # Increment the index counter

    j loop                  # Jump to send loop to get the next character

endloop:                    # Called from send loop when alphabet has been 
    jr $ra


.data                       # Data contains asciiz word of alphabet characters
    alphabet: 
          .asciiz "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
