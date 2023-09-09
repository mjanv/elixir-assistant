defmodule AiAssistant.Agents.TwitchChat do
  @moduledoc false

  use WebSockex

  require Logger

  def start_link(state) do
    config = Application.fetch_env!(:ai_assistant, :twitch)
    WebSockex.start_link(config[:chat_ws], __MODULE__, state, name: __MODULE__)
  end

  def handle_connect(_conn, state) do
    config = Application.fetch_env!(:ai_assistant, :twitch)

    Task.async(fn ->
      request = "CAP REQ :twitch.tv/membership twitch.tv/tags twitch.tv/commands"
      WebSockex.send_frame(__MODULE__, {:text, request})
      WebSockex.send_frame(__MODULE__, {:text, "PASS oauth:#{config[:oauth_token]}"})
      WebSockex.send_frame(__MODULE__, {:text, "NICK #{config[:channel]}"})
      WebSockex.send_frame(__MODULE__, {:text, "JOIN ##{config[:channel]}"})
    end)

    {:ok, state}
  end

  def handle_frame({:text, msg}, state) do
    Logger.info(msg)

    if msg =~ "PRIVMSG" do
      text = msg
        |> String.split("PRIVMSG")
        |> List.last()
        |> String.split(":")
        |> List.last()
        |> String.replace("\r", "")
        |> String.replace("\n", "")
        |> IO.inspect()

      :ok = GenServer.cast(AiAssistant.Agents.ChatAssistant, {:chat, text})
    end

    {:ok, state}
  end

  def handle_cast({:send, {type, msg} = frame}, state) do
    IO.puts("Sending #{type} frame with payload: #{msg}")
    {:reply, frame, state}
  end
end
