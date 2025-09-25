import 'package:bloc/bloc.dart';
import 'package:e_learning/bloc/auth/auth_event.dart';
import 'package:e_learning/bloc/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  AuthBloc() : super(const AuthState()) {
    on<AuthStateChanged>((_onAuthStateChanged));
    on<RegisterRequested>((_onRegisterRequested));
    on<LoginRequested>((_onLoginRequested));
    on<LogoutRequested>((_onLogoutRequested));
    on<UpdateProfileRequested>((_onUpdateProfileRequested));
    on<ForgotPasswordRequested>((_onForgotPasswordRequested));
  }
  Future<void> _onAuthStateChanged(
      AuthStateChanged event,
      Emitter<AuthState> emit,
      )async{
  // Xử lý sự kiện thay đổi trạng thái xác thực
    emit(const AuthState());
  }

  Future<void> _onRegisterRequested(
      RegisterRequested event,
      Emitter<AuthState> emit,
      )async{
    try {
      emit(state.copyWith(isLoading: true));
      // Thực hiện đăng ký người dùng ở đây
      emit(state.copyWith(isLoading: false));
    }catch(e){
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onLoginRequested(
      LoginRequested event,
      Emitter<AuthState> emit,
      )async{
    try {
      emit(state.copyWith(isLoading: true));
      // Thực hiện đăng nhập người dùng ở đây
      emit(state.copyWith(isLoading: false));
    }catch(e){
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event,
      Emitter<AuthState> emit,
      )async{
    try {
      // Thực hiện đăng xuất người dùng ở đây
      emit(const AuthState());
    }catch(e){
      emit(state.copyWith(error: e.toString()));
    }
  }
  Future<void> _onUpdateProfileRequested(
      UpdateProfileRequested event,
      Emitter<AuthState> emit,
      )async{
        try{
          emit(state.copyWith(isLoading: true));
          // Thực hiện cập nhật thông tin người dùng ở đây
          emit(state.copyWith(isLoading: false));
        }catch(e){
          emit(state.copyWith(error: e.toString(), isLoading: false));
        }
  }
  Future<void> _onForgotPasswordRequested(
      ForgotPasswordRequested event,
      Emitter<AuthState> emit,
      )async{
        try{
          emit(state.copyWith(isLoading: true));
          // Thực hiện quên mật khẩu ở đây
          emit(state.copyWith(isLoading: false));
        }catch(e){
          emit(state.copyWith(error: e.toString(), isLoading: false));
        }
  }
}