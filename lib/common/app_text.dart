abstract class AuthText {

  static const String passwordHintRu = 'Пароль';
  static const String usernameHintRu = 'Имя пользователя';
  static const String emailHintRu = 'Email';
  static const String additionalSignInOptionsRu = 'Или войти, используя';
  static const String doSignInRu = 'Войти';
  static const String doRegisterRu = 'Зарегистрировать';
  static const String toRegistrationRu = 'Регистрация';
  static const String toLoginRu = 'Логин';
  static const String doLogout = 'Выйти';

  static const String emailValidationErrorRu = 'Пожалуйста, введите валидный Email';
  static const String passwordValidationLengthErrorRu = 'Пароль должен иметь минимум 6 символов';
  static const String usernameValidationLengthErrorRu = 'Имя пользователя должно быть от 1 до 40 символов';
}

abstract class AuthErrorTexts {

  static const String createUserByEmailAndPasswordRu = 'Ошибка в процессе создания пользователя';
  static const String signInByEmailAndPasswordRu = 'Ошибка в процессе авторизации через Email и пароль';
  static const String signInByGoogleRu = 'Ошибка в процессе авторизации через Google-аккаунт';
  static const String signOut = 'Ошибка в процессе выхода';
  static const String noConnectionRU = 'Нет подкючения к сети';
}

abstract class ChatTexts {

  static const String doEnterChatNameRu = 'Введите название чата';
  static const String createRu = 'Создать';
  static const String cancelRu = 'Отмена';

  static const String chatAlreadyExistsFieldErrorRu = 'Чат уже существет';
  static const String chatNameLengthFieldErrorRu = 'Минимальная длинна - один символ';

  static const String chatSearchHintRu = 'Введите значение для поиска';
  static const String chatSearchLengthFieldErrorRu = 'Минимальная длинна - один символ';
}