import 'package:event_hub/features/authentication/presentation/cubit/auth_state.dart';
import 'package:event_hub/model/entities/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_hub/core/database/database_helper.dart';
import 'package:event_hub/core/services/secure_storage_service.dart';
import 'package:event_hub/core/services/shared_prefs_service.dart';



class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState()) {
    _loadSavedAccounts();
  }

  Future<void> _loadSavedAccounts() async {
    final accounts = await SecureStorageService.getSavedAccounts();
    emit(state.copyWith(savedAccounts: accounts));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void toggleRememberMe(bool value) {
    emit(state.copyWith(rememberMe: value));
  }

  Future<void> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(state.copyWith(error: 'Please enter email and password'));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    try {
      final user = await DatabaseHelper.instance.getUserByEmailAndPassword(email, password);
      if (user != null) {
        await SharedPrefsService.setLoggedIn(true);
        await SharedPrefsService.setCurrentUserEmail(user.email);
        await SharedPrefsService.setCurrentUserName(user.name);
        if (user.id != null) {
          await SharedPrefsService.setCurrentUserId(user.id!);
        }
        
        if (state.rememberMe) {
          await SecureStorageService.saveAccount(user.name, user.email, password);
        }

        emit(state.copyWith(isLoading: false, isSuccess: true));
      } else {
        emit(state.copyWith(isLoading: false, error: 'Invalid email or password'));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Error: $e'));
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      emit(state.copyWith(error: 'Please fill all fields'));
      return;
    }
    
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final existingUser = await DatabaseHelper.instance.getUserByEmailAndPassword(email, password);
      if (existingUser != null) {
        emit(state.copyWith(isLoading: false, error: 'Email already exists'));
        return;
      }

      final userId = await DatabaseHelper.instance.createUser(UserModel(name: name, email: email, password: password));

      await SharedPrefsService.setLoggedIn(true);
      await SharedPrefsService.setCurrentUserEmail(email);
      await SharedPrefsService.setCurrentUserName(name);
      await SharedPrefsService.setCurrentUserId(userId);
      
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Error: $e'));
    }
  }
}
