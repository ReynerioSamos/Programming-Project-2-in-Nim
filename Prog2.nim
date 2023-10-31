# Programming Languages Project 2 - Group 3

# Program displays a BNF Grammar for iZEBOT's meta-language psuedocode
#   Prompts user to enter an input string
#   Attemps a rightmost derivation on string, showing line by line sentential form
#       If successful :
#           Notifys of completion
#           Pause
#           Generate and display parse tree
#           Pause
#           Generate and display
#           Pause
#           Generate and Display PBASIC Program code
#           Pause
#           Saves PBASIC Program code to IZEBOT.BSP
#           Pause
#           Loop back from input string prompt
#       In unsuccessful :
#           Stop Derivation and display error message
#           Pause
#           Loop back from input string prompt
#   Program terminates if when prompted for input string, "ABORT" is entered

# BNF GRAMMAR :
# <LANG>    →   ON <PROGRAM> OFF
# <PROGRAM> →   <SET>
# <SET>     →   <KEY_EXP>- | <SET> <KEY_EXP>-
# <KEY_EXP> →   key <KEY_ASN>
# <KEY_ASN> →   <KEY> = <MOVE>
# <KEY>     →   A | B | C | D
# <MOVE>    →   GO | RV | LF | RT | AC | CW

# <MOVE> Definitions : 
# GO := Move forward
# RV := Move backwards
# LF := Turn left
# RT := Turn right
# AC := Spin left
# CW := Spin right
#[
    Group 3 Members:
        Javier Castellanos  - 2020253542
        Tamika Chen         - 2019120211
        Reynerio Samos      - 2018119235
        Cahlil Tillet       - 2021154337
        Joshua Richards     - 2017115716
]#
# Program was writtin using Nim Compiler Version 2.0.0 [Linux: amd64]


# printBNF() - Just a helper function to print the BNF Grammar whenever we want
proc printBNF():
    echo "BNF GRAMMAR:"
    echo "<LANG>    →   ON <PROGRAM> OFF"
    echo "<PROGRAM> →   <SET>"
    echo "<SET>     →   <KEY_EXP>- | <SET> <KEY_EXP>-"
    echo "<KEY_EXP> →   key <KEY_ASN>"
    echo "<KEY_ASN> →   <KEY> = <MOVE>"
    echo "<KEY>     →   A | B | C | D"
    echo "<MOVE>    →   GO | RV | LF | AC | CW"
end

# pause() - simple little workaround to pause until key is entered
proc pause()
    read(stdin)
end

# RightDeriv() - Driver function to call all the different Decomposition functions to acheive rightmost derivation
proc RightDeriv(str :  string): bool
    echo "\nDeriving : [", str, "]"
    if LANG(str) == true:
        return true
    else:
        return false
    end
end

#  LANG() - boolean function to see if successful <LANG> decomposition is met
#           checks for 'ON' and 'OFF' lexemes
proc LANG(str : string): bool
    str = str.trim(str)
    if str.startsWith("ON") & str.endsWith("OFF"):
        line_count++
        global_BNF = "<LANG>    → ON <PROGRAM> OFF"
        echo line_count, " ", global_BNF
        str = str.replace("ON", "")
        str = str.replace("OFF","")
        str = str.trim(str)
        #PROGRAM(str)
    else: 
        echo "Error: [", str, "] Invalid <LANG>"
        echo "Sentence must begin with ON AND end in OFF"
        echo "  e.g. ON [something]- OFF"
        return false
    end
end

#  PROGRAM() - boolean function to see if successful <PROGRAM> decomposition is met
#              decomposes into <SET> further if previous is met, and effective beginning of derivation
proc PROGRAM(str : string): bool

end

#  SET() - boolean function to see if successful <SET> decomposition is met
#          checks to see if it's a single <KEY_EXP> decomposition or recursive <SET> <KEY_EXP> decomposition
#          also checks for '-' lexeme delimiter to see if mutliple keys are being programmed
proc SET(str : string):bool

end

#  KEY_EXP() - boolean function to see if successful <KEY_EXP> decomposition is met
#              checks for 'key' lexeme to ensure a key is being manipulated
proc KEY_EXP(str : string):bool

end

#  KEY_ASN() - boolean function to see if successful <KEY_ASN> decomposition is met
#              checks for '=' lexeme (notifying assignment of key to move)
proc KEY_ASN(str : string):bool

end

#  KEY() - boolean function to see if successful <KEY> decomposition is met
#          checks to see if valid key on the remote is being assigned
proc KEY(str : string):

end

#  MOVE() - boolean function to see if successful <MOVE> decomposition is met
#           checks to see if valid move in list is being assigned to a key on remote
proc MOVE(str : string):bool

end
# printParseTree() -

# PBASIC_ProgramGen() -

# print_PBASIC_ProgramGen() -

# main() - driver procedure and 1st procedure called for this nim program
# global variable declarations

# sent is variable used to 
var global_BNF : string = ""
var line_count : int = 0

proc main():
    printBNF()
    var input : string = ""
    while input != "ABORT"
        sent = ""
        line_count = 0
        echo "Please enter an input string to begin Rightmost derivation (or enter ""ABORT"" to leave the program) :"
        input = readLine(stdin)
        #[if RightDeriv = true
            echo "Successful derivation!"
            
            end
        ]#
        end   
end