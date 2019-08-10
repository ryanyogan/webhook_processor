defmodule WebhookProcessor.MixProject do
  use Mix.Project

  def project do
    [
      app: :webhook_processor,
      version: "0.1.0",
      elixir: "~> 1.10-dev",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :plug_cowboy],
      mod: {WebhookProcessor.Application, []}
    ]
  end

  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 3.1"}
    ]
  end
end
