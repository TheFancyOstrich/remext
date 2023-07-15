mod json_manager;
use clap::{App, AppSettings, Arg};
use cli_clipboard::{ClipboardContext, ClipboardProvider};
use json_manager::{add, delete, get, search};
fn main() {
    let matches = app().get_matches();
    let search_keys = matches.is_present("search_keys");
    let search_values = matches.is_present("search_values");
    let del = matches.is_present("delete");
    let clipboard = matches.is_present("clipboard");
    if let Some(key) = matches.value_of("key") {
        if let Some(value) = matches.value_of("set") {
            let fetched_value = add(key, value, del);
            println!("{}", fetched_value);
            if clipboard {
                copy_to_clipboard(fetched_value)
            }
        } else if del {
            let fetched_value = delete(key);
            println!("{}", fetched_value);
            if clipboard {
                copy_to_clipboard(fetched_value);
            }
        } else if search_keys || search_values {
            let fetched_values = search(key, search_keys, search_values);
            for v in &fetched_values {
                println!("{}", v);
            }
            if clipboard && (&fetched_values).len() == 1 {
                copy_to_clipboard(fetched_values.get(0).unwrap().to_owned());
            }
        } else {
            let fetched_value = get(key);
            println!("{}", fetched_value);
            if clipboard {
                copy_to_clipboard(fetched_value);
            }
        }
    } else {
        for v in search("", search_keys, search_values) {
            println!("{}", v);
        }
    }
}

fn copy_to_clipboard(value: String) {
    let mut ctx = ClipboardContext::new().unwrap();
    ctx.set_contents(value).unwrap();
    ctx.get_contents().unwrap(); // Is not saved unless this is called. Bug in upstream?
}

fn app() -> App<'static, 'static> {
    let version = env!("CARGO_PKG_VERSION");
    App::new("Remext")
        .version(version)
        .author("Erik Engstedt (erik@flightless.dev)")
        .about("A simple cli for managing a key map with information you want to remember")
        .arg(
            Arg::with_name("key")
                .index(1)
                .value_name("KEY")
                .help("The key to query")
                .multiple(false),
        )
        .arg(
            Arg::with_name("set")
                .short("s")
                .long("set")
                .value_name("SET")
                .help("New value to set")
                .takes_value(true)
                .requires("key"),
        )
        .arg(
            Arg::with_name("delete")
                .short("d")
                .long("delete")
                .help("Delete or override key")
                .requires("key"),
        )
        .arg(
            Arg::with_name("search_keys")
                .short("q")
                .long("search")
                .help("Search keys")
                .conflicts_with("set")
                .conflicts_with("delete"),
        )
        .arg(
            Arg::with_name("search_values")
                .short("w")
                .long("searchw")
                .help("Search values")
                .conflicts_with("set")
                .conflicts_with("delete"),
        )
        .arg(
            Arg::with_name("clipboard")
                .short("c")
                .long("clipboard")
                .help("Copy to clipboard"),
        )
        .setting(AppSettings::ArgRequiredElseHelp)
}
