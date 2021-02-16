defmodule ExUssdSimulator.Router do
  use ExUssdSimulator.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/" do
    pipe_through(:browser)

    live "/", ExUssdSimulator.PageLive, :index
  end
end
