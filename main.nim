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
#           [X]Generate and display parse tree
#           Pause
#           [/]Generate and Display PBASIC Program code
#           Pause
#           [/]Saves PBASIC Program code to IZEBOT.BSP
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

    max_width:int = 8

    subr_GO, subr_RV, subr_LF, subr_RT, subr_AC, subr_CW : bool = false

    A_asn : (bool, string)
    B_asn : (bool, string)
    C_asn : (bool, string)
    D_asn : (bool, string)



let 
    left: string = "/"
    mid: string = "|"
    right: string = """\"""
    w_unit: int = 6
    single_space = " "

    # errorCode = "f"

proc match_keytomove(key : string, subroutine : string):void =
    case key:
    of "A", "a":
        A_asn = (true,subroutine)
    of "B", "b":
        B_asn = (true,subroutine)
    of "C", "c":
        C_asn = (true,subroutine)
    of "D", "d":
        D_asn = (true,subroutine)
    else:
        return

# pause() : void procedure to force a pause until enter is pressed
proc pause():void =
    echo "Please press enter to continue..."
    var throwaway:char
    throwaway = stdin.readChar()
    return

#printBNF() : void function to just print BNF, done this way incase we want to add reprint functionality
proc printBNF():void=
    echo """======================BNF Grammar for iZEBOT======================
<LANG>	    →	ON  <PROGRAM> OFF
<PROGRAM>	→	<SET>
<SET>		→	<KEY_EXP>- | <SET> <KEY_EXP>- 
<KEY_EXP>	→	key <KEY_ASN>
<KEY_ASN>	→	<KEY> = <MOVE>
<KEY>		→	A | B | C | D
<MOVE>	    →	GO | RV | LF | RT | AC | CW
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
    of "GO":
        linecount += 1
        subr_GO = true
        match_keytomove(key,"Forward")
        derivationString = derivationString.replace("<MOVE>", move)
        derivationHistory.add($linecount & format & derivationString)
    of "RV":
        linecount += 1
        subr_RV = true
        match_keytomove(key,"Backward")
        derivationString = derivationString.replace("<MOVE>", move)
        derivationHistory.add($linecount & format & derivationString)
    of "LF":
        linecount += 1
        subr_LF = true
        match_keytomove(key,"TurnLeft")
        derivationString = derivationString.replace("<MOVE>", move)
        derivationHistory.add($linecount & format & derivationString)
    of "RT":
        linecount += 1
        subr_RT = true
        match_keytomove(key,"TurnRight")
        derivationString = derivationString.replace("<MOVE>", move)
        derivationHistory.add($linecount & format & derivationString)
    of "AC": 
        linecount += 1
        subr_AC = true
        match_keytomove(key,"SpinLeft")
        derivationString = derivationString.replace("<MOVE>", move)
        derivationHistory.add($linecount & format & derivationString)
    of "CW":
        linecount += 1
        subr_CW = true
        match_keytomove(key,"SpinRight")
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
    var 
        fileName:string = "IZEBOT.BSP"
#-------Provided Code Blocks---------------------------------------------------------------------------------------------
        head_bl:string = """
'{$STAMP BS2p}
'{$PBASIC 2.5}
KEY        VAR     Byte
Main:      DO
             SERIN 3,2063,250,Timeout, [KEY]
"""
        foot1_bl:string = """
           LOOP
Timeout:   GOSUB Motor_OFF
           GOTO Main
'+++++ Movement Procedure ++++++++++++++++++++++++++++++
"""
        foot2_bl:string = """
Motor_OFF: LOW  13  : LOW 12 : LOW  15 : LOW 14 : RETURN
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++
"""
#-------Subroutine blocks by Defined movement---------------------------------------------------------------------------
        forward:string = """
Forward:   HIGH 13  : LOW 12 : HIGH 15 : LOW 14 : RETURN
"""
        backward:string = """
Backward:  HIGH 12  : LOW 13 : HIGH 14 : LOW 15 : RETURN
"""
        turnleft:string = """
TurnLeft:  HIGH 13  : LOW 12 : LOW  15 : LOW 14 : RETURN
"""
        turnright:string = """
TurnRight: LOW  13  : LOW 12 : HIGH 15 : LOW 14 : RETURN
"""
        spinleft:string = """
SpinLeft:  HIGH 13  : LOW 12 : HIGH 14 : LOW 15 : RETURN
"""
        spinright:string = """
SpinRight: HIGH 12  : LOW 13 : HIGH 15 : LOW 14 : RETURN
"""
#-------Body Code Block Generation--------------------------------------------------------------------------------------
    var body_bl:string = ""
    if A_asn[0]:
        body_bl = body_bl & """
             IF KEY = "A" OR KEY = "a" THEN GOSUB """  & A_asn[1] & "\n"
    if B_asn[0]:
        body_bl = body_bl & """
             IF KEY = "B" OR KEY = "b" THEN GOSUB """  & B_asn[1] & "\n"
    if C_asn[0]:
        body_bl = body_bl & """
             IF KEY = "C" OR KEY = "c" THEN GOSUB """  & C_asn[1] & "\n"
    if D_asn[0]:
        body_bl = body_bl & """
             IF KEY = "D" OR KEY = "d" THEN GOSUB """  & D_asn[1] & "\n"

