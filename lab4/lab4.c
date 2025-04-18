
#define STDIN_FD  0
#define STDOUT_FD 1

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


void hex_code(unsigned val){
    char hex[11];
    unsigned int uval = (unsigned int) val, aux;

    hex[0] = '0';
    hex[1] = 'x';
    hex[10] = '\n';

    for (int i = 9; i > 1; i--){
        aux = uval % 16;
        if (aux >= 10)
            hex[i] = aux - 10 + 'A';
        else
            hex[i] = aux + '0';
        uval = uval / 16;
    }
    write(1, hex, 11);
}

int converter(char str[],int j){
    int k,n=0,soma=1;

    for(int i=0; i <= 3; i++) {
      k=i;
      soma=1;
      while(k!=0){
        soma = soma*10;
        k--;
      }
      n = n + soma*(str[j]-'0');
      j--;
    }
    return n;
  }
void converter_hex(unsigned n1,unsigned n2,unsigned n3,unsigned n4,unsigned n5,unsigned n6,unsigned n7,unsigned n8){
    int juntos;


    juntos = n8*(1<<28)+n7*(1<<24)+n6*(1<<20)+n5*(1<<16)+n4*(1<<12)+n3*(1<<8)+n2*(1<<4)+n1;
    hex_code(juntos);
    
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
void _start()
{
  int ret_code = main();
  exit(ret_code);
}

int main()
{ 
  unsigned n1=0,n2=0,n3=0,n4=0,n5=0,n6=0,n7=0,n8=0,total=0;
  char str[48];
  read(STDIN_FD, str, 48);

  //scanf("%[^\n]s",&str);

n1=converter(str,4);
n2=converter(str,10);
n3=converter(str,16);
n4=converter(str,22);
n5=converter(str,28);
n6=converter(str,34);
n7=converter(str,40);
n8=converter(str,46);
//printf("%d,%d,%d %d %d %d %d %d\n",n1,n2,n3,n4,n5,n6,n7,n8);

  for(int i=0; i<48; i=i+6){
     if(str[i]=='-'){
        switch (i){
        
        case 0:  
                n1=(~(n1-1));
                break;
        case 6:  
                n2=(~(n2-1));
                break;
        case 12: 
                n3=(~(n3-1));
                break;
        case 18: 
                n4=(~(n4-1));
                break;
        case 24: 
                n5=(~(n5-1));
                break;
        case 30: 
                n6=(~(n6-1));
                break;
        case 36: 
                n7=(~(n7-1));
                break;
        case 42: 
                n8=(~(n8-1));
                break;
        }
      }
} 
//printf("%d,%u,%d %d %d %d %d %d\n",n1,n2,n3,n4,n5,n6,n7,n8);


n1 = (n1 & n2)&0X000000FF;
n2 = ((n3 | n4)<<8) &0X0000FF00;
n3 = ((n5 ^ n6))&0XFF000000;
n4 = (~ (n7 & n8)>>8)&0X00FF0000;

//printf("%u %u %u %u \n",n1,n2,n3,n4);

total = n1|n2|n4|n3;
hex_code(total);

//converter_hex(n1,n2,n4,n3,n5,n6,n7,n8);
  
 //   hex_code(n1);
  
  //write(STDOUT_FD, str, n);
  return 0;
}