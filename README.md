# Sistemas Operacionais — Atividade 1
## Processos, Threads, Escalonamento e Inferência Local com Ollama

Discente: Mariana de Jesus Silva

Curso: Engenharia da Computação

Instituição: Universidade Federal de Sergipe — UFS

Período: 2026.2

Modalidade: Individual

### Sobre o projeto

Este repositório contém os arquivos desenvolvidos para a Atividade 1 da disciplina de Sistemas Operacionais, cujo objetivo é investigar a execução local de um modelo de linguagem e relacionar seu funcionamento aos mecanismos de um sistema operacional.

A atividade investiga a execução local de um modelo de linguagem utilizando a arquitetura:

Navegador → Open WebUI → Ollama → Modelo de linguagem → Sistema operacional

O objetivo é analisar a relação entre a execução de uma aplicação de inteligência artificial generativa e os mecanismos de Sistemas Operacionais, com foco em processos, threads, escalonamento, CPU, memória, armazenamento, comunicação e chamadas de sistema.

### Trilha selecionada

#### Trilha A — Chat local: Ollama + Open WebUI

A aplicação utiliza o Open WebUI como interface de interação e o Ollama como runtime responsável pela execução local do modelo de linguagem.

### Componentes

- WSL2:	Ambiente de execução Linux;
- Ubuntu 26.04.1 LTS:	Sistema operacional experimental;
- Ollama 0.34.2:	Runtime para execução do modelo;
- Open WebUI v0.11.4:	Interface web para interação com o modelo;
- Llama 3.2 3B: Instruct	Modelo de linguagem;
- CPU:	Processamento da inferência;
- RAM:	Armazenamento temporário dos dados e pesos;
- Armazenamento: Modelos, aplicação, dados e logs.

### Ambiente experimental

- Sistema: WSL2
- Distribuição: Ubuntu 26.04.1 LTS
- CPU: Intel Core i3-10110U
- Núcleos físicos: 2
- Threads: 4
- RAM disponível ao WSL: aproximadamente 5,7 GiB
- Swap: 2,0 GiB
- GPU NVIDIA: não identificada no ambiente WSL2
- Ollama: 0.34.2
- Open WebUI: v0.11.4
- Python: 3.11

### Modelo utilizado

#### Meta Llama 3.2 3B Instruct

- Família: Llama 3.2
- Parâmetros: aproximadamente 3,21 bilhões
- Formato: GGUF
- Quantização: Q4_K_M
- Contexto: 131.072 tokens
- Execução: Ollama
- Tag no Ollama: llama3.2:3b
- Hugging Face: https://huggingface.co/meta-llama/Llama-3.2-3B-Instruct

O modelo foi selecionado considerando o limite de parâmetros estabelecido pela atividade e as características do hardware disponível para execução local.

Observação: os pesos do modelo não são armazenados neste repositório.
### Arquitetura

Usuário -> Navegador Web -> Open WebUI -> HTTP / API local -> Ollama -> Llama 3.2 3B -> CPU / RAM / Armazenamento

### Instalação e execução

#### Ollama

Verificação da versão:

   ollama --version

Download do modelo:

   ollama pull llama3.2:3b

Execução:

   ollama run llama3.2:3b

Verificação dos modelos:

   ollama list

Teste da API:

   curl http://localhost:11434/api/tags

O Ollama foi utilizado localmente através da porta:

   127.0.0.1:11434

#### Open WebUI

O Open WebUI foi executado utilizando uv e Python 3.11.

   curl -LsSf https://astral.sh/uv/install.sh | sh
   source $HOME/.local/bin/env
   uv --version
   DATA_DIR=~/.open-webui uvx --python 3.11 open-webui@latest serve

A interface pode ser acessada localmente em:

   http://localhost:8080

O servidor foi verificado utilizando:

   curl -I http://localhost:8080

com retorno HTTP 200.

### Experimentos

Foram realizadas 12 execuções mensuráveis, distribuídas em três configurações experimentais.

#### Configuração C1 — Execução sequencial

- num_ctx=4096
- Uma requisição por vez
- Entradas curta e longa
- Duas repetições por tipo de entrada

#### Configuração C2 — Execução concorrente

- num_ctx=4096
- Duas requisições simultâneas
- Entradas curta e longa
- Duas repetições

#### Configuração C3 — Ajuste do contexto

- num_ctx=2048
- Execução sequencial
- Entradas curta e longa
- Duas repetições

#### Métricas coletadas

Os experimentos consideraram:

