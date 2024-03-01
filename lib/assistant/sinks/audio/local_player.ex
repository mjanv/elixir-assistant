defmodule Assistant.Sinks.Audio.LocalPlayer do
  @moduledoc false

  use Membrane.Pipeline

  @format %Membrane.RawAudio{sample_format: :s16le, sample_rate: 48_000, channels: 2}

  def start_link(args) do
    Membrane.Pipeline.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def handle_init(_ctx, {format, path}) do
    :file
    |> child(%Membrane.File.Source{location: path})
    |> then(fn spec ->
      case format do
        :mp3 -> child(spec, :decoder, Membrane.MP3.MAD.Decoder)
        :wav -> child(spec, :parser, Membrane.WAV.Parser)
      end
    end)
    |> child(:converter, %Membrane.FFmpeg.SWResample.Converter{output_stream_format: @format})
    |> child(:portaudio, Membrane.PortAudio.Sink)
    |> then(fn spec -> {[spec: spec], %{}} end)
  end

  def play(path) do
    send(__MODULE__, {:mp3, path})
  end
end
