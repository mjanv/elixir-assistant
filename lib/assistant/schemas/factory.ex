defmodule Assistant.Schemas.Factory do
  @moduledoc false

  def list do
    [
      {"projection", Assistant.Projection},
      {"tea", Assistant.Tea},
      {"recipe", Assistant.Recipe}
    ]
  end
end
