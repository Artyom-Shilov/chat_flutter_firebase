import 'package:uuid/v1.dart';

class IdGenerator {
  IdGenerator._();

  static final IdGenerator _instance = IdGenerator._();
  final _uuidV1 = const UuidV1();

  static IdGenerator get I => _instance;

  String generateUuidV1() {
    return _uuidV1.generate();
  }
}