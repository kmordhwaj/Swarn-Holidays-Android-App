import 'package:new_swarn_holidays/ecom/services/data_streams/data_stream.dart';
import 'package:new_swarn_holidays/ecom/services/database/user_database_helper.dart';

class FavouriteProductsStream extends DataStream<List<String>> {
  @override
  void reload() {
    final favProductsFuture = UserDatabaseHelper().usersFavouriteProductsList;
    favProductsFuture.then((favProducts) {
      addData(favProducts!.cast<String>());
    }).catchError((e) {
      addError(e);
    });
  }
}
