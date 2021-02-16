use Mix.Config

config :ex_ussd_simulator, ExUssdSimulator.Endpoint,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--color",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ],
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/ex_ussd_simulator/(live|views)/.*(ex)$",
      ~r"lib/ex_ussd_simulator/templates/.*(eex)$"
    ]
  ]

config :ex_ussd_simulator, callback_url: "http://localhost:4000/api/callback"

config :phoenix, :json_library, Jason
