# typst-toolkit

> Toolkit para geração de banners, posters e figuras científicas de qualidade profissional, assistido por Inteligência Artificial.

---

## 1. Visão Geral do Projeto

O **typst-toolkit** é um conjunto de ferramentas que permite a pesquisadores gerar material científico visual — banners para congressos, posters acadêmicos e figuras — de forma simples e rápida.

### O que é Typst?

Typst é um sistema moderno de tipografia, similar ao Word ou LaTeX, mas que gera PDFs de qualidade profissional a partir de texto simples. A diferença fundamental:

- No **Word**, você formata visualmente (arrasta, clica, ajusta).
- No **LaTeX**, você escreve comandos complexos e espera minutos pela compilação.
- No **Typst**, você escreve texto com marcações simples e obtém um PDF pronto em menos de 1 segundo.

Typst é um programa único (um binário de ~15MB), sem dependências. Você instala e funciona. Não precisa de pacotes adicionais, configuração de ambiente, nem internet para compilar.

### O que são agentes de IA e MCP?

**Agentes de IA** são ferramentas de inteligência artificial (como Kiro, Claude, Cursor) que podem ler instruções e gerar material automaticamente. Em vez de você escrever código Typst na mão, você descreve o que quer em linguagem natural ("gere um banner sobre redes neurais com 3 seções") e o agente produz o arquivo completo.

**MCP (Model Context Protocol)** é um protocolo universal que permite a qualquer ferramenta de IA se conectar a programas externos. Neste projeto, usamos um servidor MCP chamado `typst-mcp` que dá à IA a capacidade de:

- Verificar se o código Typst gerado está correto
- Renderizar uma prévia em imagem
- Consultar documentação do Typst
- Converter trechos de LaTeX para Typst

### Para quem é este projeto?

Para pesquisadores que precisam produzir material visual para congressos e eventos acadêmicos, mas não querem (ou não têm tempo de) aprender ferramentas complexas de design. Você descreve o que precisa, a IA gera, e o resultado é um PDF pronto para impressão.

---

## 2. Arquitetura e Decisões

Esta seção explica **por que** cada escolha técnica foi feita. Se você só quer instalar e usar, pule para a seção 3.

### Por que Typst (e não LaTeX, Word, ou Canva)?

| Critério | Typst | LaTeX | Word/Canva |
|----------|-------|-------|------------|
| Tempo de compilação | < 1 segundo | minutos | n/a |
| Instalação | 1 binário, sem dependências | gigabytes de pacotes | licença paga |
| Qualidade tipográfica | Profissional (Knuth-Plass) | Profissional | Boa |
| Sintaxe | Simples e moderna | Complexa | Visual |
| Versionável com Git | Sim (texto puro) | Sim | Não |
| IA consegue gerar | Sim (texto simples) | Sim (mas verboso) | Não (binário) |

Typst combina a qualidade do LaTeX com a simplicidade que uma IA precisa para gerar código confiável. É texto puro (versionável com Git), compila instantaneamente, e a sintaxe é limpa o suficiente para que erros sejam raros.

### Por que Liberation Sans?

**Liberation Sans é metricamente idêntica à Arial** — o resultado visual é exatamente o mesmo, mas Liberation Sans é gratuita e livre de direitos autorais.

Se você colocar um documento feito com Liberation Sans ao lado de um feito com Arial, não conseguirá ver diferença alguma. Cada letra ocupa exatamente o mesmo espaço, as proporções são as mesmas, e a aparência é indistinguível.

Usamos Liberation Sans porque:
- É livre (não depende de licença Microsoft)
- Funciona em qualquer sistema operacional
- É aceita em contextos acadêmicos que exigem "fonte Arial" (como normas ABNT)
- Já vem pré-instalada em muitas distribuições Linux

As fontes estão incluídas na pasta `fonts/` do projeto, então funcionam sem precisar instalar nada no sistema.

### Por que tokens de estilo em YAML?

O arquivo `styles/default.yml` separa o estilo do conteúdo. Isso significa:

- Você pode trocar **todas** as cores e fontes sem mexer no template
- Diferentes eventos ou instituições podem ter estilos próprios
- A IA pode sugerir variações visuais sem reescrever o template

É como trocar a roupa sem mudar o corpo: o conteúdo é o mesmo, mas a apresentação visual muda completamente.

### Por que MCP?

MCP é um protocolo universal que funciona com qualquer ferramenta de IA que o suporte (Kiro, Claude Code, OpenCode, Cursor, Cline, VS Code). Isso significa que o typst-toolkit não está preso a um agente específico — funciona com qualquer um deles.

