%macro EXIT 1
    mov eax, 1
    mov ebx, %1
    int 0x80
%endmacro

%macro putchar 1
    pushd
    jmp %%work
    %%char db %1
%%work:
    mov eax, 4
    mov ebx, 1
    mov ecx, %%char
    mov edx, 1
    int 0x80
    popd
%endmacro

%macro const_print 1
    pushd
    jmp %%print 
    %%str db %1, 0xA
    %%len equ $ - %%str
%%print:  
    mov eax, 4
    mov ebx, 1
    mov ecx, %%str
    mov edx, %%len
    int 0x80
    popd
%endmacro

%macro print 2
    pushd
    mov edx, %1
    mov ecx, %2
    mov ebx, 1
    mov eax, 4
    int 0x80
    popd
%endmacro

%macro printd 0
    pushd
    mov bx, 0
    mov ecx, 10
    %%_divide:
    mov edx, 0
    div ecx
    push dx
    inc bx
    test eax, eax
    jnz %%_divide
    %%_digit:
    pop ax
    add ax, '0'
    mov [result], ax
    print 1, result
    dec bx
    cmp bx, 0
    jg %%_digit
    popd
%endmacro

%macro pushd 0
    push eax
    push ebx
    push ecx
    push edx
%endmacro

%macro popd 0
    pop edx
    pop ecx
    pop ebx
    pop eax
%endmacro


section .text
    global _start

_start:
    mov ebx, 0
    mov eax, 0
_sum_array1:
    add al, [array1 + ebx*1]
    inc ebx
    cmp ebx, array_len
    jl _sum_array1

    mov [array1_sum], eax
    ; const_print "Сумма первого массива:"
    ; putchar 0xA
    ;printd Я не понимаю почему, но если добавить эту команду
    ;то array1_sum становится равен нулю
    ;print nl_len, new_line 
    mov ebx, 0
    mov eax, 0
_sum_array2:
    add al, [array2 + ebx*1]
    inc ebx
    cmp ebx, array_len
    jl _sum_array2

    mov [array2_sum], eax
    ; printd И здесь тоже. Странно, что даже тут теряется array1_sum
    xor edx, edx
    mov ebx, [array1_sum]
    sub eax, ebx
    const_print "Результат вычитания суммы массивов: "
    printd
    putchar 0xA
    mov ebx, len + 1
    div ebx
    const_print "Среднее арифметическое разности двух массивов: "
    printd
    putchar ','
    mov eax, edx
    printd
    putchar 0xA
    mov eax, len + 1
    const_print "Количество элементов в массиве: "
    printd
    putchar 0xA

    print nl_len, new_line
    print len, message
    print nl_len, new_line

    EXIT 0

section .data
    array1 db 10, 13, 14, 7, 8, 12
    array_len equ $ - array1
    array2 db 20, 23, 24, 17, 18, 123
    new_line db 0xA, 0xB
    nl_len equ $ - new_line
    message db "Done!"
    len equ $ - message
section .bss
    result resb 1
    array1_sum resb 10
    array2_sum resb 10