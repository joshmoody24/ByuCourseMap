defmodule ByuCourseMap.Course do
  use Ecto.Schema
  import Ecto.Changeset

  schema "courses" do
    field :credit_hours, :integer
    field :name, :string
    field :subject_code, :string

    timestamps()
  end

  @doc false
  def changeset(course, attrs) do
    course
    |> cast(attrs, [:name, :subject_code, :credit_hours])
    |> validate_required([:name, :subject_code, :credit_hours])
  end
end
