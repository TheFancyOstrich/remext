import Config

if config_env() == :release do
  config :remext, filepath: System.user_home!() <> "/.config/remext.json"
end
