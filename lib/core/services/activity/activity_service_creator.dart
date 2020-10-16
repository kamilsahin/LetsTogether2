
import 'package:letstogether/core/services/activity/activity_service.dart';
import 'package:letstogether/core/services/activity/activity_service_store.dart';


class ActivityServiceCreator {
  
  ActivityServiceCreator._privateConstructor();

  static final ActivityService _instance = new ActivityServiceStore();

  static ActivityService get instance => _instance;


}