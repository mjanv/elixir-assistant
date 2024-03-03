defmodule Assistant.Models.IntentClassificationTest do
  @moduledoc false

  use ExUnit.Case

  alias Assistant.Models.IntentClassification

  @tag :bumblebee
  test "Text intent can be classified" do
    assert IntentClassification.predict(:sentiment, "Bonjour !") == :positive
    assert IntentClassification.predict(:sentiment, "Nul !") == :negative
  end
end
