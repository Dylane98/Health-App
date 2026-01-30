Higia é uma aplicação móvel desenvolvida em Flutter com o objetivo de apoiar os utilizadores na monitorização de hábitos de saúde e bem-estar, como atividade física, sono e dados gerais de saúde.

O projeto foi desenvolvido no âmbito da unidade curricular de **Programação Orientada por Objetos**, aplicando conceitos como encapsulamento, separação de responsabilidades e modelação através de **diagramas UML de classes**.

---

Arquitetura da Aplicação

A aplicação segue uma arquitetura baseada no padrão **Model–Controller–Service**, permitindo uma organização clara do código e facilitando a manutenção e evolução do sistema.

Model
Responsável por representar os dados da aplicação e o estado das funcionalidades.

Principais classes:
- `RegistrationData`
- `PassosModel`
- `StepsHistoryModel`
- `SaudeModel`
- `LoginModel`

Controller
Responsável pela lógica de negócio e pela coordenação entre a interface gráfica e os serviços.

Principais classes:
- `PassosController`
- `StepsHistoryController`
- `SaudeController`
- `LoginController`

 Service
Responsável pela comunicação com a base de dados e serviços externos.

Principais classes:
- `UserService`
- `StepCounterService`
- `StepsRepository`
- `LookupService`
- `AuthService`

---

 Diagrama UML de Classes

O diagrama UML de classes do projeto representa as principais entidades do sistema e as suas responsabilidades, destacando:

- Separação clara entre dados (Model), lógica (Controller) e acesso a dados (Service)
- Redução do acoplamento entre componentes
- Facilidade de extensão e reutilização de código

Este diagrama foi utilizado como base para o desenvolvimento e organização do código da aplicação.

---

Funcionalidades Principais

Contagem de Passos
- Contagem de passos em tempo real
- Definição de objetivo diário
- Registo automático dos passos
- Histórico de atividade diária

Saúde
- Visualização de dados de saúde do utilizador
- Cálculo automático de idade
- Apresentação de recomendações com base no nível de atividade

Sono
- Temporizador de sono e sonecas
- Avaliação da qualidade do sono
- Registo local das sessões
- Dicas para melhorar o descanso

Autenticação
- Registo de utilizadores
- Login com validação de credenciais
- Recuperação de password

---

Base de Dados

A aplicação utiliza **Supabase** como backend, sendo responsável por:
- Armazenamento de utilizadores
- Registo de passos
- Associação de objetivos e motivações
- Consulta de dados de saúde

---

Conceitos de Programação Utilizados

- Programação Orientada por Objetos (POO)
- Encapsulamento
- Separação de responsabilidades
- Modelação UML
- Padrão Model–Controller–Service

---

Execução do Projeto

1. Clonar o repositório:
   ```bash
   git clone https://github.com/Dylane98/Health-App.git