### Por que não usamos scripts customizados?

Ferramentas mudam seus métodos de instalação com frequência. Um script `setup.sh` escrito hoje pode parar de funcionar em 6 meses quando o Typst ou o uv mudarem como são instalados.

Em vez disso, documentamos cada comando individualmente no README. Cada ferramenta é instalada pelo seu método oficial recomendado. Isso garante que a documentação continue correta por anos — se algo mudar, você atualiza apenas o comando específico.

---

## 3. Pré-requisitos

Antes de começar, você precisa ter:

| Pré-requisito | O que é | Como verificar |
|---------------|---------|----------------|
| **Ubuntu 22+** | Sistema operacional Linux baseado em Ubuntu 22 ou mais recente | `lsb_release -a` |
| **git** | Ferramenta de controle de versão (para baixar o projeto) | `git --version` |
| **curl** | Ferramenta de download via terminal | `curl --version` |

Em geral, git e curl já vêm instalados. Se não estiverem:

```bash
sudo apt update
sudo apt install -y git curl
```

---

## 4. Instalação

Siga os passos abaixo na ordem. Cada passo é independente — se você já tem alguma ferramenta instalada, pode pular o passo correspondente.

### Passo 1: Clonar o repositório

```bash
git clone git@github.com:irwinschmitt/typst-toolkit.git
cd typst-toolkit
```

### Passo 2: Instalar o Rust (necessário para instalar o Typst)

Rust é a linguagem em que o Typst foi escrito. Precisamos do gerenciador de pacotes `cargo` para instalar o Typst.

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
```

Se você já tem Rust/cargo instalado, pule este passo. Verifique com `cargo --version`.

### Passo 3: Instalar o Typst CLI

```bash
cargo install typst-cli
```

Isso instala a versão mais recente do Typst. A compilação pode levar alguns minutos na primeira vez.

> **Alternativa:** Se você já tem o Typst instalado por outro método (pacote do sistema, download direto), qualquer versão >= 0.14 no PATH é suficiente. Verifique com `typst --version`.

### Passo 4: Instalar fontes no sistema (opcional)

O projeto já inclui as fontes na pasta `fonts/` e as usa automaticamente na compilação. Porém, se quiser que as fontes fiquem disponíveis em todo o sistema:

```bash
sudo apt install -y fonts-liberation
```

### Passo 5: Instalar o uv (gerenciador de pacotes Python para o servidor MCP)

O `uv` é usado para rodar o servidor MCP (typst-mcp). É um gerenciador de pacotes Python ultra-rápido.

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
source "$HOME/.local/bin/env"
```

### Passo 6: Configurar o servidor typst-mcp

```bash
git clone https://github.com/johannesbrandenburger/typst-mcp.git .mcp-server/typst-mcp
cd .mcp-server/typst-mcp
uv sync
cd ../..
```

O arquivo `mcp.json` na raiz do projeto já está configurado para encontrar o servidor. Qualquer agente de IA compatível com MCP usará este arquivo automaticamente.

### Passo 7: Instalar Pandoc (opcional — para conversão LaTeX)

Se você tem documentos LaTeX existentes e quer convertê-los para Typst:

```bash
sudo apt install -y pandoc
```

---

## 5. Estrutura do Projeto

```
typst-toolkit/
├── templates/
│   └── banner.typ              # Template principal (banner vertical para congressos)
├── styles/
│   └── default.yml             # Tokens de estilo: cores, fontes, tamanhos, espaçamentos
├── fonts/
│   ├── LiberationSans-Regular.ttf
│   ├── LiberationSans-Bold.ttf
│   ├── LiberationSans-Italic.ttf
│   └── LiberationSans-BoldItalic.ttf  # Fonte completa (normal, negrito, itálico, negrito-itálico)
├── examples/
│   └── banner-example.typ      # Exemplo funcional — use como ponto de partida
├── .mcp-server/
│   └── typst-mcp/              # Servidor MCP (verificação de sintaxe, renderização)
├── mcp.json                    # Configuração do servidor MCP (lida automaticamente pelos agentes)
├── SKILL.md                    # Instruções para agentes de IA (como gerar material)
└── README.md                   # Este arquivo
```

### O que cada pasta faz:

