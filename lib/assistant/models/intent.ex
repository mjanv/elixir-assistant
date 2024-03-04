defmodule Assistant.Models.IntentClassification do
  @moduledoc false

  use Supervisor

  alias Nx.Serving

  @model "facebook/bart-large-mnli"

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    children = [
      {Serving, model(:sentiment, ["positive", "negative"])}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def model(name, tags) do
    with {:ok, model} <- Bumblebee.load_model({:hf, @model}),
         {:ok, tokenizer} <- Bumblebee.load_tokenizer({:hf, @model}),
         %Serving{} = serving <-
           Bumblebee.Text.zero_shot_classification(model, tokenizer, tags) do
      [serving: serving, name: name, batch_size: 1, batch_timeout: 100]
    end
  end

  def predict(name, input, threshold \\ 0.8) do
    name
    |> Serving.batched_run(input)
    |> case do
      %{predictions: [%{label: label, score: score} | _]} when score > threshold ->
        String.to_atom(label)

      %{predictions: _} ->
        nil
    end
  end
end
