import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/common/backgroundimage.dart';

class PlayStorePage extends StatelessWidget {
  const PlayStorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(children: [
        const BackgroundImage(),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("explore the group of thousand's of sellers"),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  const String playstoreUrl =
                      "https://www.playstore.com/in/swarn_holidays_business";
                  Uri url = Uri.parse(playstoreUrl);
                  await launchUrl(url);
                },
                child: Container(
                  height: 100,
                  width: 200,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      gradient:
                          LinearGradient(colors: [Colors.pink, Colors.blue])),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Download From Google Play Store',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }

  Future<void> launchUrl(Uri url) async {
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        Logger().i("PlayStore URL was unable to launch");
      }
    } catch (e) {
      Logger().e("Exception while launching URL: $e");
    }
  }
}
