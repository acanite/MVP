defmodule App.MixProject do
  use Mix.Project

  def project do
    [
      app: :app,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        c: :test,
        coveralls: :test,
        "coveralls.json": :test,
        "coveralls.html": :test,
        t: :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {App.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.6.10"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.17.5"},
      {:floki, ">= 0.30.0", only: :test},
      {:esbuild, "~> 0.4", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},

      # Easily Encrypt Senstive Data: github.com/dwyl/fields
      {:fields, "~> 2.8"},
      # Auth with ONE Environment Variable™: github.com/dwyl/auth_plug
      {:auth_plug, "~> 1.4"},
      # Useful functions: github.com/dwyl/useful
      {:useful, "~> 1.0.8"},

      # create docs on localhost by running "mix docs"
      {:ex_doc, "~> 0.22.6", only: :dev, runtime: false},
      # track test coverage
      {:excoveralls, "~> 0.14.5", only: [:test, :dev]},
      # git pre-commit hook runs tests before allowing commits
      {:pre_commit, "~> 0.3.4"},
      {:credo, "~> 1.6.4", only: [:dev, :test], runtime: false},

      # Ref: https://github.com/dwyl/learn-tailwind
      {:tailwind, "~> 0.1", runtime: Mix.env() == :dev},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      c: ["coveralls.html"],
      s: ["phx.server"],
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      t: ["test"],
      "assets.deploy": ["esbuild default --minify", "phx.digest"]
    ]
  end
end
