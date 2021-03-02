import 'package:auth/auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_login/UI/pages/auth/homescreen.dart';
import 'package:flutter_application_login/UI/widgets/custom_flat_button.dart';
import 'package:flutter_application_login/UI/widgets/custom_outline_button.dart';
import 'package:flutter_application_login/UI/widgets/custom_text_field.dart';
import 'package:flutter_application_login/models/User.dart';
import 'package:flutter_application_login/states_management/auth/auth_cubit.dart';
import 'package:flutter_application_login/states_management/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthPage extends StatefulWidget {
  final AuthManager _manager;
  final ISignUpService _signUpService;

  AuthPage(this._manager, this._signUpService);
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  PageController _controller = PageController();
  String _username = '';
  String _email = '';
  String _password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: _buildLogo(),
              ),
              SizedBox(height: 50.0),
              BlocConsumer<AuthCubit, AuthState>(builder: (_, state) {
                return _buildUI();
              }, listener: (context, state) {
                if (state is LoadingState) {
                  _showLoader();
                }
                _hideLoader();
                if (state is ErrorState) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                      state.message,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: Colors.white, fontSize: 16.0),
                    )),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  _buildLogo() => Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            //SvgPicture.asset(
            //'assets/logo.svg',
            // fit: BoxFit.fill,
            // ),
            SizedBox(height: 10.0),
            RichText(
                text: TextSpan(
                    text: 'Login',
                    style: Theme.of(context).textTheme.caption.copyWith(
                          color: Colors.black,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                        ),
                    children: [
                  TextSpan(
                      text: 'App',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      )),
                ])),
          ],
        ),
      );

  _buildUI() => Container(
        height: 500.0,
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _controller,
          children: [_signIn(), _signUp()],
        ),
      );

  _signIn() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            ..._emailandPassword(),
            SizedBox(
              height: 20.0,
            ),
            CustomFlatButton(
              text: 'Sign In',
              size: Size(double.infinity, 54.0),
              onPressed: () {
                BlocProvider.of<AuthCubit>(context).signin(
                    widget._manager.email(email: _email, password: _password));
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Home()));
              },
            ),
            SizedBox(height: 30.0),
            CustomOutlineButton(
              text: 'Sign in with google',
              size: Size(double.infinity, 50.0),
              icon: SvgPicture.asset(
                'assets/google-icon.svg',
                height: 18.0,
                width: 18.0,
                fit: BoxFit.fill,
              ),
              onPressed: () {
                BlocProvider.of<AuthCubit>(context)
                    .signin(widget._manager.google);
              },
            ),
            SizedBox(height: 30),
            RichText(
              text: TextSpan(
                text: 'Don\'t have an account?',
                style: Theme.of(context).textTheme.caption.copyWith(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                    ),
                children: [
                  TextSpan(
                    text: 'Sign Up',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _controller.nextPage(
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.bounceInOut);
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  _signUp() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            CustomTextField(
              inputAction: TextInputAction.next,
              hint: 'Username',
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
              onChanged: (val) {
                _username = val;
              },
            ),
            SizedBox(height: 30.0),
            ..._emailandPassword(),
            SizedBox(height: 20.0),
            CustomFlatButton(
              text: 'Sign Up',
              size: Size(double.infinity, 54.0),
              onPressed: () {
                final user =
                    User(name: _username, email: _email, password: _password);
                BlocProvider.of<AuthCubit>(context)
                    .signup((widget._signUpService), user);
              },
            ),
            SizedBox(height: 30.0),
            SizedBox(height: 30),
            RichText(
              text: TextSpan(
                text: 'Already have an account?',
                style: Theme.of(context).textTheme.caption.copyWith(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                    ),
                children: [
                  TextSpan(
                    text: 'Sign In',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _controller.previousPage(
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.bounceInOut);
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  List<Widget> _emailandPassword() => [
        CustomTextField(
          keyboardType: TextInputType.emailAddress,
          inputAction: TextInputAction.next,
          hint: 'Email',
          fontSize: 18.0,
          fontWeight: FontWeight.normal,
          onChanged: (val) {
            _email = val;
          },
        ),
        SizedBox(height: 30.0),
        CustomTextField(
          obscure: true,
          inputAction: TextInputAction.done,
          hint: 'Password',
          fontSize: 18.0,
          fontWeight: FontWeight.normal,
          onChanged: (val) {
            _password = val;
          },
        ),
      ];

  _showLoader() {
    var alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white70,
        ),
      ),
    );

    showDialog(
        context: context, barrierDismissible: true, builder: (_) => alert);
  }

  _hideLoader() {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
