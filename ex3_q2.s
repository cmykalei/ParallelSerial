# COMPX203 Exercise 3, Question 2
# Program receives the characters from Serial Port 1, then checks between 'a' and 'z'
# Transmits a '*' back to Serial Port 1 if not, or sends back the character if it is

.text
.global main                # Entry point main is global

main: 
    lw    $7, a($0)         # Loads the ascii characters into registers for checking
    lw    $8, z($0)
    lw    $9, star($0)

checkrdr:
    lw    $12, 0x70003($0)  # Get the contents of Status Register for Serial Port 1
    andi  $12, $12, 0x1     # Check the RDR bit
    beqz  $12, checkrdr     # If RDR is '0' loop to check status again

checktds:
    lw    $13, 0x70003($0)  # Get the contents of Status Register for Serial Port 1
    andi  $13, $13, 0x2     # Check the TDR bit
    beqz  $13, checktds     # If TDS is '0' loop to check status again

getchar:
    lw    $11, 0x70001($0)  # Load the received character into $1
    beqz  $11, getchar      # Go back to check receive again if no character
    
    sge   $2, $11, $7
    sle   $3, $11, $8
    and   $1, $3, $2 
    beqz  $1, printstar

    sw    $11, 0x70000($0)  # Store character from $2 into TDR
    j main

printstar:
    sw    $9, 0x70000($0)
    j main                  # Jump back to check status to receive next character

.data                       # Data contains asciiz word of alphabet characters
    star: 
         .asciiz "*"
    a: 
         .ascii "a"
    z: 
         .ascii "z"
