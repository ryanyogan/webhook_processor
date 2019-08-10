defmodule WebhookProcessor.Application do
  @moduledoc """
  OTP Supervisor for Webhook Processor
  """

  use Application

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        schema: :http,
        plug: WebhookProcessor.Endpoint,
        options: [port: Application.get_env(:webhook_processor, :port)]
      )
    ]

    opts = [strategy: :one_for_one, name: WebhookProcessor.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
