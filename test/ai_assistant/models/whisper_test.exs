defmodule Assistant.Models.WhisperTest do
  @moduledoc false

  use ExUnit.Case

  alias Assistant.Models.Whisper

  @tag :bumblebee
  test "Whisper speech-to-text models can be used to predict" do
    text = Whisper.predict(:fr, {:file, "30e7edbf45.mp3"})

    assert text == " Bonjour, comment allez-vous ?"
  end
end