- tempo total de execução;
- tempo de carregamento do modelo;
- quantidade de tokens de entrada;
- quantidade de tokens gerados;
- velocidade de geração em tokens/s;
- ocorrência de erros;
- comportamento dos processos e threads;
- utilização de CPU e memória;
- comunicação entre Open WebUI e Ollama;
- chamadas de sistema.

#### Resultados

Os resultados consolidados foram armazenados em:

resultados/experimentos_final.csv

Resumo por configuração:

Configuração	Tempo total médio	Tokens/s médio	Execuções
C1	17,67 s	5,07	4
C2	20,19 s	4,80	4
C3	17,00 s	5,24	4

Nas 12 execuções principais, não foram registrados erros de execução.

A configuração C2 apresentou o maior tempo total médio entre as três configurações. Os resultados são específicos do ambiente experimental utilizado e não permitem generalizações para outros equipamentos.

#### Processos e threads

Durante a execução foram observados processos relacionados ao funcionamento da aplicação, incluindo:

- ollama;
- llama-server;
- open-webui.

Em uma das coletas representativas do processo llama-server, foram observados:

- 11 threads;
- aproximadamente 42,2% de CPU;
- aproximadamente 42,5% de memória.

A análise de processos e threads foi realizada utilizando ferramentas do sistema Linux, como:

ps -eo pid,ppid,stat,ni,pri,psr,pcpu,pmem,nlwp,comm --sort=-pcpu

e:

ps -eLf

#### Comunicação e portas

Foram identificadas as seguintes portas locais:

- Open WebUI: 127.0.0.1:8080
- Ollama:	127.0.0.1:11434

A verificação foi realizada utilizando:

   ss -lntp | grep -E '11434|8080'

A comunicação ocorre localmente entre a interface Open WebUI e o servidor do Ollama.

####  Chamadas de sistema

Foi realizada uma execução controlada utilizando strace:

   strace -f -c -o ~/strace-resumo.txt ollama run llama3.2:3b "Explique em poucas frases o que é uma thread em um sistema operacional."

A análise registrou 6.080 chamadas de sistema, com destaque para:

futex: 1.520
nanosleep:	1.546
epoll_pwait:	1.089
write:	526
read:	204
mmap:	91
clone3:	9

As chamadas observadas incluem operações relacionadas a sincronização, espera de eventos, leitura e escrita e gerenciamento de memória durante a execução controlada do Ollama.

O resultado completo está disponível em:

resultados/strace-resumo.txt

Observação: os erros contabilizados pelo strace não devem ser interpretados automaticamente como falhas da aplicação. Nas 12 execuções principais dos experimentos não foram registrados erros de execução.

### Estrutura do repositório

SO_UFS_2026_2_Silva_Mariana/

│

├── README.md

│

├── relatorio/

│

├── resultados/

│

├── scripts/

│

└── slide/

#### Principais conteúdos

- README.md — documentação e instruções de reprodução;
- relatorio/ — relatório técnico da atividade;
- resultados/ — dados experimentais e resultados de chamadas de sistema;
- scripts/ — scripts utilizados nos experimentos;
- slide/ — material utilizado na apresentação.

### Reprodutibilidade

Para reproduzir o ambiente experimental, são necessários:

- Windows com WSL2;
- Ubuntu 26.04.1 LTS;
- Ollama 0.34.2;
- Open WebUI v0.11.4;
- Python 3.11;
- uv;
- modelo Llama 3.2 3B Instruct.

Os comandos de instalação e execução estão apresentados neste README e também documentados no relatório técnico.

Os pesos do modelo não estão incluídos no repositório e devem ser obtidos localmente por meio do Ollama.

### Relatório

O relatório técnico apresenta:

- descrição do ambiente experimental;
- arquitetura da aplicação;
- modelo utilizado;
- instalação e configuração;
- processos e threads;
- comunicação e portas;
- chamadas de sistema;
- metodologia experimental;
- resultados;
- análise dos resultados;
- limitações;
- reprodutibilidade;
- uso crítico de IA generativa;
- conclusão.

### Vídeo

O vídeo de apresentação da atividade está disponível em:

URL: [VÍDEO DA APRESENTAÇÃO](https://youtu.be/SH9_ovTPqbU)

O vídeo apresenta a identificação da atividade, arquitetura da aplicação, ambiente experimental, execução local do modelo, processos e threads, chamadas de sistema, experimentos, resultados e limitações.

### Referências principais

- Ollama — https://github.com/ollama/ollama
- Open WebUI — https://github.com/open-webui/open-webui
- Llama 3.2 — https://huggingface.co/meta-llama/Llama-3.2-3B-Instruct
- Linux man-pages — https://man7.org/linux/man-pages/
- Linux Kernel Documentation — https://docs.kernel.org/
