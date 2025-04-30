const paths = [
	"S:/Steam/steamapps",
	"M:/SteamLibrary/steamapps"
]

let completions = $paths | each {|path| 
		ls $path | where name =~ ".acf$" | each {|file|
			$file | get name | open | lines | 
			filter {|it| $it =~ '"name"'} | split column -c "\t" | 
			reject column1 | str trim --char '"'
		}
	}  | flatten | flatten | sort-by column2 --ignore-case | each { values | into string } | flatten
	

def compl [] {
	{
		options: {
			case_sensitive: false,
			completion_algorithm: fuzzy,
		},
		completions: $completions
	}
}

export def game [search: string@compl, ...args] {
	let searchName = $search + " " + ($args | str join " ")
	mut results = $paths | each {|path|
		ls $path | where name =~ ".acf$" | each {|file|
			$file | get name | open | lines | 
			filter {|it| $it =~ '"appid"' or $it =~ '"name"' } |
			split column -c "\t" | str trim --char '"' | transpose -r | insert path $path
		}
	}

	$results = $results | flatten | flatten |
		sort-by name --ignore-case | where name =~ $searchName 

	if ($results | length) > 1 {
		$results
	} else if ($results | length) == 1 {
		let appid = $results | get 0.appid
		print $"(ansi green)Launching ($results | get 0.name) \(AppID: ($appid)\)..."
		^start steam://rungameid/$appid
	} else {
		print $"(ansi red)No matches found for ($searchName)"
	}
}