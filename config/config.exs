import Config

if config_env() == "release" do
  import_config "release.exs"
end
