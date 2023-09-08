defmodule AiAssistant.Apis.OpenAI do
  @moduledoc false

  def api do
    config = Application.fetch_env!(:ai_assistant, :openai)

    Req.new(
      base_url: config[:api_url],
      headers: [
        {"Authorization", "Bearer " <> config[:api_key]},
        {"OpenAI-Organization", config[:organisation]}
      ]
    )
  end

  def chat(content) do
    api()
    |> Req.post!(
      url: "chat/completions",
      headers: [
        {"Content-Type", "application/json"}
      ],
      json: %{
        "model" => "gpt-3.5-turbo",
        "messages" => [
          %{
            "role" => "system",
            "content" =>
              "You are a kind and helpful assistant. Respond always with one to three sentences."
          },
          %{
            "role" => "user",
            "content" => content
          }
        ]
      }
    )
    |> Map.get(:body)
    |> Map.get("choices")
    |> List.first()
    |> Map.get("message")
    |> Map.get("content")
  end
end
