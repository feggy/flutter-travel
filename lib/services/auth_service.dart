import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_wisata/models/user_model.dart';
import 'package:travel_wisata/services/user_service.dart';

class AuthService {
  //NOTE menghandle ke Firebase Authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel> signUp({
    required String email,
    required String name,
    required String password,
    required String role,
    required String birth,
    required String gender,
    required String phone,
    required String address,
  }) async {
    try {
      /*NOTE CREATE user ke firestore authentication menggunakan function createUserWithEmailAndPassword
      ****** CREATE ini berbeda dengan Create ke collections
      */
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      UserModel user = UserModel(
          id: userCredential.user!.uid,
          email: email,
          name: name,
          password: password,
          role: role,
          birth: birth,
          gender: gender,
          phone: phone,
          address: address);

      //NOTE CREATE user ke firestore database, data user akan ditambahkan ke collection users
      await UserService().setUser(user);

      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      //NOTE READ user login ke firestore authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      /*NOTE READ setelah user barhasil login, cek data pada firestore database
      ****** menggunakan id yang didapatkan dari login ke firestore authenctication
      */
      UserModel user =
          await UserService().getUserById(userCredential.user!.uid);

      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
