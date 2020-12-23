    [org 0x0100]
     
    jmp start 
     
    arr1: 
    dw 2, 2, 3, 8 
     
    arr2: 
    dw 3, 5, 8, 0 
     
    arr3: 
    dw 0, 0, 0, 0, 0, 0, 0, 0
     
     
    removeDuplicate: 
    push bp 
    mov bp, sp 
    push ax 
    push bx 
    push cx 
    push dx 
    push di 
     
    mov bx, [bp + 6] ;address of my array 
    mov cx, 0 
    xor di,  di 
    push bx 
    mov bx, [bp + 4]
    sub bx, 1 
    mov [bp + 4], bx
     
    dupOuterLoop: 
    cmp cx, [bp + 4]
    je workDone
    mov bx, [bp + 6] ;I will have to move the same address in each iteartion 
    add bx, di 
    push bx
    add bx, 2 
    mov ax, bx ;the address of the bx + 2 element 
    pop bx  ;bx is back to normal 
    ;at this point 
    ;ax = bx + 2
    ;bx = current element being tested 
    push di  ;di is mainly used when working with bx 
    push cx ;again cx is used in both inner and outer loops 
    xor di ,di  ;clears di
    mov cx, [bp + 4]
    ;mul cx, 2 
    shl cx, 1
    ;so in the inner loop, we will have to compare di with cx 
    dupInnerLoop:  
    push bx ;temporarily 
    mov bx, ax 
    mov dx , [bx + di]
    pop bx ;pop back into bx 
    ;so now bx has its original value i.e the address but the dx register has the value located at the ath address 
    cmp dx, [bx]
    je makeNull 
    afterNull: 
    add di, 2 
    cmp di, cx 
    jne dupInnerLoop
    pop cx  ;cx value return back to that of the outerloop counter 
    pop di ;di value returns back to that of the outer offset 
    add di, 2 
    add cx, 1  
    jmp dupOuterLoop
     
     
    makeNull:
    ;so currently the a register has the address of [bx + someOffset]
    push bx 
    mov bx, ax
    mov word [bx + di], 0
    pop bx 
    jmp afterNull 
     
     
     
    workDone:
    pop di 
    pop dx 
    pop cx 
    pop bx 
    pop ax 
    pop di
    ret 
     
     
     
    ;||THIS PART BELOW HAS TO DO WITH THE MERGING OF THE ARRAYS||
    merge: 
    push bp 
    mov bp, sp   ;this will set up our base pointer
    push cx 
    push dx 
    push ax 
    xor cx, cx                     ;at 0xE offset, we have the address of arr1 
    push $0  ;<---Sp 
     
    ;lets set it up
    mov ax, [bp + 0xE] ;ax = address of a1 
    mov bx, [bp + 0x6] ;bx = address of a3 
    mov cx, [bp + 0xC] ;cx = 4 (size of a1)
    xor dx, dx 
    ;lets say that I will use di register to store intermediatory data 
    xor di, di
    push bx 
     
    l1:
    cmp  cx, [bp + 0xC]  
    jnz clrdi 
    l2:
    add ax, di 
    mov bx, ax 
    mov dx, [bx]  ;even though it should be [ax ] ;, so essentially only bx register can be used to index elements
    mov bx, [bp - 0xA]
    add bx, di 
    mov [bx], dx 
    mov [bp - 0xA], bx 
    sub cx, 0x1 
    jne l1 
    jmp merge2 
     
    clrdi: 
    mov di, 0x2 
    jmp l2 
     
    merge2:  
    mov ax, [bp + 0xA] ;ax = address of a2 
    mov cx, [bp + 0x8] ;cx = 4 (size of a1)
    ;currently bx is at the 4th element (filled) of the array3 
    xor di, di 
    xor dx, dx 
     
    add bx, 0x2 
    mov [bp - 0xA], bx 
    l3: 
    cmp cx, [bp + 0x8]
    jnz clrdi2
     
    l4: 
    add ax, di 
    mov bx, ax 
    mov dx, [bx]
    mov bx, [bp - 0xA]
    add bx, di 
    mov [bx], dx 
    mov [bp - 0xA], bx 
    sub cx, 0x1 
    jne l3 
    jmp after
     
     
     clrdi2: 
     mov di, 0x2 
     jmp l4 
     
    after:
    mov sp, bp
    pop bp 
    ret 
     
    start: 
    push arr1  ;offset 16        
    push byte $4    ;offset 12   
    push arr2  ;  offset 10 
    push byte $4  ;offset 8
    push arr3 ;offset 6 
    push byte $8   ;offset 4  
     
    call merge
    add sp, 12 
    ;stack is all cleaned up here 
    push arr3  ;now we have the address of the array3 onto the stack 
    push $8 ;size of arr3 
    call removeDuplicate
    add sp, 4
     
    mov ax, 0x4c00 
    int 0x21