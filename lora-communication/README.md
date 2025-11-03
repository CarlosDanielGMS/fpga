# Transmissão de dados via LoRa

## Descrição

Este projeto tem como objetivo desenvolver um sistema de comunicação sem fio entre um SoC (System on a Chip) customizado rodando em uma FPGA ColorLight i9 e um dispositivo externo.

## Arquitetura

O SoC (System on a Chip) deste projeto foi estruturado da seguinte forma:

```
📁 lora-communication/
├── 📁 receiver/
│    └── 📁 include/
│         └── 📄 rfm96* // Biblioteca do LoRa
│         └── 📄 ssd1306* // Biblioteca do display
│    └── 📄 CMakeLists.txt // Parâmetros de compilação
│    └── 📄 receiver.c // Código do receptor
├── 📁 transmitter/
│    └── 📁 firmware/
│         └── 📄 linker.id // Mapeamento de memória do firmware
│         └── 📄 lora.c // Implementação do código do LoRa
│         └── 📄 lora.h // Cabeçalho do código do LoRa
│         └── 📄 main.c // Funções do firmware
│         └── 📄 Makefile // Comandos de compilação do firmware
│         └── 📄 sensor.c // Implementação do código do sensor
│         └── 📄 sensor.h // Cabeçalho do código do sensor
│    └── 📁 litex/
│         └── 📄 colorlight_i5.py // Funções do SoC, incluindo a do módulo multiplicador
│    └── 📄 Makefile // Comandos de compilação do hardware
│    └── 📄 rules.mk // Definições auxiliares para o processo de compilação
├── 📄 README.md              // Descrição e instruções do projeto
```

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
python3 litex/colorlight_i5.py --board i9 --revision 7.2 --build --cpu-type=picorv32 --ecppack-compress
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

Com o runtime aberto, execute o seguinte comando no terminal da placa para executar o módulo:
```sh
sensor
```