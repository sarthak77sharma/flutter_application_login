import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_login/UI/pages/auth/auth_page.dart';
import 'package:flutter_application_login/cache/local_store.dart';
import 'package:flutter_application_login/states_management/auth/auth_cubit.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cache/local_store_contract.dart';

class CompositionRoot {
  static SharedPreferences _sharedPrefrences;
  static ILocalStore _localStore;
  static String _baseUrl;
  static Client _client;

  static configure() {
    _localStore = LocalStore(_sharedPrefrences);
    _client = Client();
    _baseUrl = "http://192.168.29.110:3000";
  }

  static Widget composeAuthUi() {
    IAuthApi _api = AuthApi(_baseUrl, _client);
    AuthManager _manager = AuthManager(_api);
    AuthCubit _authCubit = AuthCubit(_localStore);
    ISignUpService _signupService = SignUpService(_api);

    return BlocProvider(
      create: (BuildContext context) => _authCubit,
      child: AuthPage(_manager, _signupService),
    );
  }
}
