import 'dart:async';
import 'package:flutterstore/api/common/ps_resource.dart';
import 'package:flutterstore/api/common/ps_status.dart';
import 'package:flutterstore/provider/common/ps_provider.dart';
import 'package:flutterstore/repository/user_repository.dart';
import 'package:flutterstore/viewobject/common/ps_value_holder.dart';
import 'package:flutterstore/viewobject/user_login.dart';

class UserLoginProvider extends PsProvider {
  UserLoginProvider(
      {required UserRepository repo,
      required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    isDispose = false;
    print('User Login Provider: $hashCode');

    userLoginStream = StreamController<PsResource<UserLogin>>.broadcast();
    subscriptionUserLogin = userLoginStream.stream
        .listen((PsResource<UserLogin> userLoginResource) {
      _userLogin = userLoginResource;

      if (userLoginResource.status != PsStatus.BLOCK_LOADING &&
          userLoginResource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  UserRepository? _repo;
  PsValueHolder? psValueHolder;

  PsResource<UserLogin> _userLogin =
      PsResource<UserLogin>(PsStatus.NOACTION, '', null);
  PsResource<UserLogin> get userLogin => _userLogin;

late  StreamController<PsResource<UserLogin>> userLoginStream;
 late StreamSubscription<PsResource<UserLogin>> subscriptionUserLogin;

  @override
  void dispose() {
    subscriptionUserLogin.cancel();
    isDispose = true;
    print('User Login Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> getUserLogin(String loginUserId) async {
    isLoading = true;

    _repo!.getUserLogin(loginUserId, userLoginStream, PsStatus.PROGRESS_LOADING);
  }
}
