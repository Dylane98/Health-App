README – Higia App (Setup e Configuração) PDM

Este documento descreve os passos necessários para configurar o ambiente de desenvolvimento, compilar a aplicação Higia e garantir o acesso correto aos serviços externos utilizados. 

1. Requisitos de Software 

- Flutter SDK (versão estável recomendada) 
- Dart SDK (incluído com o Flutter) 
- Android Studio ou VS Code (com extensões Flutter e Dart) 
- Emulador Android / iOS ou dispositivo físico 
- Git 

2. Configuração do Flutter 

Após instalar o Flutter SDK, confirma a instalação executando no terminal: 
 
flutter doctor 
 
Todos os requisitos devem surgir assinalados a verde. 

3. Obtenção do Projeto 

Clona o repositório do projeto: 
 
git clone https://github.com/Dylane98/Health-App.git 
cd Health-App-main/higia 
 
Instala as dependências: 
 
flutter pub get 

4. Configuração do Supabase 

A aplicação utiliza o Supabase como Backend-as-a-Service para autenticação e persistência de dados. 
 
É necessário criar um projeto no Supabase (https://supabase.com) e obter: 
- Project URL 
- Public Anon Key 

5. Variáveis de Ambiente 

As credenciais do Supabase devem ser configuradas no código (ou ficheiro seguro): 
 
SUPABASE_URL = "https://<project-id>.supabase.co" 
SUPABASE_ANON_KEY = "<public-anon-key>" 
 
Estas variáveis são utilizadas no ficheiro: 
lib/services/supabase_service.dart 

6. Execução da Aplicação 

Com um emulador ativo ou dispositivo ligado, executa: 
 
flutter run 
 
A aplicação será compilada e iniciada no dispositivo selecionado. 

7. Observações Académicas 

A arquitetura da aplicação segue princípios de Programação Orientada por Objetos, nomeadamente modularidade, encapsulamento e separação de responsabilidades, através da divisão entre interface, lógica de negócio e serviços externos. 

Este README é válido para efeitos de avaliação nas unidades curriculares de Programação de Dispositivos Móveis (PDM) 



