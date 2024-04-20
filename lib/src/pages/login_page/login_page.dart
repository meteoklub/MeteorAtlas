import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteoapp/domain/services/route_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../blocs/auth_bloc/auth_bloc.dart';
import '../../../blocs/auth_bloc/auth_event.dart';
import '../../../blocs/auth_bloc/auth_state.dart';
import 'error_handler.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, this.isRegister = true}) : super(key: key);
  static const routeName = '/login';

  final bool isRegister;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  final scaffoldKey = GlobalKey<ScaffoldState>(); // Vytvoření scaffoldKey

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticatedState) {
          ErrorHandler.showSuccesToast(context, "Authentication Successful");
          Navigator.pushReplacementNamed(context, Routes.home);
        }
        if (state is AuthErrorState) {
          ErrorHandler.showErrorToast(
              scaffoldKey.currentState!.context, state.error);
        }
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            iconTheme: theme.iconTheme,
            backgroundColor: theme.primaryColor,
            title: Text(
                widget.isRegister
                    ? AppLocalizations.of(context).register
                    : AppLocalizations.of(context).login,
                style: theme.textTheme.titleLarge!),
          ),
          body: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Stack(
                children: [
                  Form(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Text(
                              widget.isRegister
                                  ? AppLocalizations.of(context).register_text
                                  : AppLocalizations.of(context).login_text,
                              style: theme.textTheme.labelSmall!
                                  .copyWith(fontSize: 28),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          InputField(
                            label: AppLocalizations.of(context).email,
                            hintText: 'Enter your email',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            theme: theme,
                            icon: Icons.email_outlined,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InputField(
                            label: AppLocalizations.of(context).password,
                            hintText: 'Enter your password',
                            controller: _passwordController,
                            keyboardType: TextInputType.text,
                            obscureText: !_passwordVisible,
                            theme: theme,
                            icon: _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          if (widget
                              .isRegister) // Zobrazit pouze pro registraci
                            const SizedBox(
                              height: 10,
                            ),
                          if (widget.isRegister)
                            InputField(
                              label: AppLocalizations.of(context).confirm_pass,
                              hintText:
                                  AppLocalizations.of(context).confirm_pass,
                              controller: _confirmPasswordController,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              theme: theme,
                              icon: Icons.lock,
                            ),
                          if (widget
                              .isRegister) // Zobrazit pouze pro registraci
                            const SizedBox(
                              height: 60,
                            ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          side: const BorderSide(
                            color: Colors.red,
                          )),
                      onPressed: () {
                        _authenticate(context);
                      },
                      child: Text(
                        widget.isRegister ? "Register" : "Sign In",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _authenticate(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      if (widget.isRegister) {
        context.read<AuthBloc>().add(SignUpEvent(
              email: email,
              password: password,
              checkPassword:
                  _confirmPasswordController.text == _passwordController.text,
            ));
      } else {
        // Přihlášení
        context.read<AuthBloc>().add(SignInEvent(
              email: email,
              password: password,
            ));
      }
    }
  }
}

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.keyboardType,
    required this.theme,
    this.icon,
    this.suffixIcon,
    this.obscureText = false,
    this.onPressed,
    this.onChanged,
  }) : super(key: key);

  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final ThemeData theme;
  final IconData? icon;
  final IconData? suffixIcon;
  final bool obscureText;
  final VoidCallback? onPressed;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          onChanged: onChanged,
          keyboardType: keyboardType,
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: theme.iconTheme.color!),
              borderRadius: BorderRadius.circular(45.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.iconTheme.color!),
              borderRadius: BorderRadius.circular(45.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.iconTheme.color!),
              borderRadius: BorderRadius.circular(45.0),
            ),
            labelText: label,
            hintText: hintText,
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Colors.red), // Customize error border color
              borderRadius: BorderRadius.circular(45.0),
            ),
            errorStyle: const TextStyle(
                color: Colors.red), // Customize error text color
            labelStyle: theme.textTheme.bodySmall!.copyWith(
              color: theme.iconTheme.color,
            ),
            prefixIcon: icon != null
                ? IconButton(
                    icon: Icon(
                      icon,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: onPressed,
                  )
                : null,
            suffixIcon: suffixIcon != null
                ? IconButton(
                    icon: Icon(
                      suffixIcon,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: onPressed,
                  )
                : null,
          ),
        ),
        // Zobrazování sugestí
      ],
    );
  }
}
