defmodule ExampleWeb.UsersController do
  use ExampleWeb, :controller
  alias Example.Repo
  alias Example.Coherence.User

  def index(conn, _params) do
    users = Repo.all(User)
    render conn, "index.json", users: users
  end
end
