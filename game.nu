let path = '{Your Path}'

let completions = powershell -c ($path | path join get_games.ps1) | decode utf-8 | split row ","

def games [] { 
	{
		options: {
			case_sensitive: false,
			completion_algorithm: fuzzy,
		},
		completions: $completions
	}
}

export def game [game: string@games, ...args] {
	let para = $game + " " + ($args | str join " ")
	powershell -c ($path | path join start_game.ps1) $para
}
