defmodule AiAssistant.Apis.OpenAiTest do
  @moduledoc false

  use ExUnit.Case

  alias AiAssistant.Apis.OpenAI

  @tag :skip
  test "Batch" do
    text = "Nommes trois plantes."
    prompt = "You are a kind and helpful assistant. Respond always with one to two sentences."
    response = OpenAI.batch(text, prompt)

    assert response == "?"
  end

  @tag :skip
  test "Stream" do
    text = "Nommes trois plantes."
    prompt = "You are a kind and helpful assistant. Respond always with one to two sentences."
    response = OpenAI.stream(text, prompt)

    assert response == "?"
  end
end
