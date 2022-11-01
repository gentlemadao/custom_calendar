import 'model/date_model.dart';

/**
 * 保存一些缓存数据，不用再次去计算日子
 */
class CacheData {
  //私有构造函数
  CacheData._();

  static  final CacheData _instance = CacheData._();

  static CacheData get instance => _instance;

  Map<DateModel, List<DateModel>> monthListCache = {};

  Map<DateModel, List<DateModel>> weekListCache = {};

  static CacheData getInstance() {
    return _instance;
  }

  void clearData() {
    monthListCache.clear();
    weekListCache.clear();
  }
}
