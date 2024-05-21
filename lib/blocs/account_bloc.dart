import 'dart:async';

class AccountBloc{
  final StreamController _emailController = StreamController();
  final StreamController _passwordController = StreamController();
  final StreamController _bioController = StreamController();
  final StreamController _usernameController = StreamController();

  Stream get emailStream => _emailController.stream;
  Stream get passwordStream => _passwordController.stream;
  Stream get bioStream => _bioController.stream;
  Stream get usernameStream => _usernameController.stream;

  bool isValidForGotPassword(String email) {
    if(email.isEmpty){
      _emailController.sink.addError('Please enter your email');
      return false;
    }
    if(!email.contains('@')){
      _emailController.sink.addError('Your email is not valid');
      return false;
    }
    _emailController.sink.add('');
    return true;
  }

  bool isValidLogin(String email, String password) {
    if(email.isEmpty){
      _emailController.sink.addError('Please enter your email');
      return false;
    }
    if(!email.contains('@')){
      _emailController.sink.addError('Your email is not valid');
      return false;
    }
    _emailController.sink.add('');
    if(password.isEmpty){
      _passwordController.sink.addError('Please enter your password ');
      return false;
    }
    _passwordController.sink.add('');

    return true;
  }

  bool isValidSignup(String username, String bio, String email, String password) {
    if(username.isEmpty){
      _usernameController.sink.addError('Please enter your name');
      return false;
    }
    _usernameController.sink.add('');
    if(bio.isEmpty){
      _bioController.sink.addError('Please enter your description');
      return false;
    }
    _bioController.sink.add('');
    if(email.isEmpty){
      _emailController.sink.addError('Please enter your email');
      return false;
    }
    if(!email.contains('@')){
      _emailController.sink.addError('Your email is not valid');
      return false;
    }
    _emailController.sink.add('');
    if(password.isEmpty){
      _passwordController.sink.addError('Please enter your password ');
      return false;
    }
    _passwordController.sink.add('');
    return true;
  }

  void dispose() {
    _emailController.close();
    _passwordController.close();
    _bioController.close();
    _usernameController.close();

  }

}