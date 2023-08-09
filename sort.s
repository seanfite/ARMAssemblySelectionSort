/* 
 * Sean Fite
 * 2/15/2023
 * ARM assembly program to fill a 10 element array with random values and use
 * selection sort to sort from lowest to highest and then print.
 *
 */

.data
i:
    .word 0
j: 
    .word 0
array:
    .skip 40
rand_num:
    .word 0
min:
    .word 0
format:
    .asciz "%d "

newLine:
    .asciz "\n"    
unsortedPrint:
    .asciz "Unsorted array:\n"
sortedPrint:
    .asciz "Sorted array:\n"


.text
.global main
main:
    push {lr}
    ldr r11, aArray
    ldr r9, aI      // variables
    ldr r10, aRand
    
    ldr r0, aRand   // seeding random
    bl time
    bl srand

    
randFxn:
    bl rand         // generating and storing random value
    str r0, [r10]
    
findRand:
    
    ldr r4, [r10]    // loop to put rand value in correct range
    cmp r4, #100    // works by subtracting upper end of range
                    // from generated value, ends
    ble fillArray   // when less or equal to 100

    sub r4, r4, #100
    str r4, [r10]
    b findRand

fillArray:
    ldr r4, [r10]
    ldr r8, [r9]            // logic to shift address location
    add r7, r11, r8, LSL #2  // array[i]

    str r4, [r7]
 
fillArrayLoop:
    ldr r5, [r9]
    add r5, r5, #1   // i++
    str r5, [r9]       
    cmp r5, #10     // i < 10 ?

    blt randFxn     // loops back to gen new rand

end:
    
    /* This section is the equivalant to the C code
    printf("Unsorted Array:\n")
    printArray(array, size);
    printf("\n")

    selectionSort(array,size);

    printf("Sorted Array:\n")
    printArray(array,size);
    printf("\n") */

    ldr r0, aUnsortedPrint
    bl printf

    ldr r0, aArray
    mov r1, #10     // prepping variables to pass
    bl printArray

    ldr r0, aNL
    bl printf
    
    ldr r0, aSortedPrint
    bl printf
    
    ldr r0, aArray
    mov r1, #10 
    bl selectionSort

    ldr r0, aArray
    mov r1, #10
    bl printArray
    
    ldr r0, aNL
    bl printf
    pop {lr}
    bx lr



printArray:
    push {lr}
    mov r5, #0
    str r5, [r9]     // shifting parameters to new registers
    mov r7, r0
    mov r8, r1

printArrayLoop:
    ldr r5,[r9]
    add r6, r7, r5, LSL #2   // array[i]
    
    ldr r0, aF               // printing value at array[i]
    ldr r1, [r6]
    bl printf
    
    add r5,r5,#1    // i++
    str r5, [r9]
    cmp r5, r8
    blt printArrayLoop   // breaks loop when
    pop {lr}             // i == size
    bx lr

selectionSort:
    push {lr}
    mov r11, r0         // array
    mov r12, r1        // size = 10
    ldr r9, aI        // i
    ldr r10, aJ      // j
    ldr r8, aMin    // min
    
    mov r3, #0     // i = 0
    str r3, [r9]
    ldr r3, [r9]

iLoop:
    ldr r3, [r9]
    mov r12, #9
    cmp r3,r12
    bge endSelectionSort   // i >= 9 branch to end of selection sort
    
    ldr r3, [r9]            
    str r3, [r8]           // min = i

    ldr r3, [r9]
    add r2, r3, #1     // j = i +1
    str r2, [r10] 

jLoop:
    ldr r11, aArray  // making sure we still have array loaded
    ldr r8, aMin

    ldr r2, [r10]   
    mov r12, #10     // test j < 10
    cmp r2, r12
    beq iterateILoop

    //iterate through array
    add r4, r11, r2, LSL #2    // &array[j]

    ldr r5, [r8]
    add r7, r11, r5, LSL #2   // &array[min]
    
    ldr r3, [r4]    // array[j]
    ldr r6, [r7]    // array[min]


    cmp r3, r6
    bge iterateJLoop
    ldr r2, [r10]
    str r2, [r8]
    ldr r5, [r8]    // min = j
    

iterateJLoop:

    ldr r2, [r10]
    add r2, r2, #1   //j++
    str r2, [r10]
    b jLoop

    
iterateILoop:
    ldr r3, [r9]
    ldr r5, [r8]
   
    add r7, r11, r5, LSL #2   //&array[min]
    add r4, r11, r3, LSL #2   //&array[i]
   
    mov r0, r7             // prepping addresses to pass.
    mov r1, r4
    bl swap

    ldr r3, [r9]
    add r3, r3, #1      //i++
    str r3, [r9]
    b iLoop

swap:
    push {lr}
   
    ldr r5, [r7]     // Swapping values at passed addresses
    ldr r3, [r4]     
    str r3, [r7]
    str r5, [r4]
   
    pop {lr}
    bx lr

endSelectionSort:   // end selection sort and branch
    pop {lr}        // back to main
    bx lr


aRand: .word rand_num
aI: .word i
aJ: .word j
aArray: .word array
aMin: .word min
aF: .word format
aNL: .word newLine
aUnsortedPrint: .word unsortedPrint
aSortedPrint: .word sortedPrint

.global printf
.global time
.global rand
.global srand
