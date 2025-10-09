#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <irq.h>
#include <uart.h>
#include <console.h>
#include <generated/csr.h>

static char *readstr(void)
{
    char c[2];
    static char s[64];
    static int ptr = 0;

    if(readchar_nonblock()) {
        c[0] = readchar();
        c[1] = 0;
        switch(c[0]) {
            case 0x7f:
            case 0x08:
                if(ptr > 0) {
                    ptr--;
                    putsnonl("\x08 \x08");
                }
                break;
            case 0x07:
                break;
            case '\r':
            case '\n':
                s[ptr] = 0x00;
                putsnonl("\n");
                ptr = 0;
                return s;
            default:
                if(ptr >= (sizeof(s) - 1))
                    break;
                putsnonl(c);
                s[ptr] = c[0];
                ptr++;
                break;
        }
    }
    return NULL;
}

static char *get_token(char **str)
{
    char *c, *d;

    c = (char *)strchr(*str, ' ');
    if(c == NULL) {
        d = *str;
        *str = *str+strlen(*str);
        return d;
    }
    *c = 0;
    d = *str;
    *str = c+1;
    return d;
}

static void prompt(void)
{
    printf("RUNTIME>");
}

static void help(void)
{
    puts("Available commands:");
    puts("help                            - this command");
    puts("reboot                          - reboot CPU");
    puts("led                             - led test");
    puts("fibo                            - fibonacci test");
}

static void reboot(void)
{
    ctrl_reset_write(1);
}

static void toggle_led(void)
{
    int i;
    printf("invertendo led...\n");
    i = leds_out_read();
    leds_out_write(!i);
}


static void calculate_dot_product(void)
{
    int a0, a1, a2, a3, a4, a5, a6, a7;
    int b0, b1, b2, b3, b4, b5, b6, b7;
    uint64_t result;
    
    // solicita os valores
    printf("Digite A0\n");
    scanf("%d", &a0);
    printf("Digite A1\n");
    scanf("%d", &a1);
    printf("Digite A2\n");
    scanf("%d", &a2);
    printf("Digite A3\n");
    scanf("%d", &a3);
    printf("Digite A4\n");
    scanf("%d", &a4);
    printf("Digite A5\n");
    scanf("%d", &a5);
    printf("Digite A6\n");
    scanf("%d", &a6);
    printf("Digite A7\n");
    scanf("%d", &a7);
    
    printf("Digite B0\n");
    scanf("%d", &b0);
    printf("Digite B1\n");
    scanf("%d", &b1);
    printf("Digite B2\n");
    scanf("%d", &b2);
    printf("Digite B3\n");
    scanf("%d", &b3);
    printf("Digite B4\n");
    scanf("%d", &b4);
    printf("Digite B5\n");
    scanf("%d", &b5);
    printf("Digite B6\n");
    scanf("%d", &b6);
    printf("Digite B7\n");
    scanf("%d", &b7);

    // escreve os valores e dá start
    dot_product_a0_write(a0);
    dot_product_a1_write(a1);
    dot_product_a2_write(a2);
    dot_product_a3_write(a3);
    dot_product_a4_write(a4);
    dot_product_a5_write(a5);
    dot_product_a6_write(a6);
    dot_product_a7_write(a7);
    
    dot_product_b0_write(b0);
    dot_product_b1_write(b1);
    dot_product_b2_write(b2);
    dot_product_b3_write(b3);
    dot_product_b4_write(b4);
    dot_product_b5_write(b5);
    dot_product_b6_write(b6);
    dot_product_b7_write(b7);

    dot_product_start_write(1);
    for (int i = 0; i < 256; ++i) { /* pequeno atraso */ }
    dot_product_start_write(0);

    // espera cálculo terminar
    while (!dot_product_done_read());

    // lê resultado
    result = dot_product_result_read();
    printf("Resultado = %llu\n", result);
}

static void console_service(void) {
    char *str;
    char *token;

    str = readstr();
    if(str == NULL) return;
    token = get_token(&str);
    if(strcmp(token, "help") == 0)
        help();
    else if(strcmp(token, "reboot") == 0)
        reboot();
    else if(strcmp(token, "led") == 0)
        toggle_led();
    else if(strcmp(token, "prod") == 0)
        calculate_dot_product();
    prompt();
}

int main(void) {
#ifdef CONFIG_CPU_HAS_INTERRUPT
    irq_setmask(0);
    irq_setie(1);
#endif
    uart_init();

    printf("Hellorld!\n");
    help();
    prompt();

    while(1) {
        console_service();
    }

    return 0;
}
