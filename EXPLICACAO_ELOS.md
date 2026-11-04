# ELOS — Explicação do aplicativo

## 1. Visão geral

ELOS significa **Estratégia de Ligação e Otimização Social**. O aplicativo é um
protótipo frontend para aproximar comunidades de uma empresa de mineração por
meio do registro, acompanhamento e atendimento de solicitações sociais.

O projeto foi desenvolvido com:

- React 19;
- TypeScript;
- Vite;
- Tailwind CSS 4;
- CSS global para fontes, tokens visuais e áreas seguras de dispositivos móveis.

## 2. Onde está o código completo

O código executável está separado da explicação da seguinte forma:

```text
.
├── src/
│   ├── App.tsx       # Aplicativo completo: telas, regras, dados e ícones
│   ├── index.css     # Estilos globais, fontes, cores e safe areas
│   ├── main.tsx      # Inicialização do React
│   └── vite-env.d.ts # Tipos fornecidos pelo Vite
├── index.html        # Documento HTML de entrada
├── package.json      # Dependências e comandos
├── tsconfig.json     # Configuração do TypeScript
└── vite.config.ts    # Configuração do Vite e Tailwind
```

O arquivo principal é `src/App.tsx`. Ele concentra o protótipo em um único
arquivo, conforme a estrutura original solicitada.

## 3. Como executar

Instale as dependências:

```bash
pnpm install
```

Inicie o ambiente de desenvolvimento:

```bash
pnpm dev
```

Gere a versão de produção:

```bash
pnpm build
```

No ambiente Figma Make, o servidor de desenvolvimento já é iniciado
automaticamente.

## 4. Acesso administrativo

O protótipo possui um administrador fixo:

```text
E-mail: responsabilidadesocial@gmail.com
Senha: Responsabilidade@123
```

Essas credenciais ficam no início de `src/App.tsx`, nas constantes
`ADMIN_EMAIL` e `ADMIN_PASSWORD`.

> Importante: credenciais no frontend servem apenas para demonstração. Em
> produção, a autenticação precisa ocorrer em um servidor, com senha protegida
> por hash e sessão segura.

## 5. Telas da comunidade

### Login

Valida os campos e identifica se as credenciais informadas são as do
administrador. Usuários comuns acessam o dashboard da comunidade.

### Cadastro

Coleta nome, e-mail e senha. Como este é um protótipo sem banco de dados, o
cadastro apenas atualiza o usuário da sessão atual.

### Recuperação de senha

O fluxo é dividido em três telas:

1. envio do e-mail;
2. digitação de um código com seis dígitos;
3. definição da nova senha.

O envio e a validação são simulados no navegador. Nenhum e-mail real é enviado.

### Dashboard

Exibe:

- resumo das solicitações;
- indicadores por status;
- atalhos de navegação;
- solicitações recentes;
- badge de notificações não lidas.

### Solicitar serviço

O formulário coleta:

- tipo de serviço;
- descrição;
- endereço ou local;
- nível de urgência;
- telefone;
- nomes simulados de fotos ou documentos.

Ao enviar, o aplicativo cria um protocolo no formato `EL-ANO-NÚMERO`, adiciona
a solicitação ao estado global e abre a tela de confirmação.

### Confirmação

Apresenta o protocolo gerado, explica as próximas etapas e oferece atalhos para
voltar ao dashboard ou acompanhar a solicitação.

### Minhas solicitações

Mostra apenas os registros cujo campo `requester` corresponde ao nome do
usuário atual:

```ts
const myRequests = requests.filter(
  (request) => request.requester === user.name,
);
```

Também permite filtrar e abrir o acompanhamento detalhado.

### Notificações

Lista mudanças de status geradas no painel administrativo. As notificações
podem ser marcadas individualmente ou todas de uma vez como lidas.

### Perfil

Permite editar o nome e o e-mail do usuário durante a sessão.

## 6. Painel administrativo

O painel possui quatro áreas:

### Triagem

Exibe solicitações pendentes e permite:

