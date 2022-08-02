import '../../../../common/menu/menu.dart';
import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../../common/utils/shell/shel.utils.dart';
import 'init.dart' as origin;
import 'init_getxpattern.dart';
import 'init_katteko.dart';
import 'init_reka.dart';

class InitCommand extends origin.InitCommand {
  @override
  Future<void> execute() async {
    final menu = Menu([
      'Reka (by Rekamy)',
      'GetX Pattern (by Kauê)',
      'CLEAN (by Arktekko)',
    ], title: 'Which architecture do you want to use?');
    final result = menu.choose();

    switch (result.index) {
      case 0:
        createInitReka();
        break;
      case 1:
        createInitGetxPattern();
        break;
      case 2:
        createInitKatekko();
        break;
      default:
        createInitReka();
    }
    if (!PubspecUtils.isServerProject) {
      await ShellUtils.pubGet();
    }
    return;
  }
}
