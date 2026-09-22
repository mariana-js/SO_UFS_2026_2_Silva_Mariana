# Sistemas Operacionais — Atividade 1
## Processos, Threads, Escalonamento e Inferência Local com Ollama

Discente: Mariana Silva
Curso: Engenharia da Computação
Instituição: Universidade Federal de Sergipe — UFS
Período: 2026.2
Modalidade: Individual

### Sobre o projeto

Este repositório contém os arquivos referentes à Atividade 1 da disciplina de Sistemas Operacionais.

A atividade investiga a execução local de um modelo de linguagem utilizando a arquitetura:

Navegador → Open WebUI → Ollama → Modelo de linguagem → Sistema operacional

O objetivo é analisar a relação entre a execução de uma aplicação de inteligência artificial generativa e os mecanismos de Sistemas Operacionais, com foco em processos, threads, escalonamento, CPU, memória, armazenamento, comunicação e chamadas de sistema.

### Trilha selecionada

#### Trilha A — Chat local: Ollama + Open WebUI

### Componentes

Componente	Utilização
WSL2	Ambiente de execução Linux
Ubuntu	Sistema operacional experimental
Ollama	Runtime para execução do modelo
Open WebUI	Interface web para interação com o modelo
Llama 3.2 3B Instruct	Modelo de linguagem
CPU	Processamento da inferência
RAM	Armazenamento temporário dos dados e pesos
Armazenamento	Modelos, aplicação, dados e logs

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

### Modelo utilizado

#### Meta Llama 3.2 3B Instruct

- Família: Llama 3.2
- Parâmetros: aproximadamente 3,21 bilhões
- Formato: GGUF
- Quantização: Q4_K_M
- Execução: Ollama
- Hugging Face: https://huggingface.co/meta-llama/Llama-3.2-3B-Instruct

O modelo foi escolhido considerando o limite de parâmetros estabelecido na atividade e as características do hardware disponível para execução local.

### Arquitetura

Usuário
   │
   ▼
Navegador Web
   │
   ▼
Open WebUI
   │
   │ HTTP / API local
   ▼
Ollama
   │
   ▼
Llama 3.2 3B
   │
   ▼
CPU / RAM / Armazenamento

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

#### Open WebUI

O Open WebUI foi executado utilizando uv e Python 3.11.

curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env
uv --version
DATA_DIR=~/.open-webui uvx --python 3.11 open-webui@latest serve

A interface pode ser acessada localmente em:

http://localhost:8080

### Experimentos

Os experimentos serão utilizados para analisar:

- processos;
- threads;
- utilização de CPU;
- utilização de memória;
- comunicação entre Open WebUI e Ollama;
- chamadas de sistema;
- comportamento sob diferentes cargas;
- impacto de entradas maiores;
- concorrência;
- responsividade da aplicação.

Serão realizadas pelo menos 12 execuções mensuráveis, organizadas em diferentes configurações experimentais.

Os resultados, tabelas e gráficos serão adicionados ao repositório após a coleta dos dados.

### Estrutura do repositório

SO_UFS_2026_2_Silva_Mariana/
│
├── README.md
├── scripts/
├── configuracao/
├── dados/
├── logs/
├── evidencias/
├── graficos/
├── documentacao/
└── VIDEO.md

Os diretórios serão preenchidos progressivamente durante a realização dos experimentos.

Os pesos do modelo não serão armazenados neste repositório.

### Reprodutibilidade

Para reproduzir o ambiente experimental, são necessários:

- Windows com WSL2;
- Ubuntu 26.04.1 LTS;
- Ollama 0.34.2;
- Open WebUI v0.11.4;
- Python 3.11;
- uv;
- modelo Llama 3.2 3B Instruct.

Os comandos completos utilizados no experimento serão documentados no relatório e neste repositório.

### Resultados

Os resultados experimentais serão adicionados após a realização das medições.

Serão apresentados:

- tabelas de execução;
- consumo de CPU;
- consumo de memória;
- número de threads;
- tempo de resposta;
- análise de processos;
- chamadas de sistema;
- gráficos;
- análise dos resultados.

### Relatório

O relatório completo da atividade contém a descrição do ambiente, metodologia, evidências, experimentos, resultados, análise e conclusões.

### Vídeo

O vídeo de apresentação da atividade será disponibilizado posteriormente.

URL: a definir.

### Referências principais

- Ollama — https://github.com/ollama/ollama
- Open WebUI — https://github.com/open-webui/open-webui
- Llama 3.2 — https://huggingface.co/meta-llama/Llama-3.2-3B-Instruct
- Linux man-pages — https://man7.org/linux/man-pages/
- Linux Kernel Documentation — https://docs.kernel.org/
