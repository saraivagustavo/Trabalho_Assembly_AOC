#include <stdio.h>

int main(){
    // DECLARAÇÃO DE VARIÁVEIS
    int posicaoX, posicaoY, velocidadeX, velocidadeY, cont;
    cont = 0;

    // ENTRADA DE DADOS
    printf("Digite o KM do carro X: ");
    scanf("%d", &posicaoX);

    printf("Digite o KM do carro Y: ");
    scanf("%d", &posicaoY);

    printf("Digite a velocidade do carro X: ");
    scanf("%d", &velocidadeX);

    printf("Digite a velocidade do carro Y: ");
    scanf("%d", &velocidadeY);

    printf("KMX = %d    |   vx = %d    |    KMY = %d    |   vy = %d\n", posicaoX, velocidadeX, posicaoY, velocidadeY);

    // PROCESSAMENTO
    if(posicaoX < posicaoY){
        if (velocidadeX <= velocidadeY){
            printf("Carro X com velocidade inferior a carro Y, logo não ultrapassará. \n");
            return 0;
        }
        while (posicaoX < posicaoY){
            printf("Hora %d: Carro X em %d e Carro Y em %d \n", cont, posicaoX, posicaoY);
            posicaoX += velocidadeX;
            posicaoY += velocidadeY;
            cont++;
        }
        printf("Hora %d: Carro X em %d e Carro Y em %d \n", cont, posicaoX, posicaoY);
        printf("Carro X ultrapassou Carro Y na hora %d após o KM %d \n", cont, posicaoY);
    }
    else{
        if (velocidadeY <= velocidadeX){
            printf("Carro Y com velocidade inferior a carro X, logo não ultrapassará. \n");
            return 0;
        }
        while (posicaoY < posicaoX){
            printf("Hora %d: Carro Y em %d e Carro X em %d \n", cont, posicaoY, posicaoX);
            posicaoY += velocidadeY;
            posicaoX += velocidadeX;
            cont++;
        }
        printf("Hora %d: Carro Y em %d e Carro X em %d \n", cont, posicaoY, posicaoX);
        printf("Carro Y ultrapassou Carro X na hora %d após o KM %d \n", cont, posicaoX);
    }
    return 0;
}