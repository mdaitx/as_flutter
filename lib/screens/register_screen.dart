import 'package:flutter/material.dart';
import 'package:as_projeto/services/firebase_service.dart';
import 'package:as_projeto/utils/results.dart';
import 'package:as_projeto/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var exibeSenha = false;
  var nomeController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var firebaseService = FirebaseService();
  var errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registre-se',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<Results>(
          stream: firebaseService.resultsRegister,
          builder: (BuildContext context, AsyncSnapshot<Results> snapshot) {
            if (snapshot.data is LoadingResult) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.data is ErrorResult) {
              var erros = snapshot.data as ErrorResult;

              switch (erros.code) {
                case "email-already-in-use":
                  errorMessage = "Este e-mail já está em uso";
                  break;
                case "invalid-email":
                  errorMessage = "E-mail inválido";
                  break;
                case "weak-password":
                  errorMessage =
                      "Senha muito fraca. Use pelo menos 6 caracteres";
                  break;
                case "operation-not-allowed":
                  errorMessage = "Operação não permitida";
                  break;
                case "network-timeout":
                  errorMessage = "Tempo de conexão excedido. Verifique sua internet WiFi";
                  break;
                case "network-recaptcha-error":
                case "network-request-failed":
                  errorMessage = "Erro ao conectar com reCAPTCHA. Verifique se o WiFi não está bloqueando conexões com Google. Tente usar dados móveis ou outro WiFi";
                  break;
                case "network-error":
                  errorMessage = "Erro de conexão. Verifique sua internet";
                  break;
                default:
                  if (erros.code.contains("network") || 
                    erros.code.contains("timeout") || 
                    erros.code.contains("recaptcha") ||
                    erros.code.contains("unreachable") ||
                    erros.code.contains("interrupted")) {
                    errorMessage = "Erro de conexão. Verifique sua internet WiFi";
                  } else {
                    errorMessage = "Erro ao criar conta";
                  }
                  break;
              }
              // Exibe SnackBar com erro
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorMessage),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
              });
            }

            if (snapshot.data is SuccessResult) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                // Faz logout após criar a conta
                await firebaseService.signOut();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Conta criada com sucesso! Faça login para continuar.',
                    ),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 3),
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              });
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: exibeSenha,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            exibeSenha = !exibeSenha;
                          });
                        },
                        icon: exibeSenha
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                      ),
                    ),
                  ),
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Text(
                        errorMessage,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        final nome = nomeController.text.trim();
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();

                        String? validationError;

                        // Validação usando switch case
                        switch (true) {
                          case _ when nome.isEmpty:
                            validationError =
                                "Por favor, preencha o campo de nome";
                            break;
                          case _ when email.isEmpty:
                            validationError =
                                "Por favor, preencha o campo de e-mail";
                            break;
                          case _ when password.isEmpty:
                            validationError =
                                "Por favor, preencha o campo de senha";
                            break;
                          default:
                            validationError = null;
                        }

                        setState(() {
                          errorMessage = validationError ?? "";
                        });

                        if (validationError == null) {
                          firebaseService.register(email, password);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        minimumSize: const Size(double.infinity, 0),
                      ),
                      child: const Text(
                        "Registrar-se",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
