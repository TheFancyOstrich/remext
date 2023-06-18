import Config
version = "0.1.1"

if config_env() == :release do
  config :remext, filepath: System.user_home!() <> "/.config/remext.json", version: version
end
