defmodule ByuCourseMap.Program do
  use Ecto.Schema
  import Ecto.Changeset

  schema "programs" do
    field :name, :string
    # field :department_id, :id
    # field :program_type_id, :id
    belongs_to :program_type, ByuCourseMap.ProgramType
    many_to_many :courses, ByuCourseMap.Course, join_through: "program_courses"
  end

  @doc false
  def changeset(program, attrs) do
    program
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
