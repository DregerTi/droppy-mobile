import '../../../core/ressources/data_state.dart';
import '../entities/content.dart';

abstract class ContentRepository {

  Future<DataState<List<ContentEntity?>?>> searchContent(Map<String, dynamic> params);

}