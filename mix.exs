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
  defp deps do    [
     {:arc_ecto, "~> 0.7.0", override: true},
     {:arc, "~> 0.8.0", override: true},
     {:comeonin, "~> 2.5"},
     {:cowboy, "~> 1.0.4"},
     {:drab, "~> 0.4.0"},
     {:ex_aws, "~> 1.1.2"},
     {:ex_google, "~> 0.1.4"},
     {:gettext, "~> 0.11"},
     {:hackney, "~> 1.7.1", override: true},
     {:httpoison, "~> 0.11.2", override: true},
     {:jsx, "~> 2.8.2"},
     {:oauth2, "~> 0.9.1"},    
     {:phoenix_ecto, "~> 3.2.1"},
     {:phoenix_html, "~> 2.9.2"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix, "~> 1.2.3"},
     {:poison, "~> 3.1", override: true},
     {:porcelain, "~> 2.0.3"},
     {:postgrex, ">= 0.0.0"},
     {:sobelow, ">= 0.2.4"},
     {:stash, "~> 1.0.0"},
     {:sweet_xml, "~> 0.6"},
     {:verk_web, "~> 0.14"},
     {:verk, "~> 0.14"}   ]
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