- colocar uma solicitação em análise;
- aprovar e mover para atendimento;
- reprovar, informando uma justificativa.

### Solicitações

Apresenta todos os registros, filtros, busca e ações de alteração de status.

### Dados e relatórios

Resume volumes, prioridades, tipos de serviço e distribuição dos status.

### Perfil Admin

Exibe informações do perfil administrativo e permite sair do painel.

No mobile, ações administrativas adicionais são apresentadas em um painel
adaptado para a parte inferior da tela.

## 7. Fluxo de dados

O componente raiz `App` controla os principais estados:

```ts
const [screen, setScreen] = useState<Screen>("login");
const [user, setUser] = useState<User>(/* usuário inicial */);
const [requests, setRequests] = useState<Request[]>(ALL_REQUESTS);
const [notifications, setNotifications] = useState<Notification[]>([]);
const [toast, setToast] = useState<Notification | null>(null);
```

O estado `screen` funciona como um roteador simples. Dependendo do seu valor, o
React renderiza uma tela diferente.

Quando uma solicitação é criada:

1. `RequestScreen` monta o objeto;
2. `handleNewRequest` adiciona o objeto no início da lista;
3. a tela muda para `confirmation`;
4. o registro passa a aparecer em “Minhas Solicitações”;
5. o mesmo registro aparece imediatamente no painel administrativo.

Quando o administrador altera um status:

1. a solicitação correspondente é atualizada;
2. estados relevantes geram uma notificação;
3. a notificação aparece como toast;
4. o badge de não lidas é incrementado;
5. o novo status aparece no acompanhamento do usuário.

## 8. Dados iniciais

`ALL_REQUESTS` contém solicitações fictícias usadas para demonstrar tabelas,
filtros, indicadores e relatórios sem depender de uma API.

`SERVICE_TYPES` contém as categorias disponíveis no formulário.

`STATUS_COLORS` e `PRIORITY_COLORS` relacionam estados e prioridades às classes
visuais usadas nos badges.

## 9. Responsividade e câmera/notch

A interface utiliza breakpoints do Tailwind para alternar entre navegação
desktop e mobile.

As classes definidas em `src/index.css` usam `env(safe-area-inset-top)` para
evitar que conteúdo importante fique atrás da câmera ou do recorte da tela.
No cabeçalho de “Solicitar serviço”, a proteção está aplicada diretamente no
cabeçalho fixo:

```css
.sticky-safe {
  padding-top: max(
    1rem,
    calc(env(safe-area-inset-top, 0px) + 1rem)
  );
}
```

Assim, o espaçamento permanece correto mesmo quando o cabeçalho fica preso ao
topo durante a rolagem.

## 10. Limitações do protótipo

O projeto atual não possui backend nem banco de dados. Por isso:

- os dados são perdidos ao atualizar a página;
- o cadastro não cria uma conta permanente;
- a recuperação de senha não envia mensagens reais;
- anexos são representados apenas pelo nome do arquivo;
- as credenciais administrativas estão visíveis no código;
- não há sincronização entre navegadores ou dispositivos;
- “tempo real” significa atualização imediata dentro da mesma sessão aberta.

Para uso real, seria necessário adicionar:

- API ou servidor;
- banco de dados;
- autenticação e autorização seguras;
- armazenamento de anexos;
- serviço de e-mail ou SMS;
- persistência de notificações;
- auditoria das ações administrativas.

## 11. Resumo dos arquivos

### `src/App.tsx`

Contém:

- tipos TypeScript;
- dados de demonstração;
- todas as telas;
- componentes de navegação;
- modal de acompanhamento;
- toast de notificação;
- painel administrativo;
- ícones SVG;
- estado global do protótipo.

### `src/index.css`

Contém:

- importação das fontes Outfit e Inter;
- importação do Tailwind CSS;
- tokens de cor e tipografia;
- estilos de safe area;
- aparência das barras de rolagem.

### `src/main.tsx`

Localiza o elemento `#root` e renderiza o componente `App` com React.

### `package.json`

Define as dependências e os comandos `dev`, `build`, `preview` e `format`.
