defmodule AiAssistant.Models.Whisper do
  @moduledoc false

  require Logger

  @model "openai/whisper-"
  @sizes ["tiny"]

  def build(size) when size in @sizes do
    model = @model <> size
    Logger.info("[#{__MODULE__}] Building speech-to-text #{model} model.")

    {:ok, whisper} = Bumblebee.load_model({:hf, model})
    {:ok, featurizer} = Bumblebee.load_featurizer({:hf, model})
    {:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, model})
    {:ok, config} = Bumblebee.load_generation_config({:hf, model})

    Bumblebee.Audio.speech_to_text(whisper, featurizer, tokenizer, config,
      defn_options: [compiler: EXLA]
    )
  end

  def predict(serving, path) do
    %{results: [%{text: text}]} = Nx.Serving.run(serving, {:file, path})
    text
  end
end
