defmodule Assistant.Models.Audio.WakeWord do
  @moduledoc false

  use Rustler, otp_app: :assistant, crate: "picovoice"

  def query(_access_key, _keyword_path, _model_path), do: :erlang.nif_error(:nif_not_loaded)
end
