import 'package:flutter/cupertino.dart';
import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class EditAppBar extends StatelessWidget with PreferredSizeWidget {
  const EditAppBar(
      {Key? key,
      required this.note,
      required this.saveNote,
      required this.autoSaverTimer})
      : super(key: key);

  final Note note;
  final Future<bool> Function() saveNote;
  final Timer autoSaverTimer;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: BackButton(
        onPressed: () {
          autoSaverTimer.cancel();
          unawaited(saveNote().then((value) {
            if (!value) {
              Utilities.showSnackbar(context, 'Error while saving note');
            }
          }));
          Navigator.of(context).pop();
        },
        color: Colors.white,
      ),
      actions: [
        IconButton(
          onPressed: () async {
            if (note.title.isEmpty && note.content.isEmpty) {
              Utilities.showSnackbar(context, Language.of(context).emptyNote);
              return;
            }
            if (await Utilities.requestPermission(Permission.storage)) {
              await saveNote();
              await HapticFeedback.vibrate();
              await PdfUtils.createPdf(context, note);
              Utilities.showSnackbar(context, Language.of(context).done);
            } else {
              await showDialog<void>(
                barrierDismissible: true,
                context: context,
                builder: (context) => MyAlertDialog(
                  title: Text(Language.of(context).error),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(Language.of(context).permissionError),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      child: Text(Language.of(context).alertDialogOp2),
                    ),
                  ],
                ),
              );
            }
          },
          icon: const Icon(Icons.print),
        ),
      ],
      elevation: 1,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
