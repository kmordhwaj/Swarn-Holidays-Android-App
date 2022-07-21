import 'package:new_swarn_holidays/ecom/services/data_streams/data_stream.dart';
import 'package:new_swarn_holidays/ecom/services/database/user_database_helper.dart';

class OrderedProductsStream extends DataStream<List<String>> {
  @override
  void reload() {
    final orderedProductsFuture = UserDatabaseHelper().orderedProductsList;
    orderedProductsFuture.then((data) {
      addData(data);
    }).catchError((e) {
      addError(e);
    });
  }
}
