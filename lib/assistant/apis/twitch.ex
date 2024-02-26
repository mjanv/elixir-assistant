defmodule Assistant.Apis.Twitch do
  @moduledoc false

  def get_app_access_token!(client_id, client_secret) do
    config = Application.fetch_env!(:assistant, :twitch)

    Req.new(
      url: config[:auth_url],
      headers: [
        {"Content-Type", "application/x-www-form-urlencoded"}
      ],
      params: [
        {"grant_type", "client_credentials"},
        {"client_id", client_id},
        {"client_secret", client_secret}
      ]
    )
    |> Req.post!()
  end

  def user(client_id, token, login) do
    config = Application.fetch_env!(:assistant, :twitch)

    Req.new(
      base_url: config[:api_url],
      url: "/users",
      headers: [
        {"Authorization", "Bearer " <> token},
        {"Client-Id", client_id}
      ],
      params: [
        {"login", login}
      ]
    )
    |> Req.get!()
  end
end