#-------Subroutine Code Block Generation---------------------------------------------------------------------------------
    var sub_bl:string
    if subr_GO:
        sub_bl = sub_bl & forward
    if subr_RV:
        sub_bl =  sub_bl & backward
    if subr_LF:
        sub_bl = sub_bl & turnleft
    if subr_RT:
        sub_bl = sub_bl & turnright
    if subr_AC:
        sub_bl = sub_bl & spinleft
    if subr_CW:
        sub_bl = sub_bl & spinright
#-------Entire PBASIC Program Code and fileGeneration--------------------------------------------------------------------
    #Create a blank file with name
    writeFile(fileName,"")
    #opens file and begin writing stream
    let file = open(fileName, fmWrite)
    # header is static, goes here
    write(file,head_bl)
    # body generated code goes here
    write(file,body_bl)
    write(file,foot1_bl)
    # subroutine generated code goes here
    write(file,sub_bl)
    write(file,foot2_bl)
    #close file
    close(file)

    #reading and displaying the file on screen
    let readfile = readFile(fileName)
    echo "\n Displaying IZEBOT.BSP file contents :\n"
    echo readfile

proc parseTreeMOVE(input:string): void =
    var 
        component = "<MOVE>"
        input = input.strip()
        half_max = max_width div 2
        left_space = repeat(single_space,(half_max * w_unit))
        right_space = repeat(single_space,(half_max * w_unit))
        mid_component = repeat(single_space,(len(component) div 2)) & mid & repeat(single_space,(len(component) div 2))
    
    echo left_space,single_space, input, right_space

proc parseTreeKEY(input:string): void =
    max_width -= 1
    var 
        component = "<KEY>"
        input = input.strip()
        half_max = max_width div 2
        left_space = repeat(single_space,(half_max * w_unit)+1)
        right_space = repeat(single_space,(half_max * w_unit))
        mid_component = repeat(single_space,(len(component) div 2)) & mid & repeat(single_space,(len(component) div 2))
    
    echo left_space, input

proc parseTreeKEY_ASN(input: string): void =
    var
        component: string = "<KEY>=<MOVE>"
        left_sub_comp : string = "<KEY>="
        left_mid_comp = repeat(single_space,(len(left_sub_comp) div 2)) & left & repeat(single_space,(len(left_sub_comp) div 2))
        right_sub_comp: string = "<MOVE>"
        right_mid_comp = repeat(single_space,(len(right_sub_comp) div 2)) & right & repeat(single_space,(len(right_sub_comp) div 2))
        input = input.strip()
        half_max = max_width div 2
        left_space = repeat(single_space,(half_max * w_unit))
        right_space = repeat(single_space,(half_max * w_unit))
        
    echo left_space, left_mid_comp, right_mid_comp, right_space
    echo left_space, component, right_space
    max_width += 2

    let input_split = split(input, "=", 2)
    parseTreeMOVE(input_split[1])
    parseTreeKEY(input_split[0])

