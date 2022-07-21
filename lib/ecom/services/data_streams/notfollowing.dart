import 'package:new_swarn_holidays/ecom/services/data_streams/data_stream.dart';
import 'package:new_swarn_holidays/ecom/services/database/user_database_helper.dart';

class NotFollowingStream extends DataStream<List<String>?> {
  @override
  void reload() {
    final addressesList = UserDatabaseHelper().usersNotFollowing;
    addressesList.then((list) {
      addData(list);
    }).catchError((e) {
      addError(e);
    });
  }
}
