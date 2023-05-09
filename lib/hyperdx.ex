defmodule Hyperdx do
  def send(messages) do
    json_lines = messages
      |> Enum.map(fn message ->
        decoded = Jason.decode!(message)
        updated = Map.put(decoded, :__hdx_sv, config(:service))
        Jason.encode!(updated)
      end)
      |> Enum.join("\n")

    case HTTPoison.post(url(), json_lines, default_headers()) do
      {:ok, %HTTPoison.Response{status_code: code, body: body}} ->
        unless code in 200..299 do
          IO.warn(
            "Hyperdx API warning: Dropping Logs: HTTP response status is #{code}. Response body is: #{inspect(body)}"
          )
        end

      {:error, reason} ->
        IO.warn(
          "Hyperdx API warning: Dropping Logs: HTTP request failed due to: #{inspect(reason)}"
        )
    end
  end

  def url() do
    base_url = System.get_env("HYPERDX_BASE_URL") || "https://in.hyperdx.io/"
    "#{base_url}?hdx_platform=elixir"
  end

  def default_headers do
    [
      {"content-type", "application/json"},
      {"user-agent", "elixir-client/v#{Application.spec(:hyperdx, :vsn)}"},
      {"Authorization", "Bearer #{config(:token)}"}
    ]
  end

  def config(:token) do
    System.get_env("HYPERDX_API_KEY")
  end

  def config(:service) do
    System.get_env("OTEL_SERVICE_NAME")
  end
end
