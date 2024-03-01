defmodule Assistant.Apis.ElevenLabs do
  @moduledoc false

  def get(url) do
    :assistant
    |> Application.fetch_env!(:eleven_labs)
    |> then(fn config ->
      Req.new(
        base_url: config[:api_url],
        headers: [{"xi-api-key", config[:api_key]}]
      )
    end)
    |> Req.get(
      url: url,
      headers: [{"accept", "application/json"}]
    )
  end

  def models, do: get("models")
  def voices, do: get("voices")

  def post({config, url, json}) do
    Req.new(
      base_url: config[:api_url],
      headers: [{"xi-api-key", config[:api_key]}]
    )
    |> Req.post(
      url: url,
      headers: [
        {"Content-Type", "application/json"},
        {"accept", "audio/mpeg"}
      ],
      json: json
    )
  end

  def generate(text) do
    :assistant
    |> Application.fetch_env!(:eleven_labs)
    |> then(fn config ->
      url = "text-to-speech/#{config[:voice_id]}"

      json = %{
        "text" => text,
        "model_id" => config[:model_id],
        "voice_settings" => %{"stability" => 0.5, "similarity_boost" => 0.5}
      }

      {config, url, json}
    end)
    |> post()
    |> case do
      {:ok, %Req.Response{status: 200, body: body}} -> {:ok, body}
      {:ok, %Req.Response{} = response} -> {:error, response}
      {:error, error} -> {:error, error}
    end
  end
end
