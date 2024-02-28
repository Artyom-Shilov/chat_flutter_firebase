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
  static const String setAppUserRu = 'Ошибка входа';
  static const String wrongPasswordRu = 'Неверный пароль';
  static const String emailAlreadyInUse = 'Пользователь с таким email уже существует';
  static const String commonAuthErrorRu = 'Ошибка авторизации';
}

abstract class ChatTexts {

  static const String chatListAppBarTitleRu = 'Мои чаты';
  static const String noUserChatsMessageRu = 'К сожалению, вы не состоите ни в одном чате. Воспользуйтесь поиском или создайте свой.';

  static const String doEnterChatNameRu = 'Введите название чата';
  static const String createRu = 'Создать';
  static const String cancelRu = 'Отмена';

  static const String chatAlreadyExistsFieldErrorRu = 'Чат уже существет';
  static const String chatNameLengthFieldErrorRu = 'Минимальная длинна - один символ';

  static const String chatSearchHintRu = 'Поиск чата';
  static const String chatSearchLengthFieldErrorRu = 'Минимальная длинна - один символ';
  static const String noChatsFoundRu = 'К сожалению, чатов по запросу не найдено';
  static const String initSearchMessageRu = 'Пожалуйста, введите значение для поиска';
  static const String userAlreadyJoinedMarkRu = 'Уже состою';
  static const String doJoinRu = 'Вступить';
}

abstract class ChatErrorsTexts {

  static const String createChatRu = 'Ошибка в процессе создания чата';
  static const String loadUserChatsRu = 'Ошибка получения чатов пользователя';
  static const String searchChats = 'Ошибка в процессе поска чатов';
  static const String noConnectionRU = 'Нет подключения к сети';
  static const String joinChatRu = 'Ошибка в процессе присоединения к чату';
  static const String leaveChatRu = 'Ошибка в процессе выхода из чата';
}

abstract class PopUpMenuTexts {
  static const String leaveChatRu = 'Покинуть чат';
  static const String disableNotificationsRu = 'Отключить уведомления';
  static const String enableNotificationsRu = 'Включить уведомления';
}

abstract class MessagingTexts {
  static const memberLeftChatRu = 'Пользователь покинул чат';
  static const memberJoinedRu = 'присоединился';
  static const addPhotoFromGalleryRu = 'Выбрать фото из галерии';
  static const addVideoFromGalleryRu = 'Выбрать видео из галерии';
  static const addPhotoFromCameraRu = 'Снять фото';
  static const messageInputHintRu = 'Сообщение';
}

abstract class MessagingErrorsTexts {

  static const String loadMessagesRu = 'Ошибка получения сообщений';
  static const String sendMessageRu = 'Ошибка отправки сообщений';
  static const String changeNotificationsStatus = 'Ошибка смены статуса';
  static const String noConnectionRu = 'Нет доступа к сети';
}

abstract class NotificationsTexts {
  static const String newTextMessageRu = 'Пришло новое сообщение';
  static const String newVideoRu = 'Пришло видео  🎞️';
  static const String newImageRu = 'Пришло изображение  📷';
}