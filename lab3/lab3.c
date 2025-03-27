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

void _start()
{
  int ret_code = main();
  exit(ret_code);
}

#define STDIN_FD  0
#define STDOUT_FD 1


int decimal(char str[32],int n){
  
  int mul=1, soma =0;
  char somaa[2];

  for(int j=0;j<n-1;j++){
    for(int k = 0;k<j;k++){
        mul=mul*2;
    }
        soma = soma + mul*str[j];
    }
  return soma;  
}
int endige(char str[32]){
  char correto [32];
  for(int i=0; i<32; i++){
    correto[i] = str[i];
  } 
  for(int i=0;i<8;i++){
    correto[i+24]=str[i];
  }
  for(int i=8;i<16;i++){
    correto[i+16]=str[i];
  }
  for(int i=23;i>16;i++){
    correto[i-8]=str[i];
  }
  for(int i=31;i>24;i++){
    correto[i-8]=str[i];
  }
  return decimal(correto,32);
}
int hexa(char str[32],int n){
  int trans=0;
  char valor[4];
    for (int i=0; i<4;i++)
    {
      valor[i]=str[n];
      n++;
    }
    trans=decimal(valor,4);
    if(trans>9){
      trans=trans+31;
    }
    return trans;
}
int main()
{ 
  char str[33],somaa[2];
  /* Read up to 8 bytes from the standard input into the str buffer */
  int n = read(STDIN_FD, str, 33);
  
  somaa[0] = decimal(str ,n);
  
  if(str[31]==1){
    somaa[1]=45;
  }else{
    somaa[1]=0;
  }
  write(STDOUT_FD, somaa, n);

  somaa[1]=0;
  somaa[0]=endige(str);
  write(STDOUT_FD, somaa, n);

  char hex[8];
  int j=0;
  for(int i=0;i<32;i=i+4){
    hex[j]=hexa(str,i);
    j++;
  }

  /* Write n bytes from the str buffer to the standard output */
 
  return 0;

}
