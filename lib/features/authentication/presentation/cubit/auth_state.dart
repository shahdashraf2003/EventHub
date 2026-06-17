class AuthState {
  final bool isPasswordVisible;
  final bool isLoading;
  final String? error;
  final bool isSuccess;
  final List<Map<String, String>> savedAccounts;
  final bool rememberMe;

  const AuthState({
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
    this.savedAccounts = const [],
    this.rememberMe = true,
  });

  AuthState copyWith({
    bool? isPasswordVisible,
    bool? isLoading,
    String? error,
    bool? isSuccess,
    List<Map<String, String>>? savedAccounts,
    bool? rememberMe,
  }) {
    return AuthState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
      savedAccounts: savedAccounts ?? this.savedAccounts,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}