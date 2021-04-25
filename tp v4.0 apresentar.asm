
org 100h  

    jmp inicio
    ;declaracion de datos
    letras db 319 dup(?);tamano de la "matriz" 19 por los saltos de linea

    msg db 'Ingrese cantidad de minutos :$'
    borrarmsg db '                               $'
    letrasarmadas db 200 dup(?);donde se guardan las palabras armadas por los jugadores
    puntaje db 0
    puntajeJ1 db 0  ;puntaje jugador 1
    puntajeJ2 db 0  ;puntaje jugador 2
    letrasvacias db 200 dup(?) ;contienen espacios,util para "borrar" lo que hay en pantalla
    tiempo db ?         ;contiene los minutos cuando termina el turno del jugador actual
    tiempoingresado db ? ;contiene los minutos que se ingresaron al inicio
    num db 26;modifique por 25       ;util para hacer la cuenta de numeros aleatorios
    turno db 0;cantidad de turnos variable para controlar los turnos 
    msgigual db 'Empate.$'
    msgganador db 'Ganador jugador  $'
    msgpuntaje db 'Puntaje        $'
    num2 db 10      ;util para mostrar puntajes de los jugadores
    
inicio:
    
    mov ah,09h ;funcion para imprimir una cadena
    lea dx, msg ; carga en dx la direccion de memoria de msg
    int 21h ; imprime la cadena msg

    mov ah,01h 
    int 21h    ;tomo los minutos que ingresa el usuario (1 o 2 min)
    
    mov tiempoingresado,al
    sub tiempoingresado,30h ;guarde el numero de minutos "reales" o en decimal
  
    mov cx,300 ;genero 300 letras aleatorias
    mov si,0;inicializo si en 0 para moverme sobre el "vector" LETRAS (funciona como subindice del vector)               
    
    jmp ciclo

saltar:;hace un \n

    mov letras[si],0ah ;salto de linea 
    inc si
     
    mov letras[si],0dh ;retorno de carro 
    inc si
    
    jmp ciclo
    
    
ciclo:;genero numeros aleatorios entre 65 y 90(ascii A hasta Z)
    mov ah,2ch
    push cx;guardo en que iteracion estoy en el ciclo
    int 21h
    add dl,65
    xor ah,ah ;mov ah,0
    mov al,dl
    div num
    add ah,65 ;en ah tengo numeros aleatorios entre 65 y 90
  
    pop cx;desapilo lo que guarde y se en que iteracion estoy en el ciclo
     
    cmp si,30; cuando si vale 30 salta de linea
    je  saltar 
    cmp si,62; cuando si vale 60 salta de linea
    je  saltar 
    cmp si,94; cuando si vale 90 salta de linea
    je  saltar
    cmp si,126; cuando si vale 120 salta de linea
    je  saltar
    cmp si,158; cuando si vale 150 salta de linea
    je  saltar
    cmp si,190; cuando si vale 180 salta de linea
    je  saltar
    cmp si,222; cuando si vale 210 salta de linea
    je  saltar
    cmp si,254; cuando si vale 240 salta de linea
    je  saltar
    cmp si,286; cuando si vale 270 salta de linea
    je  saltar
    
    mov letras[si],ah; o al
    inc si
    loop ciclo;cuando cx llega a ser 0 no continua con el ciclo
    
    mov letras[si],'$'
    
    
imprimir:;muestra las letras de LETRAS(vector)  
    
    ;;borro el msg
    mov dh, 0
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h   ;posiciona el cursor en la posicion 0,0 de la pantalla
    
    mov ah,09h
    lea dx,borrarmsg
    int 21h
    
    mov dh, 0
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h   ;posiciona el cursor en la posicion 0,0 de la pantalla
    ;;borro el msg
     
    mov ah,09h ;funcion para imprimir una cadena
    lea dx, letras ; carga en dx la direccion de memoria de letras
    int 21h ; imprime la cadena letras(matriz de letras al azar)

    call llenarvacios
    
