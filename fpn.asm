section .text
   
;    int64 double2fixed(double n, int8 scale)
    global double2fixed

;   double fixed2double(int64 n, int8 scale)
    global fixed2double

;    int64 int2fixed(int64 n, int8 scale)
    global int2fixed

;    int64 fixed2int(int64 n, int8 scale)
    global fixed2int

;    int64 fixed_fraction(int64 n, int8 scale)
    global fixed_fraction        

;    int64 fixed_floor(int64 n, int8 scale)
    global fixed_floor           

;    int64 genepsilon()
    global genepsilon      

;    int64 genshift(int8 scale)
    global genshift        

;    int64 genfracmask(int8 scale)
    global genfracmask     

;    int64 genfloormask(int8 scale)
    global genfloormask    
    

double2fixed:
;;  Convert a double to a 64 Bitfixed point number
;; 
;;  Arguments:
;;      - rax: double
;;      - ecx: 8 Bit integer scale
;; 
;;  Returns: 64 Bit fixed point number
    
    ; return (n * (double)(1<<scale))
    xor rax, rax
    mov ecx, edi
    inc al
    shl rax, cl
    cvtsi2sd xmm1, rax
    mulsd  xmm0, xmm1
    cvttsd2si rax, xmm0
    ret
;; ---------------------------------------------------


fixed2double:
;;  Convert a 64 Bit fixed point number to a double
;; 
;;  Arguments:
;;      - rax: 64 Bit fixed point number
;;      - ecx: 8 Bit integer scale
;; 
;;  Returns: double

    ; return ((double)n / (double)1<<scale)
    xor rax, rax
    mov ecx, esi
    inc al
    shl rax, cl
    cvtsi2sd xmm0, rdi
    cvtsi2sd xmm1, rax
    divsd xmm0, xmm1
    movq rax, xmm0
    ret
;; ---------------------------------------------------


int2fixed:
;;  Convert a 64 Bit integer to a 64 Bit fixed point number
;; 
;;  Arguments:
;;      - rax: 64 Bit integer
;;      - ecx: 8 Bit integer scale
;; 
;;  Returns: 64 Bit fixed point number

    mov rax, rdi
    mov ecx, esi
    shl rax, cl
    ret
;; ---------------------------------------------------


fixed2int:
;;  Convert a fixed point number to a 64 Bit integer
;; 
;;  Arguments:
;;      - rax: 64 Bit fixed point number
;;      - ecx: 8 Bit integer scale
;; 
;;  Returns: 64 Bit integer

    mov rax, rdi
    mov ecx, esi
    sar rax, cl
    ret
;; ---------------------------------------------------


fixed_fractorial:     ; n & fracmask
;;  Return the factorial of x as a fixed point number.
;;
;;  Arguments:
;;      - rax: 64 Bit fixed point number x
;;      - ecx: 8 Bit integer scale
;;
;;  Returns: 64 Bit fixed point number

    xor rax, rax
    inc al
    mov ecx, esi
    shl rax, cl
    dec rax
    and rax, rdi
    ret
;; ---------------------------------------------------


fixed_floor:          ; n & floormask
;;  Return the floor of x as a fixed point number,
;;  the largest integer value less than or equal to x.
;;
;;  Arguments:
;;      - rax: 64 Bit fixed point number x
;;      - ecx: 8 Bit integer scale
;;
;;  Returns: 64 Bit fixed point number

    xor rax, rax
    not rax
    mov ecx, esi
    shl rax, cl
    and rax, rdi
    ret
;; ---------------------------------------------------


genepsilon:
;;  Generate double epsilon as a fixed point number
;;
;;  Arguments:
;;      - al: 64 Bit fixed point number

    xor rax, rax
    inc al
    ret
;; ---------------------------------------------------


genshift:
;;  Generate a mask with only the n'th Bit set
;;
;;  Arguments:
;;      - al: 8 Bit integer scale
;; 
;;  Returns: 64 Bit integer mask

    xor rax, rax
    mov ecx, edi
    inc al
    shl rax, cl
    ret
;; ---------------------------------------------------


; --- 64 Bit -----------------------------------------------------
; -------8------16------24------32------40------48------56------64
;        |       |       |       |       |       |       |       |
; 0000000000000000000000000000000000000000000000000000000100000000
; 0000000000000000000000000000000000000000000000010000000000000000
; 0000000000000000000000000000000000000001000000000000000000000000
; 0000000000000000000000000000000100000000000000000000000000000000
; 0000000000000000000000010000000000000000000000000000000000000000
; 0000000000000001000000000000000000000000000000000000000000000000
; 0000000100000000000000000000000000000000000000000000000000000000
; 0000000000000000000000000000000000000000000000000000000000000001
; |       |       |       |       |       |       |       |
;64------56------48------40------32------24------16-------8-------
; ----------------------------------------------------------------

; --- ASM --------------------------------------------------------
; 400b10:	48 31 c0             	xor    rax,rax
; 400b13:	89 f9                	mov    ecx,edi
; 400b15:	fe c0                	inc    al
; 400b17:	48 d3 e0             	shl    rax,cl
; 400b1a:	c3                   	ret    
; --- GCC --------------------------------------------------------
; 400a30:	48 89 f8             	mov    rax,rdi
; 400a33:	89 f1                	mov    ecx,esi
; 400a35:	48 d3 e0             	shl    rax,cl
; 400a38:	c3                   	ret 
; ----------------------------------------------------------------


genfracmask:        ; (1 << scale)-1
;;  Generate the fraction mask based on a scale
;;
;;  Calculation can be done once and reused in every
;;  fixed point number calculation to enhance speed.
;;
;;  Arguments:
;;      - al: 8 Bit integer scale
;; 
;;  Returns: 64 Bit integer mask

    xor rax, rax
    inc al
    mov ecx, edi
    shl rax, cl
    dec rax
    ret
;; ---------------------------------------------------


genfloormask:       ; ~0 << scale
;;  Generate the floor mask based on a scale.
;;
;;  Calculation can be done once and reused in every
;;  fixed point number calculation to enhance speed.
;;
;;  Arguments:
;;      - al: 8 Bit integer scale
;;
;;  Returns: 64 Bit integer mask

    xor rax, rax
    not rax
    mov ecx, edi
    shl rax, cl
    ret
;; ---------------------------------------------------
