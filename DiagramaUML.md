1. Introdução
O presente relatório tem como objetivo descrever o diagrama UML de classes desenvolvido para a aplicação móvel Higia, uma aplicação focada na monitorização de hábitos de saúde e bem-estar.
Este trabalho pretende demonstrar a correta aplicação dos princípios da Programação Orientada por Objetos (POO), nomeadamente encapsulamento, separação de responsabilidades e reutilização de código.
________________________________________
2. Arquitetura do Sistema
A aplicação Higia segue uma arquitetura baseada no padrão Model–Controller–Service, permitindo uma organização clara do código e facilitando a manutenção e evolução do sistema.
•	Model: Responsável por armazenar e representar os dados da aplicação.
•	Controller: Contém a lógica de negócio e gere a comunicação entre a interface e os serviços.
•	Service: Responsável pelo acesso a dados e comunicação com a base de dados (Supabase).
Esta abordagem reduz o acoplamento entre componentes e melhora a legibilidade do código.
________________________________________
3. Descrição das Classes
3.1 RegistrationData
Classe responsável por armazenar temporariamente os dados do utilizador durante o processo de registo. Inclui informação pessoal, preferências alimentares, objetivos, atividade física e credenciais de acesso.
3.2 UserService
Classe de serviço que centraliza as operações relacionadas com o utilizador, nomeadamente criação de contas, obtenção de dados e associação com atividades e objetivos.
3.3 StepCounterService
Classe responsável pela contagem de passos, utilizando sensores do dispositivo ou um simulador quando o sensor não está disponível.
3.4 StepsRepository
Classe responsável pela persistência dos dados de passos na base de dados, garantindo o registo e a consulta do histórico de atividade física.
3.5 PassosModel
Classe de modelo que armazena o estado atual da funcionalidade de passos, incluindo número de passos, objetivo diário e progresso.
3.6 PassosController
Classe que gere a lógica associada à contagem de passos, iniciando, parando e reiniciando a contagem, bem como garantindo a gravação dos dados.
3.7 StepsHistoryModel
Classe que representa o estado do histórico de passos, incluindo lista de registos, estado de carregamento e possíveis erros.
3.8 StepsHistoryController
Classe responsável por obter e preparar os dados do histórico de passos para apresentação ao utilizador.
3.9 SaudeModel
Classe que representa os dados de saúde do utilizador, como peso, altura, idade e nível de atividade.
3.10 SaudeController
Classe que gere a lógica de cálculo e interpretação dos dados de saúde, incluindo recomendações apresentadas ao utilizador.
3.11 LoginModel
Classe que representa o estado do processo de autenticação, armazenando credenciais e estado de carregamento.
3.12 LoginController
Classe responsável pela autenticação do utilizador, validando as credenciais junto da base de dados.
3.13 Sono
Classe responsável pela funcionalidade de sono, incluindo temporizador, qualidade do sono, registos e dicas para melhorar o descanso.
________________________________________
