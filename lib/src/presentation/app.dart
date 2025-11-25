import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/di/injection.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/event/event_bloc.dart';
import 'bloc/profile/profile_cubit.dart';
import 'router/app_router.dart';
import 'pages/login_page.dart';
import 'package:here_bro/constants/app_colors.dart';

class EventEaseApp extends StatelessWidget {
  const EventEaseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>()..add(const AppStarted()),
        ),
        BlocProvider<EventBloc>(
          create: (context) => getIt<EventBloc>(),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => getIt<ProfileCubit>(),
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final authBloc = context.read<AuthBloc>();
          final appRouter = AppRouter(authBloc: authBloc);

          return MaterialApp(
            title: 'EventEase',
            theme: ThemeData(
              primaryColor: AppColors.emerald600,
              scaffoldBackgroundColor: AppColors.gray50,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.black),
                titleTextStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            onGenerateRoute: appRouter.onGenerateRoute,
            home: const LoginPage(),
          );
        },
      ),
    );
  }
}
