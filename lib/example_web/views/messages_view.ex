defmodule ExampleWeb.MessagesView do
  use ExampleWeb, :view

  def render("index.json", %{messages: messages}) do
    %{
      messages: Enum.map(messages, &message_json/1)
    }
  end

  def render("show.json", message) do
    message_json(message)
  end

  def message_json(message) do
    %{
      id: message.id,
      text: message.text,
      user_from_id: message.user_from_id,
      user_to_id: message.user_to_id,
      inserted_at: message.inserted_at,
      updated_at: message.updated_at
    }
  end
end
