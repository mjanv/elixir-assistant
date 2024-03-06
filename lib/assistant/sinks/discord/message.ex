defmodule Assistant.Sinks.Discord.Message do
  @moduledoc false

  @colors [
    blue: "03B2F8"
  ]

  @doc """
  Render a simple Discord message from text
  """
  @spec content(String.t()) :: Keyword.t()
  def content(content), do: [content: content]

  @doc """
  Render a Discord description from a Markdown template.
  """
  @spec markdown(Keyword.t(), String.t()) :: String.t()
  def markdown(assigns, template) do
    template
    |> Path.expand(Path.join(:code.priv_dir(:assistant), "templates"))
    |> EEx.eval_file(assigns: assigns, trim: true)
    |> String.replace("\n\n", "\n")
  end

  @doc """
  Build an embed Discord message from description and title.

  The color is used as the sidebar color of the embed.
  """
  @spec embed(String.t(), String.t()) :: Keyword.t()
  def embed(description, title) do
    [
      embeds: [
        %Nostrum.Struct.Embed{
          title: title,
          description: description,
          timestamp: Timex.format!(Timex.now(), "{ISO:Extended}"),
          color: @colors[:blue] |> Base.decode16!() |> :binary.decode_unsigned()
        }
      ]
    ]
  end
end
