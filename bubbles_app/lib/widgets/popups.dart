import 'package:bubbles_app/models/bubble.dart';
import 'package:bubbles_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../pages/bubble_page.dart';
import '../widgets/rounded_image.dart';

Future<String?> bubblePopup(BuildContext context, Bubble bubble) {
  NavigationService navigation = GetIt.instance.get<NavigationService>();
  double deviceHeight = MediaQuery.of(context).size.height;
  double deviceWidth = MediaQuery.of(context).size.width;

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: SizedBox(
        height: deviceHeight * 0.5,
        width: deviceWidth * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RoundedImageNetwork(
                imagePath: bubble.getImageURL(),
                size: deviceHeight * 0.2,
                key: UniqueKey(),
              ),
              Text("Name: ${bubble.getName()}"),
              Text("Location: ${bubble.getLocation()}"),
              Text("Memmbers: ${bubble.getLenght()}"),
              Text("KeyType: ${bubble.getMethod()}"),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      navigation.navigateToPage(BubblePage(bubble: bubble));
                    },
                    child: const Text('Join'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancle'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<String?> myMessagePopup(BuildContext context) {
  NavigationService navigation = GetIt.instance.get<NavigationService>();

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
