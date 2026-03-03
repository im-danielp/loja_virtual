import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/sign_up_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
        actions: [
          TextButton(
            child: Text(
              'Criar conta',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignUpScreen()),
              );
            },
          ),
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading) return CircularProgressIndicator();
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(hint: Text('Email')),
                  validator: (text) {
                    if (text!.isEmpty || !text.contains('@')) return 'E-mail inválido';
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: passController,
                  obscureText: true,
                  decoration: InputDecoration(hint: Text('Senha')),
                  validator: (text) {
                    if (text == '' || text!.length < 6) return 'Senha inválida';
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      if (emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Insira seu e-mail para recuperação'),
                            backgroundColor: Colors.redAccent,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        model.recoverPass(emailController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Confira seu e-mail'),
                            backgroundColor: Theme.of(context).primaryColor,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: Text('Esqueci minha senha'),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 45,
                  child: FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {}
                      model.signIn(
                        email: emailController.text,
                        pass: passController.text,
                        onSucess: onSucess,
                        onFail: onFail,
                      );
                    },
                    child: Text(
                      'Entrar',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void onSucess() {
    Navigator.pop(context);
  }

  void onFail() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Falha ao entrar!'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
