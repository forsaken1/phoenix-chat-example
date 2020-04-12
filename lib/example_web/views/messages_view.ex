defmodule ExampleWeb.MessagesView do
  use ExampleWeb, :view

  def render("index.json", %{messages: messages}) do
    %{
      messages: Enum.map(messages, &message_json/1)
    }
  end

  def render("show.json", message) do
    %{
      text: message.text
    }
  end

  defp message_json(message) do
    %{
      id: message.id,
      text: message.text,
      inserted_at: message.inserted_at,
      updated_at: message.updated_at
    }
  end
end
