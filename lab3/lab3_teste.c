int read(int __fd, const void *__buf, int __n){
    int ret_val;
  __asm__ __volatile__(
    "mv a0, %1           # file descriptor\n"
    "mv a1, %2           # buffer \n"
    "mv a2, %3           # size \n"
    "li a7, 63           # syscall write code (63) \n"
    "ecall               # invoke syscall \n"
    "mv %0, a0           # move return value to ret_val\n"
    : "=r"(ret_val)  // Output list
    : "r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
  return ret_val;
}

void write(int __fd, const void *__buf, int __n)
{
  __asm__ __volatile__(
    "mv a0, %0           # file descriptor\n"
    "mv a1, %1           # buffer \n"
    "mv a2, %2           # size \n"
    "li a7, 64           # syscall write (64) \n"
    "ecall"
    :   // Output list
    :"r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
}

void exit(int code)
{
  __asm__ __volatile__(
    "mv a0, %0           # return code\n"
    "li a7, 93           # syscall exit (64) \n"
    "ecall"
    :   // Output list
    :"r"(code)    // Input list
    : "a0", "a7"
  );
}

#define STDIN_FD  0
#define STDOUT_FD 1

int converter(char str[]){
  int n = 0;
  for(int i = 31; i >= 0; i--) {
    n = n + (str[i] - '0') * (1 << (31 - i));
  }
  return n;
}
int converter_b(char str[]){
    int n;
    for(int i=31; i>0; i--){
      n=n*10+(str[i] - '0'); // coloquei o menos '0' :]
    }
    n=n & 0xffffffff;
    return n;
}
/* Nessa função aqui, você teria que passar o `texto`
 * pra ela do mesmo jeito que passou a `str` pra funcionar.
 * É que não dá pra retornar um endereço da stack (neste caso,
 * `char texto[5]`) pra outras funções usarem. Isso pq
 * tudo que está na stack da função `sinal` vai ser
 * descartado assim que a função `sinal` terminar de rodar
 * (isto é, chegar no return).
 * 
 * Estou comentando ela, já que está duplicado com o
 * código da main
 */
/*
char sinal(int binario,char str[]){
    char texto[5];
    if(str[32]=='1'){
        texto[1]='-';    
    }
    texto[0]=binario;
    texto[2]='\n';
    return texto;

}
*/
int endiannes(int binario){
    int b1,b2,b3,b4;
    b1 = binario & 0x000000ff;
    b2 = binario & 0x0000ff00;
    b3 = binario & 0x00ff0000;
    b4 = binario & 0xff000000;
    
    b1 = b1<<24;
    b2 = b2<<8;
    b3 = b3>>8; // não deveria ser shift pro outro lado?
    b4 = b4>>24;
    return (b1|b2|b3|b4);

}
int msb_(char str[]){
  int n=0;
  for(int j=0;j<32;j++){ // troquei a ordem do loop aqui
    if(str[j]=='1'){ // coloquei as aspas pra ser o caractere 1. Esse era um problema ;)
      n=j;
      break;
    }
  } // este final de chaves aqui estava no lugar errado
  return n;
}

/*
 * Uma função conveniente pra reverter uma string
 * dentro dela mesma.
 */


int comple_2(int decimal){
  int b;
  b=(~(decimal)&0xffffffff)+1;
  return(b);
}


void revert_str(char str[], int n) {
  for (int i = 0; 2 * i < n; i++) {
    char tmp = str[i];
    str[i] = str[n - i - 1];
    str[n - i - 1] = tmp;
  }
}

/*
 * Implementação de exemplo de como converter de um inteiro
 * pra uma representação decimal pra escrever na saída
 * 
 * Essa implementação a seguir assume que o `decimal` é
 * positivo. É uma possibilidade tornar ela genérica,
 * eu acho. 
 */

 void write_decimal_ss(unsigned int decimal) {
  char result[35];
  int n = 0;

  do {
    unsigned int unit = decimal % 10;
    decimal = decimal / 10;
    result[n] = '0' + unit;
    n++;
  } while (decimal > 0 && n <32);

  revert_str(result, n);

  result[n] = '\n';
  n++;

  write(STDOUT_FD, result, n);
}


void write_decimal(unsigned int decimal) {
  char result[35];
  int n = 0;

  do {
    unsigned int unit = decimal % 10;
    decimal = decimal / 10;
    result[n] = '0' + unit;
    n++;
  } while (decimal > 0 && n <32);
  if(decimal==1){
    result[n] = '-';
    n++;
  }

  revert_str(result, n);

  result[n] = '\n';
  n++;

  write(STDOUT_FD, result, n);
}

void write_bin(unsigned int decimal) {
  char result[35];
  int n = 0;

  do {
    unsigned int unit = decimal % 2;
    decimal = decimal / 2;
    result[n] = '0' + unit;
    n++;
  } while (decimal > 0 && n < 33);
  result[n]='b';
  n++;
  result[n]='0';
  n++;

  revert_str(result, n);

  result[n] = '\n';
  n++;

  write(STDOUT_FD, result, n);
}





void write_oct(unsigned decimal) {
  char result[35];
  int n = 0;

  do {
    unsigned unit = decimal % 8;
    decimal = decimal / 8;
    result[n] = '0' + unit;
    n++;
  } while (decimal > 0 && n < 33);
  result[n]='o';
  n++;
  result[n]='0';
  n++;

  revert_str(result, n);

  result[n] = '\n';
  n++;

  write(STDOUT_FD, result, n);
}

void write_hexa(unsigned decimal) {
  char result[35];
  int n = 0;

  do {
    unsigned unit = decimal % 16;
    decimal = decimal / 16;
    if(unit>9){
      result[n]=unit-10+'a';
    }else{
      result[n] = '0' + unit;
    }
    n++;
  } while (decimal > 0 && n < 33);
  result[n]='x';
  n++;
  result[n]='0';
  n++;
  revert_str(result, n);

  result[n] = '\n';
  n++;

  write(STDOUT_FD, result, n);
}

int main();

void _start()
{
  int ret_code = main();
  exit(ret_code);
}

int main()
{
    int binario,end,msb,decimal,complemento;
    char str[35],texto[4];
    /* Read up to 8 bytes from the standard input into the str buffer */
    int n = read(STDIN_FD, str, 35);
    binario = converter_b(str);
    decimal = converter(str);

    write_decimal(decimal);
    
    end=endiannes(decimal);
    write_decimal_ss(end);

    if(str[0]=='1'){
      complemento=comple_2(decimal);
      write_hexa(complemento);
    }else{
      write_hexa(decimal);
    }

    if(str[0]=='1'){
      complemento=comple_2(decimal);
      write_oct(complemento);
    }else{
      write_oct(decimal);
    }


   end=endiannes(decimal);
   if(str[0]=='1'){
      complemento=comple_2(end);
       write_bin(complemento);
     }else{
       write_bin(end);
     }

   end=endiannes(decimal);
   if((str[0])=='1'){
      complemento=comple_2(end);
       write_decimal(complemento);
     }else{
       write_decimal(end);
     }

  end=endiannes(decimal);
  if(str[0]=='1'){
    complemento=comple_2(end);
     write_hexa(complemento);
   }else{
     write_hexa(end);
   } 

  end=endiannes(decimal);
  if(str[0]=='1'){
    complemento=comple_2(end);
     write_oct(complemento);
   }else{
    write_oct(end);
   } 

    //msb=msb_(str);
    //texto = sinal(binario,str)
    //if(str[msb]=='1'){ // coloquei as aspas pra ser o caracter 1
    //    texto[1]='-';    
    ///}
    
    //texto[0]= decimal + '0';
    //texto[2]= msb + '0';
    //texto[3]= '\n';
    //write_oct(decimal);
   // complemento=comple_2(decimal);
   // write_decimal(decimal);
      //complemento=comple_2(decimal);
      // end=endiannes(decimal); // troquei usar `decimal`
       //write_oct(end);
    

    return 0;
}