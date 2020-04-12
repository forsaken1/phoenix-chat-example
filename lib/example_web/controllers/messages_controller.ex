defmodule ExampleWeb.MessagesController do
  import Ecto.Query, only: [from: 2]
  use ExampleWeb, :controller
  alias Example.Repo
  alias Example.Message
  require IEx

  def index(conn, params) do
    messages = messages_query(conn, params)
    render conn, "index.json", messages: messages
  end

  def create(conn, params) do
    changeset = Message.changeset(%Message{}, message_params(conn, params))

    case Repo.insert(changeset) do
      {:ok, message} ->
        render conn, "show.json", message
      {:error, changeset} ->
        json(conn, changeset)
    end
  end

  defp message_params(conn, params) do
    current_user = conn.assigns[:current_user]
    %{
      text: params["text"],
      user_to_id: params["user_id"],
      user_from_id: current_user.id
    }
  end

  defp messages_query(conn, params) do
    user_id = params["user_id"]
    current_user = conn.assigns[:current_user]
    Repo.all(from m in Message,
      where: m.user_from_id == ^user_id and m.user_to_id == ^current_user.id or 
             m.user_from_id == ^current_user.id and m.user_to_id == ^user_id)
  end
end
