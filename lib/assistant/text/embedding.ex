defmodule Assistant.Text.Embedding do
  @moduledoc false

  @model "nomic-ai/nomic-embed-text-v1"
  # Nx.global_default_backend({EXLA.Backend, client: :host})

  def serving do
    with {:ok, model_info} <-
           Bumblebee.load_model({:hf, @model}, architecture: :base, module: Bumblebee.Text.Bert),
         {:ok, tokenizer} <-
           Bumblebee.load_tokenizer({:hf, @model}, module: Bumblebee.Text.BertTokenizer),
         %Nx.Serving{} = serving <- Bumblebee.Text.text_embedding(model_info, tokenizer) do
      serving
    else
      {:error, _reason} -> :error
    end
  end

  def embed_text(%Nx.Serving{} = serving, text) do
    Nx.Serving.run(serving, text)
  end
end
