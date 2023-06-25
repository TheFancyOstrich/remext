#[cfg(feature = "home_path")]
use home;
use serde_json::{self, json};
use std::{
    fs::OpenOptions,
    io::{Read, Write},
};
pub fn add(path: &str, value: &str, force: bool) -> String {
    let mut data = open_file();
    if force || get(path).is_empty() || get(path) == "null" {
        data[path] = serde_json::json!(value);
        save_file(data);
        return value.to_string();
    } else {
        return format!("Already set to {}. Use -d to override", get(path));
    }
}
pub fn get(path: &str) -> String {
    let data = open_file();
    return if data[path].is_null() {
        "".to_string()
    } else {
        data[path].to_string()
    };
}

pub fn search(term: &str, search_keys: bool, search_values: bool) -> Vec<String> {
    let data = open_file();
    let mut list = [].to_vec();
    if !search_keys && !search_values {
        return list;
    }

    if let Some(obj) = data.as_object() {
        for key in obj.keys() {
            if (search_keys && key.contains(term))
                || (search_values && data[key].to_string().contains(term))
            {
                list.push(format!("{}: {}", key, data[key].to_string()));
            }
        }
    }
    return list;
}

pub fn delete(path: &str) -> String {
    let mut data = open_file();
    let value = data[path].to_string();
    if let Some(obj) = data.as_object_mut() {
        obj.remove(path);
        save_file(json!(data));
        return value;
    }
    "".to_string()
}

fn open_file() -> serde_json::Value {
    let mut file = OpenOptions::new()
        .read(true)
        .write(true)
        .create(true)
        .open(get_file())
        .expect(&format!("Error reading {}", get_file()));
    let mut data = String::new();
    file.read_to_string(&mut data)
        .expect(&format!("Error reading {}", get_file()));
    serde_json::from_str(&data).expect(&format!("Unable to parse {}", get_file()))
}

fn save_file(data: serde_json::Value) {
    let content =
        serde_json::to_string(&data).expect(&format!("Failed to write to {}", get_file()));
    let mut file = OpenOptions::new()
        .write(true)
        .truncate(true)
        .open(get_file())
        .expect(&format!("Failed to write to {}", get_file()));
    file.write_all(content.as_bytes())
        .expect(&format!("Failed to write to {}", get_file()));
}

fn get_file() -> String {
    #[cfg(feature = "home_path")]
    {
        let dir = match home::home_dir() {
            Some(path) => path
                .as_path()
                .to_str()
                .expect("Cannot locate home dir")
                .to_owned(),
            None => panic!("Cannot locate home dir"),
        };
        return dir + "/.config/remext.json";
    }
    #[cfg(not(feature = "home_path"))]
    return "test.json".to_string();
}
