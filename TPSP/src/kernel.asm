; ** por compatibilidad se omiten tildes **
; ==============================================================================
; TALLER System Programming - Arquitectura y Organizacion de Computadoras - FCEN
; ==============================================================================

%include "print.mac"
extern enable_a20        ; la rutina en a20.asm
extern GDT_DESC          ; la estructura con base y tamaño de la GDT
extern start_rm_msg
extern start_rm_len


global start


; COMPLETAR - Agreguen declaraciones extern según vayan necesitando
%define C_FG_LIGHT_GREEN 0xA
; COMPLETAR - Definan correctamente estas constantes cuando las necesiten
%define CS_RING_0_SEL 0x08
%define DS_RING_0_SEL 0x18


BITS 16
;; Saltear seccion de datos
jmp start

;;
;; Seccion de datos.
;; -------------------------------------------------------------------------- ;;
start_rm_msg db     'Iniciando kernel en Modo Real'
start_rm_len equ    $ - start_rm_msg

start_pm_msg db     'Iniciando kernel en Modo Protegido'
start_pm_len equ    $ - start_pm_msg


;;
;; Seccion de código.
;; -------------------------------------------------------------------------- ;;

;; Punto de entrada del kernel.
BITS 16
start:
    ; COMPLETAR - Deshabilitar interrupciones
    cli

    ; Cambiar modo de video a 80 X 50
    mov ax, 0003h
    int 10h ; set mode 03h
    xor bx, bx
    mov ax, 1112h
    int 10h ; load 8x8 font

    ; COMPLETAR - Imprimir mensaje de bienvenida - MODO REAL
    ; (revisar las funciones definidas en print.mac y los mensajes se encuentran en la
    ; sección de datos)
    print_text_rm start_rm_msg, start_rm_len, C_FG_LIGHT_GREEN, 0, 0

    ; COMPLETAR - Habilitar A20
    ; (revisar las funciones definidas en a20.asm)
    call enable_a20

    ; COMPLETAR - Cargar la GDT
    lgdt [GDT_DESC]

    ; COMPLETAR - Setear el bit PE del registro CR0
    mov eax, cr0
    or  eax, 1
    mov cr0, eax

    ; COMPLETAR - Saltar a modo protegido (far jump)
    ; (recuerden que un far jmp se especifica como jmp CS_selector:address)
    ; Pueden usar la constante CS_RING_0_SEL definida en este archivo
    jmp CS_RING_0_SEL:modo_protegido

BITS 32
modo_protegido:
    ; COMPLETAR - A partir de aca, todo el codigo se va a ejectutar en modo protegido
    ; Establecer selectores de segmentos DS, ES, GS, FS y SS en el segmento de datos de nivel 0
    ; Pueden usar la constante DS_RING_0_SEL definida en este archivo

    ; COMPLETAR - Establecer el tope y la base de la pila

    ; COMPLETAR - Imprimir mensaje de bienvenida - MODO PROTEGIDO

    ; COMPLETAR - Inicializar pantalla
    
   
    ; Inicializar el directorio de paginas

    ; Cargar directorio de paginas

    ; Habilitar paginacion

    ; Inicializar tss

    ; Inicializar el scheduler

    ; Inicializar las tareas

    ; COMPLETAR - Inicializar y cargar la IDT

    ; COMPLETAR - Reiniciar y habilitar el controlador de interrupciones

    ; Cargar tarea inicial

    ; COMPLETAR - Habilitar interrupciones
    ; NOTA: Pueden chequear que las interrupciones funcionen forzando a que se
    ;       dispare alguna excepción (lo más sencillo es usar la instrucción
    ;       `int3`)
    ;int3

    ; Probar Sys_call

    ; Probar generar una excepción

    ; Inicializar el directorio de paginas de la tarea de prueba
    ; Cargar directorio de paginas de la tarea
    ; Restaurar directorio de paginas del kernel

    ; Saltar a la primera tarea: Idle

    ; Ciclar infinitamente 
    mov eax, 0xFFFF
    mov ebx, 0xFFFF
    mov ecx, 0xFFFF
    mov edx, 0xFFFF
    jmp $

;; -------------------------------------------------------------------------- ;;

%include "a20.asm"
