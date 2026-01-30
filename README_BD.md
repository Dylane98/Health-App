README – Base de Dados Higia
Este documento descreve os passos necessários para replicar a base de dados do projeto Higia, bem como a sua configuração no Supabase.
1. Tecnologias Utilizadas
- PostgreSQL (via Supabase)
- Supabase Auth
- SQL (DDL e DML)
- Flutter (integração com a BD)
2. Pré-requisitos
Antes de iniciar, é necessário:
- Ter uma conta ativa no Supabase
- Criar um novo projeto no Supabase
- Ter acesso ao editor SQL do Supabase
3. Criação da Base de Dados
1. Aceder ao painel do Supabase.
2. Criar um novo projeto.
3. No menu lateral, aceder a 'SQL Editor'.
4. Executar o script SQL fornecido no ficheiro 'schema.sql'.
5. Executar o script de inserção de dados fictícios ('seed.sql').
4. Estrutura da Base de Dados
A base de dados é composta pelas seguintes entidades principais:
- Utilizador
- UserLogin
- AtividadeDiaria
- AtividadePreferida
- Dieta
- Objetivo
- Motivacao
- Tabelas de relação (N:N)
5. Autenticação
A autenticação é realizada através do Supabase Auth. As credenciais dos utilizadores são armazenadas no schema 'auth', enquanto os dados de perfil são guardados no schema 'public'.
6. Integração com a Aplicação
A aplicação Flutter comunica com a base de dados através da API do Supabase, utilizando queries SQL e políticas de Row Level Security (RLS).
7. Segurança
- Utilização de RLS para restringir acesso aos dados
- Passwords armazenadas de forma segura (Supabase Auth)
- Separação entre dados de autenticação e dados de perfil
8. Observações Finais
Este README permite a replicação integral da base de dados do projeto Higia, garantindo consistência entre ambientes de desenvolvimento e avaliação.
