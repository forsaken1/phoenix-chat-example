defmodule Example.Message do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @attributes [:text, :user_from_id, :user_to_id]
  @required_attributes [:text, :user_from_id, :user_to_id]
  
  schema "messages" do
    field(:text, :string)
    field(:user_from_id, :integer)
    field(:user_to_id, :integer)

    timestamps()
  end

  def changeset(message, params) do
    message
    |> cast(params, @attributes)
    |> validate_required(@required_attributes)
  end
end
