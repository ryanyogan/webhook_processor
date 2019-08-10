defmodule WebhookProcessor.Endpoint do
  @moduledoc """
  A plug that is responsible for logging request infor, parsing request body as
  JASON, matching routes, and dispatching responses.
  """

  use Plug.Router

  # Plug pipeline: log -> match -> decode JSON -> dispatch
  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)

  get "/ping" do
    send_resp(conn, 200, "Pong!")
  end

  # Handle incomving events, if the payload matches process
  # the events, other return error
  post "/events" do
    {status, body} =
      case conn.body_params do
        %{"events" => events} ->
          {200, process_events(events)}

        _ ->
          {422, missing_events()}
      end

    send_resp(conn, status, body)
  end

  defp process_events(events) when is_list(events) do
    Poison.encode!(%{response: "Received Events!"})
  end

  defp process_events(_) do
    Poison.encode!(%{response: "Please send some events!"})
  end

  defp missing_events do
    Poison.encode!(%{error: "Expected Payload: { 'events': [...]"})
  end

  match _ do
    send_resp(conn, 404, "oops... Nothing here!")
  end
end
