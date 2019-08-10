defmodule WebhookProcessor.Endpoint do
  @moduledoc """
  A plug that is responsible for logging request infor, parsing request body as
  JASON, matching routes, and dispatching responses.
  """

  # alias WebhookProcessor.VerifyRequest

  use Plug.Router
  use Plug.ErrorHandler

  # Plug pipeline: log -> match -> decode JSON -> dispatch
  plug(Plug.Logger)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)

  # plug(VerifyRequest, fields: ["content-type"], paths: ["/ping"])

  plug(:match)
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

  match _ do
    send_resp(conn, 404, "oops... Nothing here!")
  end

  defp process_events(events) when is_list(events) do
    IO.inspect(events)
    Poison.encode!(%{response: "Received Events!"})
  end

  defp process_events(_) do
    Poison.encode!(%{response: "Please send some events!"})
  end

  defp missing_events do
    Poison.encode!(%{error: "Expected Payload: { 'events': [...]"})
  end

  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    IO.inspect(kind, label: :kind)
    IO.inspect(reason, label: :reason)
    IO.inspect(stack, label: :stack)
    send_resp(conn, conn.status, "Something went wrong")
  end
end
