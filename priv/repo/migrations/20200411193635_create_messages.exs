defmodule Example.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :text, :string
      add :user_from_id, :integer
      add :user_to_id, :integer

      timestamps()
    end
  end
end
