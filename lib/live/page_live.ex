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
    {:noreply, build_menu(socket)}
  end

  def build_menu(socket) do
    prompt = ussd_response(socket)
    socket |> assign(prompt: prompt)
  end

  defp new_session(socket) do
    random_session_id = Enum.random(123_123_123..999_999_999)
    opts = ExUssdSimulator.value()

    socket =
      socket
      |> assign(session_id: random_session_id)
      |> assign(menu: opts[:menu])
      |> assign(ussd_code: "")
      |> build_menu()
  end

  def ussd_response(socket) do
    internal_routing = %{
      text: socket.assigns.ussd_code,
      session_id: socket.assigns.session_id,
      service_code: "*234#"
    }

    api_parameters = %{"text" => internal_routing.text, "phone_number" => "254722000000"}

    route =
      ExUssd.Routes.get_route(%{
        text: internal_routing.text,
        service_code: internal_routing.service_code
      })

    %{display: menu_string, menu: %{should_close: _should_close}} =
      EXUssd.Common.goto(
        internal_routing: internal_routing,
        menu: socket.assigns.menu,
        api_parameters: api_parameters,
        route: route
      )

    menu_string
  end
end