proc parseTreeKEY_EXP(input:string ): void =
    var
        component: string = "key <KEY_ASN>"
        mid_component = repeat(single_space,(len(component) div 2)) & mid & repeat(single_space,(len(component) div 2))
        input = input.strip()
        half_max = max_width div 2
        left_space = repeat(single_space,(half_max * w_unit))
        right_space = repeat(single_space,(half_max * w_unit))

    input = replace(input,"key","")

    echo left_space, mid_component, right_space
    echo left_space, component, right_space
    echo left_space, mid_component, right_space

    parseTreeKEY_ASN(input)

proc parseTreeSET(input: string) : void =
    if count(input , "-") == 1:
        max_width -= 2
        var
            component: string = "<KEY_EXP>-"
            mid_component = repeat(single_space,(len(component) div 2)) & mid & repeat(single_space,(len(component) div 2))
            input = input.strip
            half_max = max_width div 2
            left_space = repeat(single_space,(half_max * w_unit))
            right_space = repeat(single_space,(half_max * w_unit))

        echo left_space, component, right_space
        echo left_space, mid_component, right_space
        max_width += 2
        parseTreeKEY_EXP(input)
    
    elif count(input, "-") > 1:
        max_width -= 4
        var
            component: string = "<SET> <KEY_EXP>-"
            left_sub_comp : string = "<SET>"
            left_mid_comp = repeat(single_space,(len(left_sub_comp) div 2)) & left & repeat(single_space,(len(left_sub_comp) div 2))
            right_sub_comp: string = "<KEY_EXP>-"
            right_mid_comp = repeat(single_space,(len(right_sub_comp) div 2)) & right & repeat(single_space,(len(right_sub_comp) div 2))
            half_max = max_width div 2
            left_space = repeat(single_space,(half_max * w_unit))
            right_space = repeat(single_space,(half_max * w_unit))
        
        echo left_space, left_mid_comp, right_mid_comp, right_space
        echo left_space, component, right_space

        max_width += 2 * count(input, "-")
        let input_split = split(input, "-", 2)
        parseTreeKEY_EXP(input_split[1])
        parseTreeSET(input_split[0])


proc parseTreeLANG(input: string): void =
    var
        component: string = "ON <PROGRAM> OFF"
        mid_component = repeat(single_space,(len(component) div 2)) & mid & repeat(single_space,(len(component) div 2))
        input = input.strip()
        half_max = max_width div 2
        left_space = repeat(single_space,(half_max * w_unit))
        right_space = repeat(single_space,(half_max * w_unit))

    input = replace(input,"ON","")
    input = replace(input,"OFF","")

    echo left_space, component, right_space
    echo left_space, mid_component, right_space

    max_width += 2

    component = "<SET>"
    mid_component = repeat(single_space,(len(component) div 2)) & mid & repeat(single_space,(len(component) div 2))
    input = input.strip()
    half_max = max_width div 2
    left_space = repeat(single_space,(half_max * w_unit))
    right_space = repeat(single_space,(half_max * w_unit))

    echo left_space, component, right_space
    echo left_space, mid_component, right_space
    max_width += 2
    parseTreeSET(input)

proc PrintParseTree(input: string): void =
    var 
        component = "<LANG>"
        input = input.strip()
        half_max = max_width div 2
        left_space = repeat(single_space,(half_max * w_unit))
        right_space = repeat(single_space,(half_max * w_unit))
        mid_component = repeat(single_space,(len(component) div 2)) & mid & repeat(single_space,(len(component) div 2))
    
    echo left_space , component , right_space
    echo left_space,mid_component,right_space

    parseTreeLANG(input)
    return

#-----------------------------------------------------------------------------------------------------------------------
# main() : driver function
proc main() =
    echo "Program was compiled using Nim Version: ",system.NimVersion
    printBNF()
    var inputString = ""
    while true:
        # reinitializing globals for next derivation
        linecount = 0
        A_asn = (false, "")
        B_asn = (false, "")
        C_asn = (false, "")
        D_asn = (false, "")
        subr_AC = false 
        subr_CW = false 
        subr_GO = false
        subr_LF = false 
        subr_RT = false
        subr_RV = false
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
                PrintParseTree(noWhiteSpace)
                pause()
                echo noWhiteSpace
                PBASIC_GEN(noWhiteSpace)
                pause()
                    
            derivationHistory = @[]
            linecount += 1
            derivationString = "ON <SET> OFF"

when isMainModule:
    main()
