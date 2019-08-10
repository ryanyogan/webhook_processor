defmodule WebhookProcessor.Application do
  @moduledoc """
  OTP Supervisor for Webhook Processor
  """

  use Application

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: WebhookProcessor.Endpoint,
        options: [port: cowboy_port()]
      )
    ]

    opts = [strategy: :one_for_one, name: WebhookProcessor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp cowboy_port(), do: Application.get_env(:webhook_processor, :port)
end
