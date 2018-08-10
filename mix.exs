defmodule Canasta.MixProject do
  use Mix.Project

  def project do
    [
      app: :canasta,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      source_url: "https://github.com/fredrikaugust/canasta",
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps, do: []
  defp description, do: "This library provides a simple interface to work with/play the card game canasta."
  defp package do
    [
      licenses: ["GPL-3.0"],
      links: %{"Canasta - Wikipedia" => "https://wikipedia.org/wiki/Canasta"}
    ]
  end
end
