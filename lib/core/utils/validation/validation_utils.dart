class ValidationUtils {
  static String? nameValidation(String? value){
    if(value == null || value.isEmpty){
      return 'Please, fill up name field';
    }
    return null;
  }

  static String? emailValidation(String? value){
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if(value == null || value.isEmpty){
      return 'Please, fill up email field';
    } else if(!emailRegex.hasMatch(value)){
      return 'Please, enter your valid email';
    }

    return null;
  }

  static String? passwordValidation(String? value){
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$',
    );

    if(value == null || value.isEmpty){
      return 'Please, fill up password filed.';
    } else if(value.length < 8){
      return 'Password must be 8 characters long';
    } else if(!passwordRegex.hasMatch(value)){
      return 'Password must contain at least one number, upper case, lower case, and special character';
    }
    return null;
  }
}