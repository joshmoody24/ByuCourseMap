defmodule ByuCourseMap.ProgramType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "program_types" do
    field :name, :string
    has_many :programs, ByuCourseMap.Program

    timestamps()
  end

  @doc false
  def changeset(program_type, attrs) do
    program_type
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
