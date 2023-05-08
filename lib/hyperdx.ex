defmodule Hyperdx do
  def send(messages) do
    json_lines = messages
      |> Enum.map(fn message ->
        %{message | __hdx_sv: config(:service)}
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
    "#{config(:base_url)}?hdx_platform=elixir"
  end

  def default_headers do
    [
      {"content-type", "application/json"},
      {"user-agent", "elixir-client/v#{Application.spec(:hyperdx, :vsn)}"},
      {"Authorization", "Bearer #{config(:token)}"}
    ]
  end

  defp config(:token) do
    configs = Application.get_env(:logger, :hyperdx)
    Keyword.fetch!(configs, :token)
  end

  defp config(:service) do
    configs = Application.get_env(:logger, :hyperdx)
    Keyword.fetch!(configs, :service)
  end

  defp config(:base_url) do
    configs = Application.get_env(:logger, :hyperdx)
    Keyword.fetch!(configs, :base_url)
  end
end
