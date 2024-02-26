defmodule Assistant.Models.Chat do
  @moduledoc false

  def response(response_model, content) do
    Instructor.chat_completion(
      mode: :json,
      stream: false,
      model: "gpt-3.5-turbo",
      response_model: response_model,
      messages: [%{role: "user", content: content}]
    )
  end
end
