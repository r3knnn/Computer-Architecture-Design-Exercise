#include "stdio.h"
int main() {
    int a = 5;
    int b = 10;
    int sum = a + b;
    
    int arr[4] = {3, 7, 2, 9};
    int min = arr[0];
    
    for (int i = 1; i < 4; i++) {
        if (arr[i] < min) {
            min = arr[i];
        }
    }
    return 0;
}
