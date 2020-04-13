defmodule Chat do
  def id(first_id, second_id) do
    ids = [first_id, second_id]
    sorted_ids = Enum.sort(ids)
    "chat-" <> (sorted_ids |> Enum.at(0) |> Integer.to_string) <> "-" <> (sorted_ids |> Enum.at(1) |> Integer.to_string)
  end
end
