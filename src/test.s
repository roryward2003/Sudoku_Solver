  .syntax unified
  .cpu cortex-m3
  .fpu softvfp
  .thumb

  .global  Init_Test
  .global  Main
  .global  testGrid

@
@ Main
@
@ An implementation of Main to test each of our subroutines
@ You should "comment out" all but one subroutine call
@   to test individual subroutines as you develop them.
@
@ Modify the tests to suit your needs.
@
Main:

  PUSH  {R4-R12, LR}

  @ LDR   R0, =testGrid
  @ LDR   R1, =2        @ row number
  @ LDR   R2, =5        @ value to look for
  @ BL    countInRow    @ countInRow(grid, row, value)

  @ LDR   R0, =testGrid
  @ LDR   R1, =8        @ row number
  @ LDR   R2, =9        @ value to look for
  @ BL    countInRow    @ countInRow(grid, row, value)

  @ LDR   R0, =testGrid
  @ LDR   R1, =0        @ column number
  @ LDR   R2, =9        @ value to look for
  @ BL    countInCol    @ countInCol(grid, row, value)

  @ LDR   R0, =testGrid
  @ LDR   R1, =6        @ column number
  @ LDR   R2, =1        @ value to look for
  @ BL    countInCol    @ countInCol(grid, row, value)

  @ LDR   R0, =testGrid
  @ LDR   R1, =3        @ row number
  @ LDR   R2, =6        @ column number
  @ LDR   R3, =1        @ value to look for
  @ BL    countIn3x3    @ countIn3x3(grid, row, col, value)

  @ LDR   R0, =testGrid
  @ LDR   R1, =8        @ row number
  @ LDR   R2, =4        @ column number
  @ LDR   R3, =2        @ value to look for
  @ BL    countIn3x3    @ countIn3x3(grid, row, col, value)

  @ LDR   R0, =testGrid    // return 4
  @ LDR   R1, =1        @ row number
  @ LDR   R2, =7        @ column number
  @ BL    nextInCell    @ nextInCell(grid, row, col)

  @ LDR   R0, =testGrid    // return 9
  @ LDR   R1, =6        @ row number
  @ LDR   R2, =0        @ column number
  @ BL    nextInCell    @ nextInCell(grid, row, col)

  @
  @ Finally, let's try to solve the puzzle ...
  @ (The initial call to the resursive solveSudoku subroutine
  @   should always start in the top-left corner.)
  @

  LDR   R0, =testGrid
  LDR   R1, =0        @ row number
  LDR   R2, =0        @ column number
  BL    solveSudoku   @ solveSudoku(grid, 0, 0)
  MOV   R0, R0
End_Main:
  POP   {R4-R12, PC}


  .section  .data.test
@ Sudoku Test Grid
testGrid:
  .byte 1, 0, 0, 0, 0, 3, 9, 0, 0
  .byte 0, 4, 0, 1, 8, 0, 7, 0, 0
  .byte 0, 0, 0, 0, 0, 6, 0, 0, 8
  .byte 0, 0, 0, 0, 0, 8, 0, 0, 0
  .byte 0, 0, 2, 0, 0, 0, 4, 0, 0
  .byte 6, 0, 0, 9, 5, 0, 0, 0, 7
  .byte 0, 0, 0, 3, 0, 0, 0, 0, 0
  .byte 0, 6, 0, 0, 0, 0, 0, 9, 0
  .byte 9, 0, 0, 7, 1, 0, 0, 0, 5


.end