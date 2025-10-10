# Produto Escalar

## Descrição

Este projeto tem como objetivo criar um circuito para realizar e acelerar o cálculo de produto escalar utilizando um SoC (System on a Chip).
O produto escalar de dois vetores é formado pela multiplicação de seus componentes correspondentes e pela soma dos produtos resultantes.

## Arquitetura

O SoC (System on a Chip) deste projeto foi estruturado da seguinte forma:

```
📁 dot-product/
├── 📁 firmware/
│    └── 📄 linker.id         // Mapeamento de memória do firmware
│    └── 📄 main.c            // Funções do firmware
│    └── 📄 Makefile          // Comandos de compilação do firmware
├── 📁 litex/
│    └── 📄 __init__.py // Inicialização padrão do LiteX
│    └── 📄 colorlight_i5.py  // Funções do SoC, incluindo a do módulo multiplicador
│    └── 📄 dot_product.py    // Wrapper  que conecta o módulo multiplicador ao SoC
├── 📁 rtl/
│    └── 📄 dot_product.sv    // Bloco em SystemVerilog contendo a descrição de hardware do módulo multiplicador
├── 📁 tb/
│    └── 📄 tb_dot_product.sv // Testbench do módulo multiplicador
├── 📄 Makefile               // Comandos de compilação do hardware
├── 📄 README.md              // Descrição e instruções do projeto
├── 📄 rules.mk               // Definições auxiliares para o processo de compilação
```

## Mapa CSR

Os registradores do módulo multiplicador foram definidos da seguinte forma:

| Endereço         | Registrador        | Tamanho (words)  | Acesso | Descrição                            |
|------------------|--------------------|------------------|--------|--------------------------------------|
| 0xf0000000       | START              | 1                | W      | Inicia o cálculo do produto escalar  |
| 0xf0000004       | A0                 | 1                | W      | Elemento A[0] do vetor               |
| 0xf0000008       | A1                 | 1                | W      | Elemento A[1] do vetor               |
| 0xf000000C       | A2                 | 1                | W      | Elemento A[2] do vetor               |
| 0xf0000010       | A3                 | 1                | W      | Elemento A[3] do vetor               |
| 0xf0000014       | A4                 | 1                | W      | Elemento A[4] do vetor               |
| 0xf0000018       | A5                 | 1                | W      | Elemento A[5] do vetor               |
| 0xf000001C       | A6                 | 1                | W      | Elemento A[6] do vetor               |
| 0xf0000020       | A7                 | 1                | W      | Elemento A[7] do vetor               |
| 0xf0000024       | B0                 | 1                | W      | Elemento B[0] do vetor               |
| 0xf0000028       | B1                 | 1                | W      | Elemento B[1] do vetor               |
| 0xf000002C       | B2                 | 1                | W      | Elemento B[2] do vetor               |
| 0xf0000030       | B3                 | 1                | W      | Elemento B[3] do vetor               |
| 0xf0000034       | B4                 | 1                | W      | Elemento B[4] do vetor               |
| 0xf0000038       | B5                 | 1                | W      | Elemento B[5] do vetor               |
| 0xf000003C       | B6                 | 1                | W      | Elemento B[6] do vetor               |
| 0xf0000040       | B7                 | 1                | W      | Elemento B[7] do vetor               |
| 0xf0000044       | DONE               | 1                | R      | Indica se o cálculo foi concluído    |
| 0xf0000048       | RESULT             | 2                | R      | Resultado 64 bits do produto escalar |

## Instalação

O processo de instalação deste SoC customizado pode ser feito seguindo as instruções abaixo.

### Pré-requisitos

Antes mesmo de compilar o código, é necessário instalar e ativar os softwares a seguir no ambiente de desenvolvimento:

- [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build)
- [LiteX](https://github.com/enjoy-digital/litex)
- [RISC-V GNU Compiler Toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain)

### Compilação

Com o ambiente preparado, é possível compilar o código executando os seguintes comandos dentro da pasta raíz do projeto (dot-product):

Compilar o código:
```sh
python3 litex/colorlight_i5.py --board i9 --revision 7.2 --build
```

Entrar no diretório do firmware:
```sh
cd firmware/
```

Gerar o arquivo binário:
```sh
make
```

Voltar para a pasta raíz do projeto:
```sh
cd ../
```

Carregar o SoC para a placa:
```sh
openFPGALoader -b colorlight-i5 build/colorlight_i5/gateware/colorlight_i5.bit
```

Abrir o terminal (lembre-se de substituir a porta COM pela que está conectada à placa):
```sh
litex_term --kernel firmware/main.bin /dev/ttyACM0
```

Reiniciar a placa:
```sh
reboot
```

## Utilização

Com o runtime aberto, execute o seguinte comando no terminal da placa para executar o módulo multiplicador:
```sh
prod
```

Por último, siga as instruções da placa para inserir os valores desejados e ver o resultado do cálculo no terminal.
