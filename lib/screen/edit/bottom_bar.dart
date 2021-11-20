import 'package:notes/_app_packages.dart';
import 'package:notes/_internal_packages.dart';

class BottomBar extends StatelessWidget {
  const BottomBar(
      {final Key? key,
      required this.note,
      required this.saveNote,
      required this.onIconTap,
      required this.isReadOnly,
      required this.autoSaverTimer})
      : super(key: key);

  final Note note;
  final Future<void> Function() saveNote;
  final OnTap onIconTap;
  final bool isReadOnly;
  final Timer autoSaverTimer;

  @override
  Widget build(final BuildContext context) {
    final primaryColor =
        Color(getIntFromSF('primaryColor') ?? defaultPrimary.value);
    final appTheme = AppTheme.values[getIntFromSF('appTheme') ?? 0];
    return BottomAppBar(
      child: Container(
        color: Theme.of(context).canvasColor,
        height: kBottomNavigationBarHeight,
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.lock_outline),
              onPressed: onIconTap,
              color: isReadOnly
                  ? primaryColor
                  : appTheme == AppTheme.light
                      ? Colors.black
                      : Colors.white,
            ),
            Center(
              child: Text(
                '${Language.of(context).modified} '
                '${note.strLastModifiedDate1}',
              ),
            ),
            IconButton(
              onPressed: () async {
                await saveNote();
                if (note.content.isEmpty && note.title.isEmpty) {
                  Utilities.showSnackbar(
                      context, Language.of(context).emptyNote);
                } else {
                  moreMenu(context);
                }
              },
              icon: const Icon(Icons.more_vert_outlined),
              tooltip: Language.of(context).more,
            ),
          ],
        ),
      ),
    );
  }

  void moreMenu(final BuildContext context) {
    FocusScope.of(context).requestFocus(
      FocusNode(),
    );
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      context: context,
      builder: (final context) => Wrap(
        children: [
          BottomBarOptions(
            note: note,
            saveNote: saveNote,
            autoSaver: autoSaverTimer,
          ),
        ],
      ),
    );
  }
}
