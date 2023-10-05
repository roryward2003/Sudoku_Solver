  .syntax unified
  .cpu cortex-m3
  .fpu softvfp
  .thumb
  
  .global  countInRow
  .global  countInCol
  .global  countIn3x3
  .global  nextInCell
  .global  solveSudoku


@ countInRow subroutine
@ Count the number of occurrences of a specified value in one row of a Sudoku
@   grid.
@
@ Parameters:
@   R0: start address of 2D array representing the Sudoku grid
@   R1: row number
@   R2: value to count
@ Return:
@   R0: number of occurrences of value in specified row
countInRow:
  PUSH    {R4-R9, LR}             @ push registers
  MOV     R4, R0                  @ startAddress
  MOV     R5, R1                  @ rowNumber
  MOV     R6, R2                  @ valueToCount
  MOV     R0, #0

  MOV     R7, #9                  @ mulTemp
  MUL     R5, R5, R7              @ array[rowNumber][n]
.LFor1_1:
  CMP     R7, #0                  @ while(i>0)
  BLE     .LeFor1_1               @ {

  LDRB    R8, [R4, R5]            @    temp = [rowNumber][n]
  CMP     R8, R6                  @    
  BNE     .LeIf1_1                @    if(temp==value)
  ADD     R0, R0, #1              @       valueCount+=1
.LeIf1_1:

  ADD     R5, R5, #1              @    n+=1
  SUB     R7, R7, #1              @    i-=1
  B       .LFor1_1                   @ }
.LeFor1_1:

  POP     {R4-R9, PC}             @ pop registers



@ countInCol subroutine
@ Count the number of occurrences of a specified value in one column of a Sudoku
@   grid.
@
@ Parameters:
@   R0: start address of 2D array representing the Sudoku grid
@   R1: column number
@   R2: value to count
@ Return:
@   R0: number of occurrences of value in specified column
countInCol:
  PUSH    {R4-R12, LR}            @ push registers
  MOV     R4, R0                  @ startAddress
  MOV     R5, R1                  @ colNumber
  MOV     R6, R2                  @ valueToCount
  MOV     R0, #0

  MOV     R7, #9                  @ i = 9
.LFor2_1:
  CMP     R7, #0                  @ while(i>0)
  BLE     .LeFor2_1               @ {

  LDRB    R8, [R4, R5]            @    temp = [n][colNumber]
  CMP     R8, R6                  @    
  BNE     .LeIf2_1                @    if(temp==value)
  ADD     R0, R0, #1              @       valueCount+=1
.LeIf2_1:
  ADD     R5, R5, #9              @    n+=9
  SUB     R7, R7, #1              @    i-=1
  B       .LFor2_1                   @ }
.LeFor2_1:

  POP     {R4-R12, PC}            @ pop registers



@ countIn3x3 subroutine
@ Count the number of occurrences of a specified value in one 3x3 subgrid
@   of a Sudoku grid.
@
@ Parameters:
@   R0: start address of 2D array representing the Sudoku grid
@   R1: row number of any row in the 3x3 subgrid
@   R2: column number of any column in the 3x3 subgrid
@   R3: value to count
@ Return:
@   R0: number of occurrences of value in specified 3x3 subgrid
countIn3x3:
  PUSH    {R4-R12, LR}
  MOV     R4, R0                  @ startAddress
  MOV     R8, #3                  @ divTemp = 3
  UDIV    R5, R1, R8              @ rowNumber/3
  MUL     R5, R5, R8              @ rowNumber*3
  UDIV    R6, R2, R8              @ colNumber/3
  MUL     R6, R6, R8              @ colNumber*3
  MOV     R7, R3                  @ value
  MOV     R11, #9
  MOV     R0, #0

  MOV     R8, #0                  @ for(int i=0; i<)
.LFor3_1:
  CMP     R8, #3
  BGE     .LeFor3_1

  MOV     R9, #0
.LFor3_2:
  CMP     R9, #3
  BGE     .LeFor3_2

  MLA     R12, R5, R11, R6        @ offset = (rowNumber*9) + colNumber
  ADD     R12, R12, R9            @ offset += n

  LDRB    R10, [R4, R12]
  CMP     R10, R7
  BNE     .LeIf3_1
  ADD     R0, R0, #1
.LeIf3_1:

  ADD     R9, R9, #1
  B       .LFor3_2
.LeFor3_2:

  ADD     R5, R5, #1
  ADD     R8, R8, #1
  B       .LFor3_1
.LeFor3_1:

  POP     {R4-R12, PC}



