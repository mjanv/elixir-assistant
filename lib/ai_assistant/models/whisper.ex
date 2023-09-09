defmodule AiAssistant.Models.Whisper do
  @moduledoc false

  require Logger

  @model "openai/whisper-"
  @sizes ["tiny"]
  @languages ["fr", "en"]

  defp lang("en") do
    [{1, 50259}, {2, 50359}, {3, 50363}]
  end

  defp lang("fr") do
    [{1, 50265}, {2, 50359}, {3, 50363}]
  end

  def build(size, language \\ "fr") do
    model = @model <> size
    Logger.info("[#{__MODULE__}] Building speech-to-text #{model} model.")

    {:ok, whisper} = Bumblebee.load_model({:hf, model})
    {:ok, featurizer} = Bumblebee.load_featurizer({:hf, model})
    {:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, model})
    {:ok, config} = Bumblebee.load_generation_config({:hf, model})
    config = %{config | forced_token_ids: lang(language)}

    Logger.info("[#{__MODULE__}] Speech-to-text #{model} model ready.")

    Bumblebee.Audio.speech_to_text(whisper, featurizer, tokenizer, config,
      defn_options: [compiler: EXLA]
    )
  end

  def predict(serving, path) do
    %{results: [%{text: text}]} = Nx.Serving.run(serving, {:file, path})
    text
  end
end
