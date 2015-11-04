section .data

section .text
    global hemming_dist                 ; proto: int, int
    global build_stack_frame_manual     ; proto: -
    global build_stack_frame_auto       ; proto: -


hemming_dist:
;;  Calculate Hamming distance between two integers

;;  Implemented using population count instruction
;;  from the SSE4 instruction set.
;;
;;  Arguments:
;;      - rdi: 64 Bit integer
;;      - rsi: 64 Bit integer
;;
;;  Returns: 64 Bit integer

    mov rax, rdi
    xor rax, rsi
    popcnt rax, rax
    ret
;; ---------------------------------------------------


build_stack_frame_manual:
;;  Manualy set up a stack-frame
;;
;;  Tends to be ~25% faster than automatic set up.
;;  But needs more space.

    push rbp        ; save base pointer
    mov rbp, rsp    ; make stack-pointer new base pointer
    sub rsp, 4      ; reserve 4 bytes on stack
    ; ...
    mov rsp, rbp    ; restore stack pointer
    pop rbp         ; restore base pointer
;; ---------------------------------------------------


build_stack_frame_auto:
;;  Automatically set up a stack-frame
;;
;;  Tends to be ~25% slower than manual set up.
;;  But needs less space.

;;  Tests showed, taht gcc generates the manual set up
;;  process for the function prologue, but creates the
;;  automatic method for function epilouge.

    enter 4, 0      ; create stack frame, reserve 4 bytes
    ; ...
    leave           ; clean up stack frame
;; ---------------------------------------------------
    

xor_swap:
;;  XOR based variable swapping implementation
;;
;;  Results showed that XOR swapping two values is
;;  horrifyingly slow. Because all steps have dependencies,
;;  a parallel execution is not possible and hence blocks.

    cmp rdi, rsi
    je _equal
    mov rax, rdi
    xor rax, rsi
    xor rsi, rax
    xor rax, rsi
    _equal:
    ret
;; ---------------------------------------------------
