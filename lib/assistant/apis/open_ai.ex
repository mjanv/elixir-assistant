defmodule Assistant.Apis.OpenAI do
  @moduledoc false

  def api do
    config = Application.fetch_env!(:assistant, :openai)

    Req.new(
      base_url: config[:api_url],
      headers: [
        {"Authorization", "Bearer " <> config[:api_key]},
        {"OpenAI-Organization", config[:organisation]}
      ]
    )
  end

  def batch(content, prompt) do
    api()
    |> Req.post!(
      url: "chat/completions",
      headers: [
        {"Content-Type", "application/json"}
      ],
      json: %{
        "model" => "gpt-3.5-turbo",
        "messages" => [
          %{"role" => "system", "content" => prompt},
          %{"role" => "user", "content" => content}
        ]
      }
    )
    |> Map.get(:body)
    |> Map.get("choices")
    |> List.first()
    |> Map.get("message")
    |> Map.get("content")
  end

  def stream(content, prompt) do
    api()
    |> Req.post!(
      url: "chat/completions",
      headers: [
        {"Content-Type", "application/json"}
      ],
      json: %{
        "model" => "gpt-3.5-turbo",
        "messages" => [
          %{"role" => "system", "content" => prompt},
          %{"role" => "user", "content" => content}
        ],
        "stream" => true
      },
      finch_request: fn request, finch_request, finch_name, finch_options ->
        fun = fn
          {:status, status}, response ->
            %{response | status: status}

          {:headers, headers}, response ->
            %{response | headers: headers}

          {:data, data}, response ->
            body =
              data
              |> String.split("data: ")
              |> Enum.map(fn str -> str |> String.trim() |> decode_body() end)
              |> Enum.filter(fn d -> d != :ok end)

            old_body = if response.body == "", do: [], else: response.body

            %{response | body: old_body ++ body}
        end

        case Finch.stream(finch_request, finch_name, Req.Response.new(), fun, finch_options) do
          {:ok, response} -> {request, response}
          {:error, exception} -> {request, exception}
        end
      end
    )
    |> Map.get(:body)
    |> Enum.join("")
  end

  defp decode_body(""), do: :ok
  defp decode_body("[DONE]"), do: :ok

  defp decode_body(json) do
    json
    |> Jason.decode!()
    |> Map.get("choices")
    |> List.first()
    |> Map.get("delta")
    |> Map.get("content")
  end
end
