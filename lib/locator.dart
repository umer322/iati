
import 'package:get_it/get_it.dart';
import 'package:iati/core/services/api.dart';
import 'package:iati/core/services/authservices.dart';
import 'package:iati/core/services/dynamiclinks_service.dart';
import 'package:iati/core/services/firestorage_service.dart';
import 'package:iati/core/services/firestore_service.dart';
import 'package:iati/core/services/multimediaservice.dart';
import 'package:iati/core/services/realtimedatabase_service.dart';
import 'package:iati/ui/views/homeview/timeline/timelineposts_viewmodel.dart';
import 'package:iati/ui/views/postcreation/postcreation_viewmodel.dart';
import 'package:iati/ui/views/signup/signup_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

import 'ui/views/homeview/userprofile/currentuserprofile_viewmodel.dart';

GetIt locator=GetIt.instance;

setUpLocator(){
  locator.registerLazySingleton(() => DynamicLinksService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => Api());
  locator.registerLazySingleton(() => SignUpViewModel());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => MultiMediaService());
  locator.registerLazySingleton(() => FireStorageService());
  locator.registerLazySingleton(()=>PostCreationViewModel());
  locator.registerLazySingleton(()=>CurrentUserProfileViewModel());
  locator.registerLazySingleton(() => TimeLinePostsViewModel());
  locator.registerLazySingleton(() => RealTimeDataBase());
}