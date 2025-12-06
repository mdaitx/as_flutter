# 🎴 AS Flutter

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.10.1-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.10.1-0175C2?logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Authentication-FFCA28?logo=firebase&logoColor=black)
![License](https://img.shields.io/badge/License-MIT-green.svg)

**Aplicativo mobile para visualização de cards de personagens**

Projeto desenvolvido na cadeira de Desenvolvimento de Sistemas Móveis para a AS

</div>

---

## 📋 Sobre

Aplicativo Flutter que permite visualizar e explorar cards de personagens com autenticação Firebase, busca em tempo real e interface moderna com suporte a tema claro/escuro.

## ✨ Funcionalidades

- 🔐 Autenticação com Firebase (login, registro, recuperação de senha)
- 🎴 Visualização e busca de cards de personagens
- 🎨 Material Design 3 com tema claro/escuro
- 🌐 Integração com API REST (Magic: The Gathering API)
- 🔄 Retry automático em falhas de rede

## 🛠 Tecnologias

- **Flutter** 3.10.1
- **Dart** 3.10.1
- **Firebase** (Core, Authentication)
- **HTTP** para requisições à API

## 📦 Instalação

### Pré-requisitos

- Flutter SDK 3.10.1+
- Android Studio ou VS Code
- Projeto Firebase configurado

### Passos

```bash
# Clone o repositório
git clone https://github.com/mdaitx/as_flutter.git
cd as_flutter

# Instale as dependências
flutter pub get

# Configure o Firebase
# 1. Crie um projeto no Firebase Console
# 2. Adicione os arquivos de configuração:
#    - google-services.json → android/app/
#    - GoogleService-Info.plist → ios/Runner/
# 3. Execute: flutterfire configure

# Execute o app
flutter run
```

## 🚀 Uso

1. **Login/Registro**: Faça login ou crie uma conta
2. **Explorar Cards**: Visualize todos os personagens disponíveis
3. **Buscar**: Use a barra de pesquisa para filtrar por nome
4. **Detalhes**: Toque em um card para ver mais informações

## 📁 Estrutura

```
lib/
├── main.dart              # Ponto de entrada
├── models/               # Modelos de dados
│   └── character.dart
├── screens/              # Telas
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart
│   └── card_detail_screen.dart
├── services/             # Lógica de negócio
│   ├── firebase_service.dart
│   └── character_service.dart
└── widgets/              # Componentes reutilizáveis
    ├── app_search_bar.dart
    ├── app_top_bar.dart
    └── character_card.dart
```

## 🔧 Configuração

A URL da API está configurada em `lib/constantes.dart`:

```dart
const String BASE_URL = "https://api.magicthegathering.io/v1";
```

**Firebase**: Habilite Email/Password Authentication no Firebase Console.

## 🧪 Testes

```bash
flutter test
```

## 📱 Plataformas

- ✅ Android
- ⚠️ iOS (requer configuração adicional)

## 📄 Licença

Este projeto está sob a licença MIT. Veja [LICENSE](LICENSE) para mais detalhes.

## 👨‍💻 Autor

**Mathias Daitx** - [@mdaitx](https://github.com/mdaitx)

---

<div align="center">

**Desenvolvido com ❤️ usando Flutter**

⭐ Se este projeto foi útil, considere dar uma estrela!

</div>