- **templates/** — Contém os templates `.typ`. Atualmente temos o template de banner vertical (90cm x 120cm), ideal para congressos.
- **styles/** — Define a aparência visual (cores, fontes, tamanhos). Você pode criar estilos alternativos copiando o `default.yml`.
- **fonts/** — Fontes incluídas no projeto. O Typst as encontra automaticamente durante a compilação com `--font-path fonts/`.
- **examples/** — Exemplos prontos para compilar. Úteis para testar se tudo funciona e como referência.
- **.mcp-server/** — Servidor que conecta agentes de IA ao Typst. Você não precisa mexer aqui.
- **mcp.json** — Arquivo de configuração que os agentes de IA leem para encontrar o servidor.
- **SKILL.md** — "Manual" que ensina a IA a usar este toolkit. A IA lê este arquivo e aprende as regras do projeto.

---

## 6. Uso

### Compilar um banner manualmente

Para compilar qualquer arquivo `.typ` em PDF, use:

```bash
typst compile --root . --font-path fonts/ examples/banner-example.typ output/banner-example.pdf
```

O comando precisa de duas flags importantes:
- `--root .` — Define a raiz do projeto (para que imports relativos funcionem)
- `--font-path fonts/` — Indica onde estão as fontes Liberation Sans

### Gerar um banner com IA

Se você usa um agente de IA compatível com MCP (Kiro, Claude Code, OpenCode, Cursor):

1. Aponte o agente para este repositório
2. O agente lerá o `SKILL.md` e o `mcp.json` automaticamente
3. Descreva o que você quer em linguagem natural:

   > "Gere um banner para o congresso SBPC 2025 sobre bioinformática com 4 seções: introdução, metodologia, resultados e conclusão. Use cores azul escuro."

4. O agente criará o arquivo `.typ`, validará a sintaxe, e compilará o PDF.

### Criar um banner na mão

Crie um arquivo `.typ` (por exemplo, `output/meu-banner.typ`):

```typst
#import "../templates/banner.typ": banner

#show: banner.with(
  title: "Título do Seu Trabalho",
  authors: ("Seu Nome", "Co-autor"),
  institution: "Sua Universidade",
  sections: (
    (heading: "Introdução", content: [
      Seu texto aqui. Pode usar *negrito* e _itálico_.
    ]),
    (heading: "Metodologia", content: [
      Descrição dos métodos utilizados.
    ]),
    (heading: "Resultados", content: [
      Apresentação dos resultados obtidos.
    ]),
    (heading: "Conclusão", content: [
      Suas conclusões e trabalhos futuros.
    ]),
  ),
)
```

Compile:

```bash
typst compile --root . --font-path fonts/ output/meu-banner.typ output/meu-banner.pdf
```

---

## 7. Verificação

Após a instalação, execute estes comandos para confirmar que tudo funciona:

### Typst CLI

```bash
typst --version
```

**Esperado:** Versão 0.14 ou superior (ex: `typst 0.14.0`).

### Compilação de um exemplo

```bash
mkdir -p output
typst compile --root . --font-path fonts/ examples/banner-example.typ output/test-banner.pdf
```

**Esperado:** Arquivo `output/test-banner.pdf` gerado sem erros. Abra o PDF para confirmar que tem conteúdo formatado (cabeçalho azul, título, seções).

### Fontes carregando corretamente

```bash
typst fonts --font-path fonts/ | grep -i liberation
```

**Esperado:** Linhas contendo "Liberation Sans" (confirmando que as fontes foram encontradas).

### Servidor MCP (uv instalado)

```bash
uv --version
```

**Esperado:** Versão do uv (ex: `uv 0.7.x`).

### Servidor MCP (importação funcional)

```bash
cd .mcp-server/typst-mcp && uv run python -c "import server; print('OK')" && cd ../..
```

**Esperado:** `OK` (sem erros de importação).

### Validação do mcp.json

```bash
python3 -c "import json; json.load(open('mcp.json')); print('mcp.json válido')"
```

**Esperado:** `mcp.json válido`.

---

## 8. Solução de Problemas

### Problema: `error: font "Liberation Sans" not found`

**Causa:** O Typst não está encontrando a pasta de fontes.

**Solução:** Certifique-se de usar a flag `--font-path fonts/` no comando de compilação e de estar rodando o comando a partir da raiz do projeto:

```bash
cd /caminho/para/typst-toolkit
typst compile --root . --font-path fonts/ seu-arquivo.typ saida.pdf
```

---

### Problema: `error: file not found (package or import path)`

**Causa:** O Typst não consegue resolver imports relativos porque a raiz do projeto não foi definida.

**Solução:** Sempre use `--root .` no comando de compilação. Exemplo:

```bash
typst compile --root . --font-path fonts/ output/meu-banner.typ output/meu-banner.pdf
```

Se o erro persistir, verifique se você está na pasta correta (`typst-toolkit/`) e se o caminho do import no seu arquivo `.typ` está correto (deve começar com `../templates/`).

---

### Problema: `cargo: command not found`

**Causa:** O Rust/cargo não está no PATH. Isso acontece quando você instala o Rust mas não recarrega o terminal.

**Solução:**

```bash
source "$HOME/.cargo/env"
```

Se isso não resolver, reinstale o Rust:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
```

---

### Problema: `typst: command not found`

**Causa:** O Typst não foi instalado ou o binário não está no PATH.

**Solução:**

```bash
source "$HOME/.cargo/env"
cargo install typst-cli
```

Após a instalação, `typst --version` deve funcionar. Se instalou por outro método, verifique se o binário está em um diretório que está no seu PATH.

---

### Problema: Servidor MCP não inicia / agente não conecta

**Causa:** O `uv` não está instalado, ou o typst-mcp não foi clonado corretamente.

**Solução:**

1. Verifique se o uv está instalado:
   ```bash
   uv --version
   ```
   Se não estiver, instale (Passo 5 da instalação).

2. Verifique se o servidor existe:
   ```bash
   ls .mcp-server/typst-mcp/server.py
   ```
   Se não existir, repita o Passo 6 da instalação.

3. Verifique se as dependências estão instaladas:
   ```bash
   cd .mcp-server/typst-mcp && uv sync && cd ../..
   ```

---

### Problema: PDF gerado está em branco

**Causa:** O array `sections` está vazio ou a sintaxe dos parâmetros está incorreta.

**Solução:** Verifique se o seu arquivo `.typ` tem ao menos uma seção:

```typst
sections: (
  (heading: "Título", content: [Conteúdo aqui.]),
),
```

Note a vírgula após o último parêntese da seção — é necessária em Typst quando há apenas um item no array.

---

## 9. Atualização

### Atualizar o Typst CLI

```bash
cargo install typst-cli
```

O cargo detecta automaticamente se há uma versão nova e a instala. Se a versão atual já é a mais recente, ele informa e não faz nada.

### Atualizar o servidor typst-mcp

```bash
cd .mcp-server/typst-mcp
git pull
uv sync
cd ../..
```

Isso baixa as últimas mudanças do servidor e atualiza as dependências Python.

### Atualizar o Rust (se necessário)

```bash
rustup update
```

---

## 10. Substituição de Fontes

O projeto usa Liberation Sans por padrão, mas você pode usar qualquer fonte TrueType (.ttf) ou OpenType (.otf).

### Como trocar a fonte:

**1. Coloque os arquivos da fonte na pasta `fonts/`:**

```bash
cp /caminho/para/MinhaFonte-Regular.ttf fonts/
cp /caminho/para/MinhaFonte-Bold.ttf fonts/
cp /caminho/para/MinhaFonte-Italic.ttf fonts/
cp /caminho/para/MinhaFonte-BoldItalic.ttf fonts/
```

**2. Atualize o arquivo `styles/default.yml`:**

Abra `styles/default.yml` e altere as linhas de fonte:

```yaml
fonts:
  title: "Minha Fonte"    # Nome da família da fonte (sem Regular/Bold)
  body: "Minha Fonte"
```

O nome da fonte deve ser o nome da **família** (family name), não o nome do arquivo. Por exemplo, se o arquivo se chama `Roboto-Regular.ttf`, o nome da família é `Roboto`.

**3. Recompile:**

```bash
typst compile --root . --font-path fonts/ examples/banner-example.typ output/test-fonte.pdf
```

### Como descobrir o nome da família de uma fonte

```bash
typst fonts --font-path fonts/
```

Este comando lista todas as fontes que o Typst consegue encontrar na pasta, com seus nomes de família.

### Fontes populares para material acadêmico

| Fonte | Estilo | Observação |
|-------|--------|------------|
| Liberation Sans | Sans-serif | Padrão do projeto (= Arial) |
| Liberation Serif | Serifada | Equivalente livre do Times New Roman |
| TeX Gyre Termes | Serifada | Alternativa profissional ao Times |
| Inter | Sans-serif | Moderna, excelente legibilidade |
| Fira Sans | Sans-serif | Boa para títulos e textos técnicos |

### Dica: fontes diferentes para título e corpo

Você pode usar uma fonte para títulos e outra para o texto:

```yaml
fonts:
  title: "Fira Sans"       # Fonte para títulos e cabeçalhos
  body: "Liberation Sans"  # Fonte para o texto corrido
```
