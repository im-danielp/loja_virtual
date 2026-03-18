import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Criar conta'),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (contexr, child, model) {
          if (model.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(hint: Text('Nome completo')),
                  validator: (text) {
                    if (text!.isEmpty) return 'Nome inválido';
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: addressController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(hint: Text('Endereço')),
                  validator: (text) {
                    if (text!.isEmpty) return 'Endereço inválido';
                    return null;
                  },
                ),
                SizedBox(height: 16),
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
                SizedBox(height: 32),
                SizedBox(
                  height: 45,
                  child: FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Map<String, dynamic> userData = {
                          'name': nameController.text.trim(),
                          'email': emailController.text.trim(),
                          'address': addressController.text.trim(),
                        };

                        model.signUp(
                          userData: userData,
                          pass: passController.text.trim(),
                          onOnSucess: () => onSucess(context),
                          onFail: () => onFail(context),
                        );
                      }
                    },
                    child: Text(
                      'Criar conta',
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

  void onSucess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Usuário criado com sucesso!'),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(Duration(seconds: 2)).then((_) {
      if (context.mounted) Navigator.pop(context);
    });
  }

  void onFail(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Falha ao criar usuário'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
