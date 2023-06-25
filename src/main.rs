mod json_manager;
use clap::{App, AppSettings, Arg};
use json_manager::{add, delete, get, search};
fn main() {
    let matches = app().get_matches();
    let search_keys = matches.is_present("search_keys");
    let search_values = matches.is_present("search_values");
    let del = matches.is_present("delete");

    if let Some(key) = matches.value_of("key") {
        if let Some(value) = matches.value_of("set") {
            println!("{}", add(key, value, del));
        } else if del {
            println!("{}", delete(key));
        } else if search_keys || search_values {
            for v in search(key, search_keys, search_values) {
                println!("{}", v);
            }
        } else {
            println!("{}", get(key))
        }
    } else {
        for v in search("", search_keys, search_values) {
            println!("{}", v);
        }
    }
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
                .long("both")
                .help("Search values")
                .conflicts_with("set")
                .conflicts_with("delete"),
        )
        .setting(AppSettings::ArgRequiredElseHelp)
}
