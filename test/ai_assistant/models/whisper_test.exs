defmodule Assistant.Models.WhisperTest do
  @moduledoc false

  use ExUnit.Case

  alias Assistant.Models.Whisper

  @tag timeout: :infinity
  test "Whisper speech-to-text models can be built" do
    %Nx.Serving{} = Whisper.build("tiny")
  end
end
