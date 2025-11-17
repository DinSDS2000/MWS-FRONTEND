import 'package:flutter/material.dart';

void showAlertPopup(BuildContext context, String title, String detail) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevents dialog from closing when tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(detail),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}


// import 'package:flutter/material.dart';

// void showAlertPopup(BuildContext context, String title, String detail) async {
//   void showDemoDialog<T>({required BuildContext context, required Widget child}) {
//     showDialog<T>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) => child,
//     );
//   }

//   return showDemoDialog<Null>(
//       context: context,
//       child: NativeDialog(
//         title: Text(title),
//         content: Text(detail),
//         actions: <NativeDialogAction>[
//           NativeDialogAction(
//               text: Text('OK'),
//               isDestructive: false,
//               onPressed: () {
//                 Navigator.pop(context);
//               }),
//         ],
//       ));
// }

