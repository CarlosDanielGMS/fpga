# Manipulação de LEDs com IA

## Descrição

Este projeto tem como objetivo portar e executar o TensorFlow Lite Micro (TFLM) no processador VexRiscv do SoC LiteX. O sistema deverá carregar e executar o modelo “hello_world” do TensorFlow Lite Micro, utilizando a saída do modelo para controlar o conjunto de LEDs da placa de interface, fazendo os 8 LEDs acenderem sequencialmente de forma proporcional ao valor de saída.

## Arquitetura

O SoC (System on a Chip) deste projeto foi estruturado da seguinte forma:

```
📁 tflm-leds/
├── 📁 firmware/
│    └── 📁 models/
│    |    └── 📄 hello_world_int8_model_data.cc // Implementação do modelo de dados do projeto
│    |    └── 📄 hello_world_int8_model_data.cc // Cabeçalho do modelo de dados do projeto
│    └── 📁 tflm/
│    |    └── 📄 Makefile                       // Comandos de compilação do TensorFlow
│    └── 📄 linker.id                           // Mapeamento de memória do firmware
│    └── 📄 main.cc                             // Funções do firmware
│    └── 📄 Makefile                            // Comandos de compilação do firmware
├── 📁 litex/
│    └── 📄 colorlight_i5.py                    // Funções do SoC, incluindo a do módulo multiplicador
├── 📄 README.md                                // Descrição e instruções do projeto
```

## Instalação

O processo de instalação deste SoC customizado pode ser feito seguindo as instruções abaixo.

### Pré-requisitos

Antes mesmo de compilar o código, é necessário instalar e ativar os softwares a seguir no ambiente de desenvolvimento:

- [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build)
- [LiteX](https://github.com/enjoy-digital/litex)
- [RISC-V GNU Toolchain Prebuilt](https://github.com/zyedidia/riscv-gnu-toolchain-prebuilt)

### Compilação

Com o ambiente preparado, é possível compilar o código executando os seguintes comandos dentro da pasta raíz do projeto (tflm-leds):

Compilar o SoC:
```sh
python3 litex/colorlight_i5.py --board i9 --revision 7.2 --build --cpu-type=vexriscv --ecppack-compress
```

Entrar no diretório do TFLM:
```sh
cd firmware/tflm
```

Compilar o código:
```sh
make
```

Voltar para o diretório do firmware:
```sh
cd ../
```

Compilar o código:
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