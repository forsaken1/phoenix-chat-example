# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Example.Repo.insert!(%Example.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Example.Repo.delete_all(Example.Coherence.User)

%Example.Coherence.User{}
|> Example.Coherence.User.changeset(%{
  name: "Test User",
  email: "alexey2142@mail.ru",
  password: "12345678",
  password_confirmation: "12345678"
})
|> Example.Repo.insert!()
