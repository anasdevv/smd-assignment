import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smd_project/features/authentication/data/data_sources/auth_remote_data_source_impl.dart';
import 'package:smd_project/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:smd_project/features/authentication/data/repositories/user_repository_impl.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:smd_project/features/groups/data/repositories/group_repository_impl.dart';
import 'package:smd_project/features/groups/presentation/bloc/groups_bloc.dart';
import 'core/router/app_router.dart';
import 'firebase_options.dart';
import 'package:smd_project/features/groups/domain/usecases/join_group.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSourceImpl(),
    userRepository: UserRepositoryImpl(),
  );
  final groupRepository =
      GroupRepositoryImpl(firestore: FirebaseFirestore.instance);

  final joinGroupUseCase = JoinGroup(groupRepository);

  // await SeedData.seedData();

  // Initialize storage based on platform
  final storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? await HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

  // Initialize HydratedBloc
  HydratedBloc.storage = storage;
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: authRepository),
        ),
        BlocProvider<GroupBloc>(
          create: (context) => GroupBloc(
            groupRepository: groupRepository,
            joinGroupUseCase: joinGroupUseCase,
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Study Group Organizer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.all(Colors.blue),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          labelStyle: TextStyle(color: Colors.grey),
          floatingLabelStyle: TextStyle(color: Colors.blue),
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
