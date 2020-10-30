defmodule TerrariumWeb.PageLive do
  use TerrariumWeb, :live_view
  alias Terrarium.Grid

  @impl true
  def mount(_params, _session, socket) do
    update()

    map =
      Grid.create([
        ["1", "#", "#", "#"],
        ["2", "━", "┓", "#"],
        ["3", "#", "┃", "#"],
        ["4", "#", "#", "#"]
      ])
      |> Grid.to_rows_as_strings()

    {:ok, assign(socket, query: "", results: %{}, counter: 0, map: map)}
  end

  @impl true
  def handle_info(:update, %{assigns: %{counter: counter}} = socket) do
    update()
    {:noreply, assign(socket, :counter, counter + 1)}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, results: search(query), query: query)}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case search(query) do
      %{^query => vsn} ->
        {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "No dependencies found matching \"#{query}\"")
         |> assign(results: %{}, query: query)}
    end
  end

  defp search(query) do
    if not TerrariumWeb.Endpoint.config(:code_reloader) do
      raise "action disabled when not in development"
    end

    for {app, desc, vsn} <- Application.started_applications(),
        app = to_string(app),
        String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
        into: %{},
        do: {app, vsn}
  end

  defp update() do
    Process.send_after(self(), :update, 1_000)
  end
end
