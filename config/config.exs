import Config
version = "0.1.0"

if config_env() == :release do
  config :remext, filepath: "~/.config/remext.json", version: version
end
