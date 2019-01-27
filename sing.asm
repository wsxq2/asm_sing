.model small,stdcall
.stack 4096
;.386

speaker    = 61h						; address of speaker port
timer      = 42h						; address of timer port

inner_delay = 6553 ;内部循环使用的延时，最大可以为 65535
interval = 30000 ;每个音之间的间隔时间，最大可以为 65535

.data
;data start
pitches WORD 0960H,0960H,0960H,0960H,0960H,0960H,0BB8H,0960H,0834H,0960H
        WORD 0BB8H,0CE4H,0BB8H,0960H,0960H,0BB8H,0960H,0BB8H,0CE4H,0E10H
        WORD 0BB8H,0CE4H,0BB8H,0BB8H,0CE4H,1068H,0E10H,0CE4H,0834H,0834H
        WORD 0960H,0BB8H,0834H,0960H,0960H,0BB8H,0CE4H,0BB8H,0960H,0960H
        WORD 0BB8H,0CE4H,0BB8H,0960H,0BB8H,0CE4H,0BB8H,1068H,0E10H,0CE4H
        WORD 0BB8H,0E10H
pitches_len=( $ - pitches)/2
durations WORD 0096H,0096H,012CH,0096H,0096H,012CH,0096H,0096H,0096H,004BH
          WORD 004BH,0096H,0096H,012CH,0096H,0096H,0096H,004BH,004BH,0096H
          WORD 0096H,012CH,0096H,0096H,012CH,0096H,0096H,012CH,012CH,0096H
          WORD 0096H,0096H,0096H,012CH,0096H,0096H,0096H,0096H,0258H,0096H
          WORD 0096H,0096H,0096H,0096H,0096H,0096H,0096H,0096H,0096H,0096H
          WORD 0096H,0258H
;data end
.code
sing PROC
; 根据音调和音长发出一个声音
; Receives: dx:pitch, cx:duration
; Return: None
	push ax
	push cx

	in   al,speaker				; get speaker status
	push ax             		; save status
	or   al,00000011b   		; set lowest 2 bits
	out  speaker,al     		; turn speaker on

	mov al,dl
	out timer,al
	mov al,dh
	out timer, al

	;mov cx,delay
L3a: push cx
     mov  cx,inner_delay
L3b: loop L3b
     pop  cx
     loop L3a

	 pop  ax              	; get original status
	 and  al,11111100b    	; clear lowest 2 bits
	 out  speaker,al				; turn speaker off

     mov  cx,interval
L4: loop L4

	pop cx
	pop ax
	ret
sing ENDP

main PROC
	  mov ax,@data
	  mov ds,ax
	  mov es,ax


		 mov cx, pitches_len
		 mov si, 0

L2:	 
  	 ; Create a delay loop between pitches:
		 push cx
	     mov dx, pitches[si]
	     mov cx, durations[si]
		 call sing

		 add si, 2
		 pop cx
		 loop L2


		 mov  ax,4c00h
		 int  21h
main ENDP
END main
