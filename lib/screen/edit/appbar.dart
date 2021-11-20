import 'package:notes/_app_packages.dart';
import 'package:notes/_internal_packages.dart';

class EditAppBar extends StatelessWidget with PreferredSizeWidget {
  const EditAppBar(
      {final Key? key,
      required this.note,
      required this.saveNote,
      required this.autoSaverTimer})
      : super(key: key);

  final Note note;
  final Future<bool> Function() saveNote;
  final Timer autoSaverTimer;

  @override
  Widget build(final BuildContext context) {
    return AppBar(
      leading: BackButton(
        onPressed: () {
          autoSaverTimer.cancel();
          unawaited(saveNote().then((final value) {
            if (!value) {
              Utilities.showSnackbar(context, Language.of(context).error);
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
            // TODO PDF Support
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
