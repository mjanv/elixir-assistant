defmodule Assistant.Agents.ChatAssistant do
  @moduledoc false

  use Assistant.Agent

  alias Assistant.Agents.{ChatAssistant2, DynamicSupervisor}

  def handle(state, {:chat, _text}) do
    # prompt = "You are a kind and helpful assistant. Respond always with one to two sentences."
    # response = Assistant.Apis.OpenAI.batch(text, prompt)

    DynamicSupervisor.start(ChatAssistant2)

    {state, [{:reply, "???"}, {:chat, "hello"}]}
  end

  def handle(state, _), do: {state, []}
end

defmodule Assistant.Agents.ChatAssistant2 do
  @moduledoc false

  use Assistant.Agent

  def handle(state, {:chat, text}) do
    # prompt = "You are a kind and helpful assistant. Respond always with one to two sentences."
    # response = Assistant.Apis.OpenAI.batch(text, prompt)
    {state, [{:reply, "#{text}!!!"}]}
  end

  def handle(state, _), do: {state, []}
end
