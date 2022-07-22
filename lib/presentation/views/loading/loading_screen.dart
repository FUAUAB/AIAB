import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_order_app/cubit/authentication/authentication_cubit.dart';

import '../../../core/constants/constants.dart';
import '../../styles/colors_style.dart';
import '../../widgets/generics/build_state.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    BlocProvider.of<AuthenticationCubit>(context).checkLoginStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: CustomColors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocListener<AuthenticationCubit, AuthenticationState>(
              listener: (context, state) {
                if (state is AuthenticationFirstTime) {
                  Navigator.of(context).popAndPushNamed(firstTimeRoute);
                }
                if (state is AuthenticationUserFound) {
                  Navigator.of(context).popAndPushNamed(homeRoute);
                }
                if (state is AuthenticationUserNotFound) {
                  Navigator.of(context).popAndPushNamed(loginRoute);
                }
              },
              child: SizedBox(),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              child: Image(
                image: AssetImage('assets/didata_logo.png'),
              ),
            ),
            buildLoading(context),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
