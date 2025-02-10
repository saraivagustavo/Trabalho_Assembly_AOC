#include <stdio.h>

int main(){
    //DECLARAÇÃO DE VARIÁVEIS
    int lado1, lado2, lado3;

    //ENTRADA DE DADOS
    printf("Digite o valor do lado 1: ");
    scanf("%d", &lado1);
    printf("Digite o valor do lado 2: ");
    scanf("%d", &lado2);
    printf("Digite o valor do lado 3: ");
    scanf("%d", &lado3);

    //PROCESSAMENTO
    if(lado1 == lado2 && lado2 == lado3){
        printf("Triangulo equilátero\n");
    }else if(lado1 == lado2 || lado2 == lado3 || lado1 == lado3){
        printf("Triangulo isósceles\n");
    }else{
        printf("Triangulo escaleno\n");
    }

    return 0;
}