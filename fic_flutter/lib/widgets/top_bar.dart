import 'package:flutter/material.dart';
//import 'package:fic_flutter/widgets/data_search.dart';
import 'package:fic_flutter/widgets/breadcrumb.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String page;
  const TopBar({
    Key? key,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 60,
      backgroundColor: Colors.green,
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
                //Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              iconSize: 35,
            ),
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                //Navigator.popUntil(context, ModalRoute.withName('/'));
                BreadcrumbBar.homePressed(context);
              },
              iconSize: 50,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Text(page)),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Image.asset('assets/images/FIC logo.png'),
          onPressed: () {
            //Navigator.popUntil(context, ModalRoute.withName('/'));
            BreadcrumbBar.homePressed(context);
          },
          iconSize: 50,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
