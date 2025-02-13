#include <stdio.h>

int f_formaTriangulo(int X, int Y, int Z){
    // DECLARAÇÃO DE VARIÁVEIS  
    int maior;
    
    // PROCESSAMENTO
    for(int i = 0; i < 3; i++){
        if(X > Y && X > Z){
            maior = X;
            if(maior < Y + Z){
                return 1;
            }else{
                return 0;
            }
        }else if(Y > X && Y > Z){
            maior = Y;
            if(maior < X + Z){
                return 1;
            }else{
                return 0;
            }
        }
        else{
            maior = Z;
            if(maior < X + Y){
                return 1;
            }else{
                return 0;
            }
        }  
    }
}
int main(){
    // DECLARAÇÃO DE VARIÁVEIS
    int X, Y, Z;

    // ENTRADA DE DADOS
    printf("Digite o valor do lado X: ");
    scanf("%d", &X);

    printf("Digite o valor do lado Y: ");
    scanf("%d" , &Y);

    printf("Digite o valor do lado Z: ");
    scanf("%d" , &Z);

    // PROCESSAMENTO
    if(f_formaTriangulo(X, Y, Z) == 1){
        printf("X, Y e Z formam um triângulo\n");
    }else{
        printf("X, Y e Z não formam um triângulo\n");
    }
    return 0;
}