iniciojuego: 
   
    mov ah,2ch  ;tomo hora actual y sumo los minutos
    int 21h     ;en cl tengo los minutos
          
    add cl,tiempoingresado  ;cl=cl+tiempoingresado
    mov tiempo,cl ;en tiempo tengo los minutos en los cuales se termina el turno
          
    mov dh, 0
	mov dl, 0 
	mov bh, 0
	mov ah, 2
	int 10h   ;posiciona el cursor en la posicion 0,0 de la pantalla
    mov si,0 
    inc turno 
    
moverenpantalla:;mover el cursor sobre la matriz
    
    push dx;en dx tengo las posiciones de fila y columna (los guardo para mantenerme en la matriz)
    
    mov ah,2ch  ;tomo hora actual, en cl tengo los minutos
    int 21h
    
    cmp cl,tiempo ;tiempo contiene el minuto en que termina el juego
    jae mostrarpalabras ;si termino mi tiempo de juego salto a mostrarpalabras 
    
    pop dx;en dx tengo las posiciones de fila y columna
    
    mov ah,0
    int 16h ;pide dato por teclado(pero no lo muestra) y guarda el ascii en el registro al
    
    cmp al,100    ;toma letras minusculas o mayusculas
    je moverderecha 
    
    cmp al,68
    je moverderecha   
    
    cmp al,97
    je moverizquierda 
    
    cmp al,65
    je moverizquierda
    
    cmp al,119 ;W
    je moverarriba 
    
    cmp al,87   ;w
    je moverarriba
    
    cmp al,115
    je moverabajo
    
    cmp al,83
    je moverabajo 
    
    cmp al,13
    je tomarcaracter
    
    cmp al,108       ;auxiliar
    je mostrarpalabras
    
    cmp al,27
    je findepalabra

    jmp moverenpantalla
    
    
moverderecha:
    
    cmp dl,29
    je moverenpantalla          
    
	inc dl;incremento en 1 la columna
	mov bh, 0 ;bh,0 siempre porque es la pagina 0
	mov ah, 2
	int 10h     
	
	jmp moverenpantalla
    
moverizquierda:
    
    cmp dl,0 
	je moverenpantalla
	
	sub dl,1;resto 1 a la columna
	mov bh, 0 ;bh,0 siempre porque es la pagina 0
	mov ah, 2
	int 10h     
	
	jmp moverenpantalla
        
moverarriba:
    
    cmp dh,0 
	je moverenpantalla  
	
	sub dh,1;resto 1 a fila
	mov bh, 0 ;bh,0 siempre porque es la pagina 0
	mov ah, 2
	int 10h     
	
	jmp moverenpantalla
	
moverabajo:
            
    cmp dh,9 
	je moverenpantalla 
	       
	inc dh;incremento en 1 la fila
	mov bh, 0 ;bh,0 siempre porque es la pagina 0
	mov ah, 2
	int 10h     
	
	jmp moverenpantalla	
	
tomarcaracter:
    
    mov ah , 08h
    int 10h;en al tengo el ascii de la letra donde esta parado el cursor
    mov letrasarmadas[si],al;en al tengo el ascii de la letra donde esta parado el cursor
    
    cmp letrasarmadas[si],'A'
    je sumavocal
    cmp letrasarmadas[si],'E'
    je sumavocal
    cmp letrasarmadas[si],'I'
    je sumavocal
    cmp letrasarmadas[si],'O'
    je sumavocal
    cmp letrasarmadas[si],'U'
    je sumavocal
    
    add puntaje,3
    inc si    
    jmp moverenpantalla 
    
sumavocal:
    add puntaje,2    
    inc si    
    jmp moverenpantalla 
    
    
findepalabra:
    mov letrasarmadas[si],',';separa con comas las palabras
    inc si
    
    jmp moverenpantalla    
    
