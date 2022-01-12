import 'package:flutter/material.dart';
import 'package:fic_flutter/widgets/breadcrumb.dart';

class NavigationButton extends StatelessWidget {
  final String title;
  final String imageURL;
  final String route;

  const NavigationButton({
    Key? key,
    required this.title,
    this.imageURL = 'assets/images/sheep icon.png',
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: MaterialButton(
        onPressed: () {
          Navigator.pushNamed(context, route);
          breadcrumb.add(route);
        },
        child: SizedBox(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.lightGreen[50],
              border: Border.all(),
            ),
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    title,
                    style: const TextStyle(color: Colors.black, fontSize: 17),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Image.asset(imageURL),
              ),
            ]),
          ),
          width: MediaQuery.of(context).size.width * 0.8,
          height: 60,
        ),
      ),
    );
  }
}
