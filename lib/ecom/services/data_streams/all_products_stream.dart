import 'package:new_swarn_holidays/ecom/services/data_streams/data_stream.dart';
import 'package:new_swarn_holidays/ecom/services/database/product_database_helper.dart';

class AllProductsStream extends DataStream<List<String>> {
  @override
  void reload() {
    final allProductsFuture = ProductDatabaseHelper().allProductsList;
    allProductsFuture.then((favProducts) {
      addData(favProducts);
    }).catchError((e) {
      addError(e);
    });
  }
}
