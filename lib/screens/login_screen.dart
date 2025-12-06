import 'package:as_projeto/screens/register_screen.dart';
import 'package:as_projeto/utils/results.dart';
import 'package:flutter/material.dart';
import 'package:as_projeto/services/firebase_service.dart';
import 'package:as_projeto/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var exibeSenha = false;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var firebaseService = FirebaseService();
  var errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 25
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<Results>(
          stream: firebaseService.resultsLogin,
          builder: (BuildContext context, AsyncSnapshot<Results> snapshot) {
            if (snapshot.data is LoadingResult) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.data is ErrorResult) {
              var erros = snapshot.data as ErrorResult;
              
              switch (erros.code) {
                case "invalid-credential":
                case "wrong-password":
                case "user-not-found":
                  errorMessage = "Credenciais inválidas";
                  break;
                case "invalid-email":
                  errorMessage = "E-mail inválido";
                  break;
                case "user-disabled":
                  errorMessage = "Conta desabilitada";
                  break;
                case "too-many-requests":
                  errorMessage = "Muitas tentativas. Tente mais tarde";
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
                    errorMessage = "Erro ao fazer login";
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
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Login realizado com sucesso!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              });
            }

            return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo centralizado - imagem local
                  Image.asset(
                    'assets/images/logo.png',
                    width: 250,
                    height: 250,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback para ícone caso a imagem não carregue
                      return Icon(
                        Icons.auto_awesome,
                        size: 120,
                        color: Colors.blue.shade700,
                      );
                    },
                  ),
                  const SizedBox(height: 32),
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
                        style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: ElevatedButton(
                      onPressed: ()  {
                        if (emailController.text.trim().isEmpty) {
                          setState(() {
                            errorMessage = "Por favor, preencha o campo de e-mail";
                          });
                          return;
                        }
                        if (passwordController.text.trim().isEmpty) {
                          setState(() {
                            errorMessage = "Por favor, preencha o campo de senha";
                          });
                          return;
                        }
                        setState(() {
                          errorMessage = "";
                        });
                        firebaseService.makeLoginFirebase(emailController.text.trim(), passwordController.text.trim());
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        minimumSize: const Size(double.infinity, 0),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      minimumSize: const Size(double.infinity, 0),
                    ),
                    child: const Text(
                      "Registre-se",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
