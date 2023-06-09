defmodule ByuCourseMap.Course do
  use Ecto.Schema
  import Ecto.Changeset

  schema "courses" do
    field :course_code, :string
    field :credit_hours, :float
    field :description, :string
    field :name, :string
    many_to_many :programs, ByuCourseMap.Program, join_through: "program_courses"
  end

  @doc false
  def changeset(course, attrs) do
    course
    |> cast(attrs, [:name, :course_code, :description, :credit_hours])
    |> validate_required([:name, :course_code, :description, :credit_hours])
  end
end
