defmodule ExUssdSimulator.PageLive do
  use ExUssdSimulator.Web, :live_view

  require Logger

  alias ExUssdSimulator.Config

  @callback_url_unavailable_error "This is a Test prompt. We could not access your ExUssd-Endpoint. Please make sure that you accept ExUssd-Calls at "

  @impl true
  def render(assigns), do: ExUssdSimulator.PageView.render("show.html", assigns)

  @impl true
  def mount(_params, _session, socket) do
    {:ok, new_session(socket)}
  end

  @impl true
  def handle_event("button_clicked", %{"val" => value}, socket) do
    {:noreply, update(socket, :ussd_code, &(&1 <> value))}
  end

  @impl true
  def handle_event("undo_last", _params, socket) do
    {:noreply, update(socket, :ussd_code, fn code -> code |> String.split_at(-1) |> elem(0) end)}
  end

  @impl true
  def handle_event("end_session", _params, socket) do
    {:noreply, new_session(socket)}
  end

  @impl true
  def handle_event("call", _params, socket) do
    {:noreply, execute(socket)}
  end

  defp new_session(socket) do
    random_session_id = Enum.random(123_123_123..999_999_999)

    socket
    |> assign(session_id: random_session_id)
    |> show_home_prompt()
  end

  defp execute(socket) do
    result = execute_ussd_code(socket)
    set_prompt(socket, result)
  end

  defp show_home_prompt(socket) do
    socket
    |> reset_ussd_code()
    |> execute()
  end

  defp execute_ussd_code(%{assigns: %{ussd_code: ussd_code, session_id: session_id}}) do
    callback_url = Config.callback_url()
    service_code = Config.service_code()
    headers = [{"Content-Type", "application/json"}]

    body =
      %{
        text: ussd_code,
        sessionId: session_id,
        serviceCode: service_code
      }
      |> Jason.encode!()

    case HTTPoison.post(callback_url, body, headers) do
      {:ok, %{body: prompt}} ->
        prompt

      error ->
        Logger.error(inspect(error))

        @callback_url_unavailable_error <> callback_url
    end
  end

  defp reset_ussd_code(socket) do
    assign(socket, ussd_code: "")
  end

  defp set_prompt(socket, prompt) do
    socket
    |> assign(prompt: prompt)
    |> reset_ussd_code()
  end
end
