# Programming Languages Project 2 - Group 3
# [/] - Completed
# [X] - Attempted but not working
# [-] - Attempt missing

# Program displays a BNF Grammar for iZEBOT's meta-language psuedocode
#   Prompts user to enter an input string
#   Attemps a rightmost derivation on string
#       If successful :
#           [/]Notifys of completion 
#           Pause
#           [-]Generate and display parse tree
#           Pause
#           [-]Generate and Display PBASIC Program code
#           Pause
#           [-]Saves PBASIC Program code to IZEBOT.BSP
#           Pause
#           [/]Loop back from input string prompt
#       In unsuccessful :
#           [/]Stop Derivation and display error message
#           Pause
#           [/]Loop back from input string prompt
#   [/]Program terminates if when prompted for input string, "ABORT" is entered
#
# Additonal Goals:
#   [/] Error handling
#   [/] Pause

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

#-----------------------------------------------------------------------------------------------------------------------
import std/strutils

#global variable declarations
var
    # used to track history of derivations as a sequence
    derivationHistory: seq[string]
    # used to format left side of derivations
    derivationTemplate: seq[string]
    # used to change the current working non-terminal for decompositions
    derivationString = "ON <SET> OFF"
    format = "     	→	"
    # used to track current line count of derivation
    linecount: int = 0
    # errorCode = "f"

# pause() : void procedure to force a pause until enter is pressed
proc pause():void =
    echo "Please press enter to continue..."
    var throwaway:char = stdin.readChar()

#printBNF() : void function to just print BNF, done this way incase we want to add reprint functionality
proc printBNF():void=
    echo """ ======================BNF Grammar for iZEBOT======================
     <LANG>	→	ON  <PROGRAM> OFF
     <PROGRAM>	→	<SET>
     <SET>		→	<KEY_EXP>- | <SET> <KEY_EXP>- 
     <KEY_EXP>	→	key <KEY_ASN>
     <KEY_ASN>	→	<KEY> = <MOVE>
     <KEY>		→	A | B | C | D
     <MOVE>	→	GO | RV | LF | RT | AC | CW
     """
#-----------------------------------------------------------------------------------------------------------------------
# parseKey() : bool procedure to 
proc parseKey(inputString: string): bool =
    case inputString:
    of "A", "a", "B", "b", "C", "c", "D", "d":
        linecount += 1
        derivationString = derivationString.replace("<KEY>", inputString)
        derivationHistory.add($linecount & format & derivationString)
        return true
    else:
        echo "[",inputString,"] is a unrecognized key; key must be one of the following: 'A/a', 'B/b', 'C/c' or 'D/d'"
        pause()
        return false
# parseMove() : bool procedure to 
proc parseMove(inputString: string): bool =
    var inputString = inputString.strip()
    var detailsMove = inputString.split("=")
    let move = detailsMove[detailsMove.len - 1].strip()
    let key = detailsMove[0].strip()

    case move:
    of "GO", "RV", "LF", "RT", "AC", "CW":
        linecount += 1
        derivationString = derivationString.replace("<MOVE>", move)
        derivationHistory.add($linecount & format & derivationString)
    else:
        echo "[",move,"] is a unrecognized movement ; move must be one of the following: 'GO', 'RV', 'LF', 'RT', 'AC', or 'CW'"
        pause()
        return false

    # let x = parseKey(detailsMove[0])
    if parseKey(key):
        return true
    else:
        return false
# parseKeyASN() : bool procedure to 
proc parseKeyASN(inputString: string): bool =
    var inputString = inputString.strip()
    linecount += 1
    derivationString = derivationString.replace("<KEY_ASN>", "<KEY> = <MOVE>")
    derivationHistory.add($linecount & format & derivationString)

    let newInputString = inputString.replace("key", "").strip()
    # let x = parseMove(newInputString)

    if parseMove(newInputString):
        return true
    else:
        return false
