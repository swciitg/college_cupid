import 'package:college_cupid/domain/models/update_model.dart';

abstract class UpdatesRepository {
  Future<List<UpdateModel>> fetchUpdates({int page = 0, String? filter});
}
