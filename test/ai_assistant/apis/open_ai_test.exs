defmodule Assistant.Apis.OpenAiTest do
  @moduledoc false

  use ExUnit.Case

  alias Assistant.Apis.OpenAI

  setup do
    prompt = "You are a kind and helpful assistant. Respond always with one to two sentences."
    {:ok, %{prompt: prompt}}
  end

  @tag :openai
  test "Batch", %{prompt: prompt} do
    text = "Nommes trois plantes."
    response = OpenAI.batch(text, prompt)

    assert response == "?"
  end

  @tag :openai
  test "Stream", %{prompt: prompt} do
    text = "Nommes trois plantes."
    response = OpenAI.stream(text, prompt)

    assert response == "?"
  end
end
