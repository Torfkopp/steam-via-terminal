var rc_path = C:\Users\{Your Name}\AppData\Roaming\elvish

fn game { |x| powershell $rc_path\steam_ids.ps1 $x }

set edit:completion:arg-completer[game:game] = {|@args|
    for x [(powershell $rc_path\steam_auto_complete.ps1)] { put $x }
}