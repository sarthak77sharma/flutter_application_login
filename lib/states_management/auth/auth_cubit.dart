import 'package:auth/auth.dart';
import 'package:bloc/bloc.dart';
import 'package:async/async.dart';
import 'package:flutter_application_login/cache/local_store_contract.dart';
import 'package:flutter_application_login/models/User.dart';
import 'package:flutter_application_login/states_management/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  ILocalStore localStore;

  AuthCubit(this.localStore) : super(InitialState());

  signin(IAuthService authService) async {
    _startLoading();
    final result = await authService.signIn();
    _setResultOfAuthState(result);
  }

  signout(IAuthService authService) async {
    _startLoading();
    final token = await localStore.fetch();
    final result = await authService.signOut(token);
    if (result.asValue.value) {
      localStore.delete(token);
      emit(SignOutSuccessState());
    } else {
      emit(ErrorState('Error signin out'));
    }
  }

  signup(ISignUpService signUpService, User user) async {
    _startLoading();
    final result =
        await signUpService.signUp(user.name, user.email, user.password);
    _setResultOfAuthState(result);
  }

  void _setResultOfAuthState(Result<Token> result) {
    if (result.asError != null) {
      emit(ErrorState(result.asError.error));
      return;
    }
    emit(AuthSuccessState(result.asValue.value));
  }

  void _startLoading() {
    emit(LoadingState());
  }
}
