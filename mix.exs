defmodule Rumbl.Mixfile do
  use Mix.Project

  def project do
    [app: :rumbl,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Rumbl, []},
     applications: [:phoenix, 
                    :phoenix_pubsub,
                    :phoenix_html, 
                    :oauth2,                
                    :cowboy, 
                    :logger, 
                    :gettext,
                    :phoenix_ecto, 
                    :postgrex, 
                    :arc_ecto, 
                    :ex_aws, 
                    :hackney,
                    :jsx, 
                    :httpoison, 
                    :poison, 
                    :verk, 
                    :verk_web,
                    :porcelain,
                    :ex_google]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:arc, "~> 0.8.0", override: true},
     {:arc_ecto, "~> 0.7.0", override: true},
     {:oauth2, "~> 0.9.1"},    
     {:ex_aws, "~> 1.1.2"},
     {:hackney, "~> 1.7.1", override: true},
     {:httpoison, "~> 0.11.2", override: true},
     {:poison, "~> 3.1", override: true},
     {:jsx, "~> 2.8.2"},
     {:sweet_xml, "~> 0.6"},
     {:verk, "~> 0.13"},
     {:drab, "~> 0.3.2"},
     {:stash, "~> 1.0.0"},
     {:ex_google, "~> 0.1.4"},
     {:verk_web, "~> 0.13.6"},
     {:porcelain, "~> 2.0.3"},
     {:phoenix, "~> 1.2.3"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.2.1"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.9.2"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:comeonin, "~> 2.5"},
     {:cowboy, "~> 1.0.4"}]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
