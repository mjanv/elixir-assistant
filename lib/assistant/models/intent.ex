defmodule Assistant.Models.IntentClassification do
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
    with model <- "facebook/bart-large-mnli",
         {:ok, bart} <- Bumblebee.load_model({:hf, model}),
         {:ok, tokenizer} <- Bumblebee.load_tokenizer({:hf, model}),
         %Serving{} = serving <-
           Bumblebee.Text.zero_shot_classification(model, tokenizer, ["positive", "negative"]) do
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