@ nextInCell subroutine
@ Find the next higher valid value that can be placed in a specified cell in a
@   Sudoku grid.
@
@ Parameters:
@   R0: start address of 2D array representing the Sudoku grid
@   R1: row number of cell
@   R2: column number of cell
@ Return:
@   R0: next higher value or 0 if there is no valid higher value
nextInCell:
  PUSH    {R4-R12, LR}
  MOV     R4, R0
  MOV     R5, R1
  MOV     R6, R2
  MOV     R7, #9

  MLA     R8, R5, R7, R6         @ offset
  LDRB    R9, [R4, R8]           @ currentValue = [startAddress+offset]

.LFor4_1:
  ADD     R9, R9, #1             @ currentValue += 1
  CMP     R9, #10
  BLT     .LeIf4_1
  MOV     R0, #0
  B       .LeFor4_1
.LeIf4_1:    

  MOV     R0, R4
  MOV     R1, R5
  MOV     R2, R9
  BL      countInRow
  CMP     R0, #1
  BGE     .LFor4_1

  MOV     R0, R4
  MOV     R1, R6
  MOV     R2, R9
  BL      countInCol
  CMP     R0, #1
  BGE     .LFor4_1

  MOV     R0, R4
  MOV     R1, R5
  MOV     R2, R6
  MOV     R3, R9
  BL      countIn3x3
  CMP     R0, #1
  BGE     .LFor4_1

  MOV     R0, R9
.LeFor4_1:

  POP     {R4-R12, PC}



@ solveSudoku subroutine
@ Solve a Sudoku puzzle.
@
@ Parameters:
@   R0: start address of 2D array representing the Sudoku grid
@   R1: row number of next cell to modify
@   R2: column number of next cell to modify
@ Return:
@   R0: 1 if a solution was found, zero otherwise
solveSudoku:
  PUSH    {R4-R12, LR}               @ push
  MOV     R4, R0                     @ startAddress
  MOV     R5, R1                     @ row
  MOV     R6, R2                     @ col
  MOV     R12, #9                    @ mulTemp = 9

.LIf5_1:
  CMP     R5, #9                     @ if(row >= 9)
  BLT     .LElse5_1                  @    result = 1
  MOV     R11, #1                    @ 
  MOV     R0, #1                     @    B end
  B       .LeElse5_1                 @ else
.LElse5_1:
  MOV     R11, #0                    @    result = 0
  ADD     R8, R6, #1                 @    nextCol = col+1
  MOV     R7, R5                     @    nextRow = row
.LIf5_2:
  CMP     R8, #9                     @    if(nextCol >= 9)
  BLT     .LeIf5_2                   @ 
  MOV     R8, #0                     @       nextCol = 0
  ADD     R7, R7, #1                 @       nextRow += 1
.LeIf5_2:

  // Get the value of the current cell
  MLA     R9, R5, R12, R6            @    currentIndex = (row*9)+col
  LDRB    R10, [R4, R9]              @    current = [startAddress + currentIndex]

  MOV     R12, #0                    @    nextOption = 0

.LIf5_3:
  CMP     R10, #0                    @    if(current != 0)
  BEQ     .LElse5_3                  @       result = solveSudoku(startAddress, nextRow, nextCol)
  MOV     R0, R4                     @ 
  MOV     R1, R7                     @ 
  MOV     R2, R8                     @ 
  BL      solveSudoku                @
  MOV     R11, R0                    @    else
  B       .LeElse5_3
.LElse5_3:
  MOV     R0, R4                     @       nextOption = nextInCell(startAddress, row, col)
  MOV     R1, R5                     @ 
  MOV     R2, R6                     @ 
  BL      nextInCell                 @ 
  MOV     R12, R0                    @

.LWhile5_1:
  CMP     R12, #0                    @       while(nextOption!=0 && result!=1)
  BEQ     .LeWhile5_1                @          
  CMP     R11, #1                    @ 
  BEQ     .LeWhile5_1                @ 

  STRB    R12, [R4, R9]              @          [startAddress + currentIndex] = nextOption

  MOV     R0, R4                     @          result = solveSudoku(startAddress, nexRow, nextCol)
  MOV     R1, R7                     @          
  MOV     R2, R8                     @          
  BL      solveSudoku                @          
  MOV     R11, R0                    @          

  MOV     R0, R4                     @          nextOption = nextInCell(startAddress, row, col)
  MOV     R1, R5                     @ 
  MOV     R2, R6                     @ 
  BL      nextInCell                 @ 
  MOV     R12, R0                    @ 
  B       .LWhile5_1                 @ 
.LeWhile5_1:

.LIf5_4:
  CMP     R11, #0                    @       if(result == 0)
  BNE     .LeIf5_4                   @ 
  STRB    R11, [R4, R9]              @          [startAddress + currentIndex] = 0

.LeIf5_4:
.LeElse5_3:
.LeElse5_1:

  MOV     R0, R11

  POP     {R4-R12, PC}

  .end