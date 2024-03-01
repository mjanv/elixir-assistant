defmodule Assistant.Models.SpeechToText do
  @moduledoc false

  use Supervisor

  alias Nx.Serving

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    children = [
      {Serving, model({:tiny, :fr})},
      {Serving, model({:tiny, :en})}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def model({size, language}) do
    with model <- "openai/whisper-" <> Atom.to_string(size),
         {:ok, whisper} <- Bumblebee.load_model({:hf, model}),
         {:ok, featurizer} <- Bumblebee.load_featurizer({:hf, model}),
         {:ok, tokenizer} <- Bumblebee.load_tokenizer({:hf, model}),
         {:ok, config} <- Bumblebee.load_generation_config({:hf, model}),
         %Serving{} = serving <-
           Bumblebee.Audio.speech_to_text_whisper(
             whisper,
             featurizer,
             tokenizer,
             config,
             language: Atom.to_string(language)
           ) do
      [serving: serving, name: language, batch_size: 1, batch_timeout: 100]
    end
  end

  def predict(model, input) do
    model
    |> Serving.batched_run(input)
    |> case do
      %{chunks: [%{text: text}]} -> text
    end
  end
end
