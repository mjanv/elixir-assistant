defmodule Assistant.Models.Picovoice do
  @moduledoc false

  use Rustler, otp_app: :assistant, crate: "picovoice"

  def detect(_access_key, _keyword_path, _model_path), do: :erlang.nif_error(:nif_not_loaded)

  def register(_access_key, _keyword_path, _model_path), do: :erlang.nif_error(:nif_not_loaded)

  def query(_access_key, _keyword_path, _model_path), do: :erlang.nif_error(:nif_not_loaded)
end
