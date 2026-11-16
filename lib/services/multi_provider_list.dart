


import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:vivahbharath_app/provider/home_provider.dart';
import 'package:vivahbharath_app/provider/register_provider.dart';
import 'package:vivahbharath_app/provider/shortlist_provider.dart';

class MultiProviderList {
  static List<SingleChildWidget> providerList = [
    ChangeNotifierProvider(create: (_) => RegisterProvider()),
    ChangeNotifierProvider(create: (_) => HomeProvider()),
    // ChangeNotifierProvider(create: (_) => ShortlistProvider()),
  ];
}
