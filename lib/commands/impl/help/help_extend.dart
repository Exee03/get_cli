import '../../../common/utils/logger/log_utils.dart';
import '../../commands_list_extend.dart';
import '../../interface/command.dart';
import 'help.dart' as origin;

class HelpCommand extends origin.HelpCommand {
  @override
  Future<void> execute() async {
    final commandsHelp = _getCommandsHelp(commands, 0);
    LogService.info('''
List available commands: 
$commandsHelp
''');
  }

  String _getCommandsHelp(List<Command> commands, int index) {
    commands.sort((a, b) {
      if (a.commandName.startsWith('-') || b.commandName.startsWith('-')) {
        return b.commandName.compareTo(a.commandName);
      }
      return a.commandName.compareTo(b.commandName);
    });
    var result = '';
    for (var command in commands) {
      result += '\n ${'  ' * index} ${command.commandName}:  ${command.hint}';
      result += _getCommandsHelp(command.childrens, index + 1);
    }
    return result;
  }
}
