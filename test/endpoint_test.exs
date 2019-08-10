defmodule WebhookProcessor.EndpointTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias WebhookProcessor.Endpoint

  @opts Endpoint.init([])

  test "it returns pong" do
    conn =
      :get
      |> conn("/ping")
      |> Endpoint.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Pong!"
  end

  test "it returns 200 with a valid payload" do
    conn =
      :post
      |> conn("/events", %{events: [%{}]})
      |> Endpoint.call(@opts)

    assert conn.status == 200
  end

  test "it returns 422 with an invalid payload" do
    conn =
      :post
      |> conn("/events", %{})
      |> Endpoint.call(@opts)

    assert conn.status == 422
  end

  test "it returns 404 when no route matchs" do
    conn =
      :get
      |> conn("/failure")
      |> Endpoint.call(@opts)

    assert conn.status == 404
  end
end
