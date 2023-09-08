defmodule AiAssistant.Audio.WavPlayer do
  @moduledoc false

  use Membrane.Pipeline

  @impl true
  def handle_init(_ctx, path) do
    spec =
      child(:file, %Membrane.File.Source{location: path})
      |> child(:parser, Membrane.WAV.Parser)
      |> child(:converter, %Membrane.FFmpeg.SWResample.Converter{
        output_stream_format: %Membrane.RawAudio{
          sample_format: :s16le,
          sample_rate: 48_000,
          channels: 2
        }
      })
      |> child(:portaudio, Membrane.PortAudio.Sink)

    {[spec: spec], %{}}
  end

  def play(path) do
    {:ok, _, _} = __MODULE__.start_link(path)
  end
end
