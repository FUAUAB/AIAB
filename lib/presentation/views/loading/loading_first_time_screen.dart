import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_order_app/core/helpers/theme_controller.dart';
import 'package:work_order_app/cubit/authentication/authentication_cubit.dart';
import 'package:work_order_app/presentation/widgets/generics/build_state.dart';

import '../../../core/constants/constants.dart';
import '../../styles/colors_style.dart';

class FirstTimePage extends StatefulWidget {
  FirstTimePage({Key? key}) : super(key: key);

  final TextEditingController _emailController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  _FirstTimePageState createState() => _FirstTimePageState();
}

class _FirstTimePageState extends State<FirstTimePage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          centerTitle: true,
          title: Text("Eerste gebruik"),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
            child: Row(
              children: <Widget>[
                BlocConsumer<AuthenticationCubit, AuthenticationState>(
                  listener: (context, state) {
                    if (state is AuthenticationNotLicensed) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 5),
                          content: Text(
                            "Er is geen licentie gevonden. Neem contact op met Didata.",
                          ),
                        ),
                      );
                    }
                    if (state is AuthenticationLicensed) {
                      var email = widget._emailController.text;

                      ThemeController.of(context).setTheme(email.substring(
                          email.indexOf('@') + 1, email.indexOf('.')));

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 5),
                          content: Text(
                            "Start de app opnieuw op om de installatie te voltooien.",
                          ),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthenticationLoading) {
                      return buildLoading(context);
                    } else {
                      return SizedBox();
                    }
                  },
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      if (widget._formKey.currentState!.validate()) {
                        context
                            .read<AuthenticationCubit>()
                            .saveEmail(widget._emailController.text);
                      }
                    },
                    child: Text(
                      "Opslaan",
                      style: TextStyle(
                        fontSize: TITLE_FONT_SIZE,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary:
                          Theme.of(context).buttonTheme.colorScheme!.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          color: CustomColors.oddRow,
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Voer hier uw werkmail in.",
                style: TextStyle(fontSize: TITLE_FONT_SIZE),
              ),
              SizedBox(
                height: 15,
              ),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: widget._formKey,
                child: TextFormField(
                  controller: widget._emailController,
                  validator: (value) => _validateEmail(value),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8.0),
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.textBlack,
                      ),
                    ),
                    hintStyle: TextStyle(
                      color: CustomColors.textBlack,
                    ),
                    fillColor: CustomColors.white,
                    filled: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? _validateEmail(String? value) {
  String pattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  RegExp regex = RegExp(pattern);
  if (value == null || value.isEmpty || !regex.hasMatch(value))
    return 'Voer een geldig emailadres in';
  else
    return null;
}
