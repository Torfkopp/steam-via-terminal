# Elvish Wrapper for the powershell scripts

var rc_path = {Your Path}

fn game { |x| powershell $rc_path\start_game.ps1 $x }

set edit:completion:arg-completer[game:game] = {|@args|
    for x [(powershell $rc_path\get_games.ps1)] { put $x }
}