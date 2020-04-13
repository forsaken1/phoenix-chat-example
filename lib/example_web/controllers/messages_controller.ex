defmodule ExampleWeb.MessagesController do
  import Ecto.Query, only: [from: 2]
  use ExampleWeb, :controller
  alias Example.Repo
  alias Example.Message
  alias ExampleWeb.MessagesView

  def index(conn, params) do
    messages = messages_query(conn, params)
    render conn, "index.json", messages: messages
  end

  def create(conn, params) do
    changeset = Message.changeset(%Message{}, message_params(conn, params))

    case Repo.insert(changeset) do
      {:ok, message} ->
        ExampleWeb.Endpoint.broadcast Chat.id(current_user(conn).id, params["user_id"]), "new_message", MessagesView.message_json(message)
        render conn, "show.json", message
      {:error, changeset} ->
        json conn, changeset
    end
  end

  defp message_params(conn, params) do
    %{
      text: params["text"],
      user_to_id: params["user_id"],
      user_from_id: current_user(conn).id
    }
  end

  defp messages_query(conn, %{"user_id" => user_id}) do
    Repo.all(from m in Message,
      where: m.user_from_id == ^user_id and m.user_to_id == ^current_user(conn).id or 
             m.user_from_id == ^current_user(conn).id and m.user_to_id == ^user_id)
  end

  defp current_user(conn) do
    conn.assigns[:current_user]
  end
end
