defmodule ExampleWeb.ChatChannel do
  use Phoenix.Channel

  def join("chat-" <> _chat_id, _message, socket) do
    {:ok, socket}
  end
end
