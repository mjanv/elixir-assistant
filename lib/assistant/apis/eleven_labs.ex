defmodule Assistant.Apis.ElevenLabs do
  @moduledoc false

  def api do
    config = Application.fetch_env!(:assistant, :eleven_labs)

    Req.new(
      base_url: config[:api_url],
      headers: [{"xi-api-key", config[:api_key]}]
    )
  end

  def voice do
    Application.fetch_env!(:assistant, :eleven_labs)[:voice_id]
  end

  def models do
    api()
    |> Req.get!(
      url: "models",
      headers: [{"accept", "application/json"}]
    )
  end

  def voices do
    api()
    |> Req.get!(
      url: "voices",
      headers: [{"accept", "application/json"}]
    )
  end

  def generate(text) do
    api()
    |> Req.post!(
      url: "text-to-speech/#{voice()}",
      headers: [
        {"Content-Type", "application/json"},
        {"accept", "audio/mpeg"}
      ],
      json: %{
        "text" => text,
        "model_id" => "eleven_monolingual_v1",
        "voice_settings" => %{
          "stability" => 0.5,
          "similarity_boost" => 0.5
        }
      }
    )
    |> Map.get(:body)
  end
end
