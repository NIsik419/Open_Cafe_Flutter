import 'package:cafe_front/models/custom_user.dart';
import 'package:cafe_front/models/repository/user_repo.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum UserStatus {
  EXIST,
  LOGIN,
  ERROR,
}

class UserStore {
  static UserStore? _userStore;
  UserRepository repository = UserRepository();
  CustomUser? _user;
  UserStatus _status = UserStatus.ERROR;

  CustomUser? get user => _user;
  UserStatus get status => _status;
  UserStore._();
  // 싱글톤
  static UserStore getInstance(){
    return _userStore ??= UserStore._();
  }

  getUser() async {
    try{
      _user = await repository.getUser();
      _status = UserStatus.EXIST;
    } on DioException catch(e){
      if(e.response?.statusCode == 404){
        _status = UserStatus.LOGIN;
      } else {
        Fluttertoast.showToast(msg: '정보를 가져오는데 실패하였습니다.');
        _status = UserStatus.ERROR;
      }
    } catch(e){
      Fluttertoast.showToast(msg: '정보를 가져오는데 실패하였습니다.');
      _status = UserStatus.ERROR;
    }
  }

  createUser(CustomUser user) async {
    await repository.createUser(user);
  }

}