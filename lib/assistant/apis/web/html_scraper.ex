defmodule Assistant.Apis.Web.HtmlScraper do
  @moduledoc false

  def extract_text(url) do
    with %URI{path: path} = uri <- URI.parse(url),
         :ok <- Application.put_env(:wallaby, :base_url, base_url(uri)),
         {:ok, session} <- Wallaby.start_session(),
         session <- Wallaby.Browser.visit(session, path),
         text <- Wallaby.Browser.text(session),
         :ok <- Wallaby.end_session(session) do
      {:ok, text}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp base_url(%URI{} = uri) do
    uri
    |> Map.put(:path, nil)
    |> URI.to_string()
  end
end
