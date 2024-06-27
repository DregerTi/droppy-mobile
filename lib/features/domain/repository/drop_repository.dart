import '../../../core/ressources/data_state.dart';
import '../entities/drop.dart';

abstract class DropRepository {

  Future<DataState<List<DropEntity>>> getDrops(Map<String, dynamic> params);

  Future<DataState<DropEntity>> getDrop(Map<String, dynamic> params);

  Future<DataState<List<DropEntity>>> getUserDrops(Map<String, dynamic> params);

  Future<DataState<DropEntity>> postDrop(Map<String, dynamic> params);

}