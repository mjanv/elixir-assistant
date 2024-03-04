defmodule Assistant.Models.Text.Embedding do
  @moduledoc false

  use Supervisor

  alias Nx.Serving

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    children = [
      {Serving, serving(:nomic, "nomic-ai/nomic-embed-text-v1")}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def serving(name, model) do
    with {:ok, model_info} <-
           Bumblebee.load_model({:hf, model}, architecture: :base, module: Bumblebee.Text.Bert),
         {:ok, tokenizer} <-
           Bumblebee.load_tokenizer({:hf, model}, type: :bert),
         %Nx.Serving{} = serving <- Bumblebee.Text.text_embedding(model_info, tokenizer) do
      [serving: serving, name: name, batch_size: 1, batch_timeout: 100]
    else
      {:error, _reason} -> nil
    end
  end

  def embed(name, input) do
    name
    |> Serving.batched_run(input)
    |> case do
      %{embedding: embedding} -> embedding
    end
  end
end
