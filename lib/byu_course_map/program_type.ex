defmodule ByuCourseMap.ProgramType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "program_types" do
    field :name, :string
    field :abbreviation, :string
    has_many :programs, ByuCourseMap.Program

    timestamps()
  end

  @doc false
  def changeset(program_type, attrs) do
    program_type
    |> cast(attrs, [:name, :abbreviation])
    |> validate_required([:name, :abbrevation])
  end
end
