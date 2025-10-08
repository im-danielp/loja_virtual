import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar conta'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: InputDecoration(hint: Text('Nome completo')),
              validator: (text) {
                if (text!.isEmpty) return 'Nome inválido';
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(hint: Text('Endereço')),
              validator: (text) {
                if (text!.isEmpty) return 'Endereço inválido';
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(hint: Text('Email')),
              validator: (text) {
                if (text!.isEmpty || !text.contains('@')) return 'E-mail inválido';
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
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
                  if (_formKey.currentState!.validate()) {}
                },
                child: Text(
                  'Criar conta',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
