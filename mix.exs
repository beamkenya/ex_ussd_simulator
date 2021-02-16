defmodule ExUssdSimulator.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_ussd_simulator,
      version: "0.1.2",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      description: "A development UI for ExUssd",
      package: package()
    ]
  end

  defp package do
    [
      name: "ex_ussd_simulator",
      licenses: ["MIT"],
      maintainers: [],
      links: %{
        "GitHub" => "https://github.com/PJUllrich/ex_ussd_simulator.git",
        "README" => "https://hexdocs.pm/ex_ussd_simulator/readme.html"
      },
      homepage_url: "https://github.com/PJUllrich/ex_ussd_simulator"
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {ExUssdSimulator.Application, []}
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
      {:phoenix, "~> 1.5.7"},
      {:phoenix_live_view, "~> 0.15.0"},
      {:floki, ">= 0.27.0", only: :test},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:httpoison, "~> 1.8"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
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
      setup: ["deps.get", "cmd npm install --prefix assets"],
      "assets.compile": &compile_assets/1
    ]
  end

  defp compile_assets(_args) do
    Mix.shell().cmd(
      ~S(cd ./assets; NODE_ENV=production ./node_modules/.bin/webpack --mode production)
    )
  end
end
