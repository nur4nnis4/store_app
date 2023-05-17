import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:store_app/bloc/product_bloc/fetch_products_bloc/fetch_products_bloc.dart';
import 'package:store_app/bloc/product_bloc/fetch_products_by_category/fetch_products_by_category_bloc.dart';
import 'package:store_app/bloc/product_bloc/search_product_bloc/search_product_bloc.dart';
import 'package:store_app/bloc/product_bloc/upload_product_bloc/upload_product_bloc.dart';
import 'package:store_app/bloc/user_bloc/user_bloc.dart';
import 'package:store_app/core/network/network_info.dart';
import 'package:store_app/data/local_datasource/auth_local_datasource.dart';
import 'package:store_app/data/local_datasource/user_local_datasource.dart';
import 'package:store_app/data/remote_datasource/auth_remote_datasource.dart';
import 'package:store_app/data/remote_datasource/product_remote_datasource.dart';
import 'package:store_app/data/remote_datasource/user_remote_datasource.dart';
import 'package:store_app/utils/user_form_validator.dart';

final sLocator = GetIt.instance;

void init() {
  // Core
  sLocator.registerLazySingleton(() => NetworkInfo(connectivity: sLocator()));

  // Blocs
  sLocator.registerFactory(() => AuthBloc(
      authRemoteDatasource: sLocator(),
      authLocalDatasource: sLocator(),
      userLocalDatasource: sLocator(),
      userFormValidator: sLocator()));

  sLocator.registerFactory(() => UserBloc(
        userRemoteDatasource: sLocator(),
        userLocalDatasource: sLocator(),
        networkInfo: sLocator(),
      ));
  sLocator.registerFactory(() => FetchProductsBloc(
        productRemoteDatasource: sLocator(),
      ));
  sLocator.registerFactory(() => UploadProductBloc(
        productRemoteDatasource: sLocator(),
      ));
  sLocator.registerFactory(() => SearchProductBloc(
        productRemoteDatasource: sLocator(),
      ));
  sLocator.registerFactory(() => FetchProductsByCategoryBloc(
        productRemoteDatasource: sLocator(),
      ));

  //Utils

  sLocator.registerLazySingleton(() => UserFormValidator());

  // Datasources
  sLocator.registerLazySingleton(
      () => AuthRemoteDatasource(dio: sLocator(), googleSignIn: sLocator()));
  sLocator
      .registerLazySingleton(() => AuthLocalDatasource(storage: sLocator()));

  sLocator
      .registerLazySingleton(() => ProductRemoteDatasource(dio: sLocator()));
  sLocator.registerLazySingleton(() => UserRemoteDatasource(dio: sLocator()));
  sLocator.registerLazySingleton(() => UserLocalDatasource.instance);

  // Dependecies

  sLocator.registerLazySingleton(() => Connectivity());
  sLocator.registerLazySingleton(() => SharedPreferences.getInstance());

  sLocator.registerLazySingleton(
      () => Dio(BaseOptions(headers: {'Accept': 'application/json'})));

  sLocator.registerLazySingleton(() => GoogleSignIn());

  sLocator.registerLazySingleton(
    () => FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    ),
  );
}
