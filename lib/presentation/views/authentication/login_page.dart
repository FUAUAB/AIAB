import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:work_order_app/core/helpers/theme_controller.dart';
import 'package:work_order_app/cubit/authentication/authentication_cubit.dart';
import 'package:work_order_app/presentation/widgets/dialogs/dialogs_style.dart';

import '../../../app_localizations.dart';
import '../../../core/constants/constants.dart';
import '../../styles/colors_style.dart';
import '../../widgets/generics/build_state.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthenticationCubit _authenticationCubit = new AuthenticationCubit();

  final usernameController = new TextEditingController();
  final passwordController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // usernameController.text = 'api_rest';
    // passwordController.text = 'sr9bKB5nsU43fUGnKXhC';
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.translate('login.title'),
            style: TextStyle(
              color: CustomColors.textWhite,
              fontSize: TITLE_FONT_SIZE,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  BlocConsumer(
                    bloc: _authenticationCubit,
                    listener: (context, state) {
                      if (state is AuthenticationUserNotFound) {
                        _showLoginFailedSnackbar();
                      }
                      if (state is AuthenticationUserFound) {
                        Navigator.of(context).popAndPushNamed(homeRoute);
                      }
                    },
                    builder: (context, state) {
                      if (state is AuthenticationLoading) {
                        return buildLoading(context);
                      }
                      if (state is! AuthenticationLoading) {
                        return Column(
                          children: [
                            headerSection(),
                            textSection(),
                            optionsSection(context),
                            buttonSection(),
                            SizedBox(height: 60),
                          ],
                        );
                      }
                      return Text("");
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container headerSection() {
    var domainCurrentTheme = ThemeController.of(context).currentTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Image(image: AssetImage('assets/${domainCurrentTheme}_logo.png')),
    );
  }

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vul een gebruikersnaam in';
                    }
                    return null;
                  },
                  controller: usernameController,
                  style: TextStyle(color: CustomColors.textBlack),
                  autofocus: false,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8.0),
                    hintText: AppLocalizations.of(context)!
                        .translate('login.username'),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.textBlack,
                      ),
                    ),
                    hintStyle: TextStyle(
                      color: CustomColors.textBlack,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vul een wachtwoord in';
                    }
                    return null;
                  },
                  controller: passwordController,
                  obscureText: true,
                  autofocus: false,
                  style: TextStyle(color: CustomColors.textBlack),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8.0),
                    hintText: AppLocalizations.of(context)!
                        .translate('login.password'),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.textBlack,
                      ),
                    ),
                    hintStyle: TextStyle(color: CustomColors.textBlack),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container optionsSection(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //!'Remember me' checkbox, still has to be implemented!
          // Container(
          //   width: 150,
          //   child: Row(
          //     children: [
          //       Checkbox(
          //         value: _isChecked,
          //         onChanged: (value) {
          //           setState(() {
          //             _isChecked = !_isChecked;
          //           });
          //         },
          //       ),
          //       Text(
          //         AppLocalizations.of(context)!.translate('login.remember'),
          //         style: TextStyle(
          //             color: CustomColors.textBlack, fontSize: TEXT_FONT_SIZE),
          //         textAlign: TextAlign.justify,
          //       )
          //     ],
          //   ),
          // ),
          Container(
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  primary: CustomColors.textBlack,
                  textStyle: const TextStyle(fontSize: 12),
                ),
                onPressed: () {
                  forgotPasswordDialog(context, "Wachtwoord vergeten?");
                },
                child: Text(
                  AppLocalizations.of(context)!.translate('login.forgot'),
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buttonSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).colorScheme.primary,
          textStyle: const TextStyle(fontSize: 12),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _authenticationCubit.login(
              username: usernameController.text,
              password: passwordController.text,
            );
          }
        },
        child: Text(
          AppLocalizations.of(context)!.translate('login.title'),
          style: TextStyle(
            color: CustomColors.textWhite,
            fontSize: TITLE_FONT_SIZE,
          ),
        ),
      ),
    );
  }

  //TODO: Make a better footersection for loginpage
  Container footerSection() {
    return Container(
      child: Text('piet'),
    );
  }

  void _showLoginFailedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.translate('login.no.user'),
          style: TextStyle(
            color: Colors.white,
            fontSize: TEXT_FONT_SIZE,
          ),
        ),
        duration: Duration(milliseconds: 800),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }
}
