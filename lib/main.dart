import 'package:building_site_tracker/cubit/get_names_data_cubit.dart';
import 'package:building_site_tracker/firebase_options.dart';
import 'package:building_site_tracker/screens/homescreen.dart';
import 'package:building_site_tracker/screens/login_screen/view/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) {
        return MaterialApp(
          home: Home(),
        );
      },
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<GetNamesDataCubit>(
          create: (BuildContext context) => GetNamesDataCubit()..getNames()),

      //GetEasySelectDataCubit
    ], child: LoginScreen());
  }
}
