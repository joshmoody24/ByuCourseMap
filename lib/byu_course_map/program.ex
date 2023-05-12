defmodule ByuCourseMap.Program do
  use Ecto.Schema
  import Ecto.Changeset

  schema "programs" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(program, attrs) do
    program
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
