# COMPX203 Exercise 3, Question 3
# Program reads input from the push buttons and switches from the parallel port
# If the second button in bit 1 was pushed then flips the value of the switches
# Exits program if the third button in bit 2 was pushed or if more than one was pushed
# Otherwise sends the current value of the switches to the ssd's
.text
.global main
main:
    subui $sp, $sp, 1       # Push block of 1 on the stack
    sw    $ra, 0($sp)       # Save previous return address

read:    
    lw    $13, switches($0) # Put the value from the switch register in $13
    lw    $12, buttons($0)  # Put the value from the push register in $12
    beqz  $12, read

    andi  $9, $12, 0x1      # Store '1' in register $9 only if button 0 pushed
    andi  $8, $12, 0x2      # Store '2' in register $8 only if button 1 pushed
    andi  $7, $12, 0x3      # Store '3' in register $7 only if button 2 pushed
    bnez  $7, exit          # Exit program if button 2 was pushed

    add   $3, $9, $8        # Add the sum of remaining push button values to $3
    seqi  $1, $3, 0x3       # Set $1 to '1' if the sum of values is 011
    bnez  $1, exit          # Exit program if both button 0 and 1 where pushed

    beqz  $9, write         # If button 0 was pushed, then branch straight to write ssd's
    xor   $13, $13, $13     # If not, invert the switch values, then write

write:
    sw    $13, lrssd($0)    # Write the value to the ssd's
    srli  $13, $13, 4
    sw    $13, llssd($0)
    srli  $13, $13, 4
    sw    $13, urssd($0)
    srli  $13, $13, 4
    sw    $13, ulssd($0)
    srli  $13, $13, 4

    j read                  # Jump back to read the next inputs

exit:
    lw    $ra, 0($sp)
    addui $sp, $sp, 1
    jr $ra  

.equ buttons,   0x73001     # Variables to store the adresses of device registers
.equ switches,  0x73000
.equ control,   0x73009
.equ lrssd,     0x73009
.equ llssd,     0x73008
.equ urssd,     0x73007
.equ ulssd,     0x73006




