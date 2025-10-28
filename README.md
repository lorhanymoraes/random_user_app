O **Random User App** é um aplicativo desenvolvido em Flutter com o objetivo de apresentar usuários aleatórios, simulando uma lista dinâmica e interativa. Ele utiliza arquitetura MVVM, Repository Strategy, gerencimaneto de estado com Bloc para garantir um código eficiente, com modularidade e facilidade de manutenção.

## Principais Funcionalidades
- **Busca de Usuários Aleatórios:** O app consome uma fonte de dados ([API)](https://randomuser.me/api/) para exibir perfis de usuários de forma dinâmica.
- **Persistência Local:** Usuários podem ser salvos e removidos da lista de favoritos, utilizando o serviço de SharedPreferences para armazenamento local.
- **Atualização Automática:** A tela inicial foi configurada para buscar novos usuários periodicamente (a cada 5 seg), tornando a experiência mais dinâmica.
- **Detalhes do Usuário:** Ao selecionar um usuário, o app exibe informações detalhadas e permite ações como persistir ou remover o usuário.
- **Gerenciamento de Estado:** Toda a lógica de negócio é separada da interface por meio de Blocs, facilitando testes e evolução do código.

## Arquitetura
- **Gerenciamento de Estado:** Utiliza o pacote `flutter_bloc` para implementar o padrão Bloc, onde eventos são disparados e estados são emitidos conforme a lógica definida.
- **Injeção de Dependências:** O usecase `GetRandomUserUsecase` é obtido via `Modular.get`, facilitando o desacoplamento e a testabilidade.
- **Ticker:** O ticker é utilizado para buscar usuários periodicamente, permitindo atualizações automáticas na tela.
- **Eventos e Estados:** Os arquivos `home_event.dart` e `home_state.dart` definem os eventos que o bloc pode receber e os estados que ele pode emitir.

### 1. Flutter Modular – Organização e Escalabilidade
Optei pelo Flutter Modular para estruturar a aplicação de forma modular e escalável. Essa abordagem permite separar as responsabilidades por módulos independentes, facilitando o isolamento de funcionalidades, a manutenção e os testes.

Além disso, o Modular fornece:
- Injeção de dependência automática, reduzindo o acoplamento entre camadas.
- Navegação hierárquica e desacoplada, o que facilita o controle de rotas complexas e a reutilização de módulos em diferentes partes do app.
- Suporte a lazy loading, melhorando o desempenho inicial do aplicativo.

Em resumo, o Modular nos permite manter o projeto limpo, com baixo acoplamento e alta coesão, mesmo à medida que o app cresce.

### 2. MVVM (Model-View-ViewModel) – Clareza e Testabilidade
O padrão MVVM foi adotado para melhorar a organização entre a lógica de apresentação e a camada de UI.

Cada camada tem uma responsabilidade clara:
- Model: representa os dados e regras de negócio.
- View: responsável apenas pela exibição dos dados e interação do usuário.
- ViewModel: atua como intermediário entre o Model e a View, processando dados e reagindo a eventos da interface.

Essa separação facilita:
- Testes unitários e de integração, já que a lógica da UI está isolada.
- Reutilização de código entre diferentes telas ou plataformas.
- Redução de bugs e melhor manutenção da base de código.
  
### 3. Repository Strategy – Abstração e Flexibilidade
A Repository Strategy foi escolhida para centralizar o acesso a dados e abstrair as fontes de informação (API, banco local, cache, etc.). Com isso, as camadas superiores (como o ViewModel ou o Bloc) não precisam saber de onde vêm os dados, apenas que o repositório os fornece.

Benefícios principais:
- Facilita substituir ou combinar fontes de dados (por exemplo, alternar entre API e cache local).
- Garante consistência na forma como os dados são acessados e tratados.
- Favorece injeção de dependência e mocking em testes.

### 4. BLoC (Business Logic Component) – Controle de Estado Reativo
Utilizamos o BLoC como mecanismo de gerenciamento de estado reativo. Ele fornece uma estrutura clara para lidar com eventos, transições e estados, mantendo a lógica de negócio completamente separada da camada de apresentação.

Principais vantagens:
- Previsibilidade e rastreabilidade do fluxo de dados (cada mudança de estado é explícita).
- Padronização do ciclo de vida da lógica de negócios em todo o app.
- Reatividade, permitindo atualizações automáticas na interface conforme o estado muda.
- Facilita testes unitários e debugging, pois cada evento gera um estado específico e reproduzível.

## Experiência do Usuário
A interface é intuitiva, com animações de carregamento, feedback visual para ações (sucesso/erro) e navegação fluida entre telas. O usuário pode explorar perfis, salvar favoritos e gerenciar sua lista de usuários persistidos.

## Testes e Qualidade
O projeto foi estruturado para facilitar a criação de testes unitários e de integração, garantindo confiabilidade nas principais funcionalidades e facilitando futuras evoluções.

