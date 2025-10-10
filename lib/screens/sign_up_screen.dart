import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          onOnSucess: onSucess,
                          onFail: onFail,
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

  void onSucess() {}

  void onFail() {}
}
