defmodule ExampleWeb.UsersController do
  import Ecto.Query, only: [from: 2]
  use ExampleWeb, :controller
  alias Example.Repo
  alias Example.Coherence.User

  def index(conn, _params) do
    current_user = conn.assigns[:current_user]
    users = Repo.all(from u in User, where: u.id != ^current_user.id)
    render conn, "index.json", users: users
  end
end