# parseKeyEXP() : bool procedure to 
proc parseKeyEXP(inputString: string): bool =
    var inputString = inputString.strip()
    linecount += 1    
    derivationString = derivationString.replace("<KEY_EXP>", "key <KEY_ASN>")
    derivationHistory.add($linecount & format & derivationString)

    if not inputString.startsWith("key"):
        echo "[",inputString,"] is a unrecognized key assignment syntax; must start with 'key'"
        pause()
        return false
    
    if not inputString.contains("="):
        echo "[",inputString,"] is a unrecognized key assignment syntax; must contain '='"
        pause()
        return false

    # let x = parseKeyASN(inputString)

    if parseKeyASN(inputString):
        return true
    else:
        return false
# parseProgram() : bool procedure to 
proc parseProgram(inputString: string): bool = 
    if not inputString.contains("-"):
        echo "[",inputString,"] is a unrecognized key expression syntax; move must end with '-'"
        pause()
        return false

    var segments = inputString.split("-")
    setLen(segments, len(segments)-1)

    # var length = segments.len

    for i, item in segments:
        if segments.len > 1 :
            if segments.len - 1 == i :
                derivationString = derivationString.replace("<SET>", "<KEY_EXP>-")
            else:
                derivationString = derivationString.replace("<SET>", "<SET> <KEY_EXP>-")
        else:
            derivationString = derivationString.replace("<SET>", "<KEY_EXP>-")
        
        derivationHistory.add($linecount & format & derivationString)

        if derivationString.contains("<KEY_EXP>-"):
            var rightMostString = segments[segments.len - i - 1]
            # let x = parseKeyEXP(rightMostString)
            if not parseKeyEXP(rightMostString):
                return false
    
    return true
# startDerivation() : bool procedure to 
proc startDerivation(inputString: string): bool =
    var inputString = inputString.strip()
    #[
    let checkON     = inputString.find("ON")
    let checkOFF    = inputString.find("OFF")
    
    if checkON != 0:
        echo "ERROR: Start of statment must be ON*****"
        return errorCode
    elif inputString.len - checkOFF != 3:
        echo "ERROR: End of statment must be OFF*****"
        return errorCode ]#

    if not inputString.startsWith("ON"):
        echo "[",inputString,"] is a unrecognized input string; must begin with 'ON'"
        pause()
        return false
    elif not inputString.endsWith("OFF"):
        echo "[",inputString,"] is a unrecognized input string; must end with 'OFF'"
        pause()
        return false
    
    derivationHistory.add("<LANG>	→	ON <PROGRAM> OFF")
    linecount += 1
    derivationHistory.add($linecount & "     	→	ON <SET> OFF")
    derivationTemplate.add("ON")
    derivationTemplate.add("OFF")
    inputString = strip(inputString)
    var next = inputString.replace("ON", "").replace("OFF", "").strip()
    
    if parseProgram(next):
        return true
    else:
        return false
#-----------------------------------------------------------------------------------------------------------------------
#PBASIC_GEN(instruct) - function to generate PBASIC code

proc PBASIC_GEN(instruct:string): void =
    echo "\nBegining generation of PBASIC Program Code for Robo-Stamp 2P"

#-----------------------------------------------------------------------------------------------------------------------
# main() : driver function
proc main() =
    echo "Program was compiled using Nim Version: ",system.NimVersion
    printBNF()
    var inputString = ""
    while true:
        linecount = 0
        echo "\nPlease enter a string. Enter 'ABORT' to exit:"
        inputString = readLine(stdin)

        var noWhiteSpace = inputString.strip()

        if noWhiteSpace == "ABORT":
            echo "\nExiting Program"
            break
        else:
            var check = startDerivation(noWhiteSpace)

            if check:
                echo "→→→→→→→→→→|Rightmost Derivation|→→→→→→→→→→"
                for items in derivationHistory:
                    echo items
                echo "\nDerivation Successful!"
                pause()
                # PrintParseTree()
                echo noWhiteSpace
                PBASIC_GEN(noWhiteSpace)
                pause()
                    
            derivationHistory = @[]
            linecount += 1
            derivationString = "ON <SET> OFF"

when isMainModule:
    main()