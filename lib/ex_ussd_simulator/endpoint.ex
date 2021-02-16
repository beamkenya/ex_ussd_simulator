defmodule ExUssdSimulator.Endpoint do
  use Phoenix.Endpoint, otp_app: :ex_ussd_simulator

  @default_config [
    url: [host: "localhost"],
    http: [port: 5123],
    check_origin: false,
    code_reloader: true,
    debug_errors: true,
    secret_key_base: "3PdUemfBrX7aJXqxVnAXfE0kYAOCBKeCrTVhzlOXUxcYWbnIkoVyzfvqMkonZ8lL",
    live_view: [signing_salt: "FmP4_vbMsSj1AgdC"],
    pubsub_server: ExUssdSimulator.PubSub
  ]

  def init(:supervisor, opts) do
    opts = Keyword.merge(opts, @default_config)
    {:ok, opts}
  end

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "ex_ussd_simulator",
    signing_salt: "y48I8pqR7Dhrlcz/EUgQIQN94+t+JcQv"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :ex_ussd_simulator,
    gzip: false,
    only: ~w(css js favicon.ico)

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug ExUssdSimulator.Router
end