mostrarpalabras:

    mov letrasarmadas[si],'$';fin de cadenas
    
    mov dh, 11;posiciono el cursor para luego mostrar las palabras armadas
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
	
	mov ah,02h 
    mov dl,0dh ;retorno de carro 

    mov ah,09h ;funcion para imprimir una la cadena letrasarmadas
    lea dx,letrasarmadas ; carga en dx la direccion de memora de letrasarmadas
    int 21h ;
    
    mov ah,0
    int 16h
    
imprimircadenavacia:   
 
    mov dh, 11;posiciono el cursor para luego mostrar las palabras armadas
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
	 
    mov ah,09h ;funcion para imprimir la cadena letrasvacias
    lea dx, letrasvacias ; carga en dx la direccion de memora de letrasarmadas
    int 21h ;   
	
asignarpuntaje:
	
	cmp turno,1
	je sumarpuntos
	cmp turno,3
	je sumarpuntos
	cmp turno,5
	je sumarpuntos
	
	mov ah,puntaje  ;cambie antes ax
	add puntajeJ2,ah ;cambie antes ax	

proximajugada:	
	mov si,0 
	  
	mov ah,2ch  ;tomo hora actual y sumo los minutos
    int 21h     ;en cl tengo los minutos
          
    add cl,tiempoingresado  ;cl=cl+tiempoingresado
    mov tiempo,cl ;en tiempo tengo los minutos en los cuales se termina el turno
 
    mov dh, 0
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
         	
	inc turno
	mov puntaje,0
	
	cmp turno,7
    jne moverenpantalla
    
    mov dh, 11;posiciono el cursor para luego mostrar ganador
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
            
    jmp mostrarganador

sumarpuntos: ;sumo puntos al jugador 1
    mov ah,puntaje
    add puntajeJ1,ah 
    
    jmp proximajugada

mostrarganador:;compara los puntajes 

    mov ah,puntajeJ1 ;cambie antes ax
    cmp puntajeJ2,ah ;cambie antes ax
    je iguales
    cmp puntajeJ2,ah  ;cambie antes ax
    ja ganadorJ2
    jmp ganadorJ1

iguales:     

    mov ah,09h ;funcion para imprimir una cadena
    lea dx, msgigual
    int 21h ;
      
    jmp salir
              
ganadorJ1: 

    mov si,16             
    mov msgganador[si],'1' 
    
    mov ah,09h ;funcion para imprimir una cadena
    lea dx, msgganador
    int 21h ;
    
    mov dh, 12;posiciono el cursor para luego mostrar las palabras armadas
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h 
	
	mov si,10
		
auxiliar1: 

    mov ah,0
    mov al,puntajeJ1
    div num2
    add ah,30h
    mov msgpuntaje[si],ah
    
    dec si
    mov puntajeJ1,al
    cmp puntajeJ1,10
    jae auxiliar1 
    
    add al,30h  
    mov msgpuntaje[si],al  	
	
	mov ah,09h ;funcion para imprimir una cadena
    lea dx, msgpuntaje
    int 21h ;
	
    jmp salir
    
ganadorJ2: 

    mov si,16
    mov msgganador[si],'2' 
    
    mov ah,09h ;funcion para imprimir una cadena
    lea dx, msgganador
    int 21h ;
    
    mov dh, 12;posiciono el cursor para luego mostrar las palabras armadas
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
	
	mov si,10
	 
auxiliar2:  

    mov ah,0
    mov al,puntajeJ2
    div num2
    add ah,30h
    mov msgpuntaje[si],ah
    
    dec si
    mov puntajeJ2,al
    cmp puntajeJ2,10
    jae auxiliar2  
    
    add al,30h 
    mov msgpuntaje[si],al
	
	mov ah,09h 
    lea dx, msgpuntaje
    int 21h 
	
    jmp salir               
              

salir:
ret



llenarvacios proc ;asigna en cada posicion de letrasvacias un espacio
     mov si,0
     mov cx,199;199 espacios
   repeat:
     mov letrasvacias[si],' '
     inc si   
    loop repeat
     mov letrasvacias[si],'$';1 $ para fin de cadena
    ret
llenarvacios endp