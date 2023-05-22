defmodule ByuCourseMap.Department do
  use Ecto.Schema
  import Ecto.Changeset

  schema "departments" do
    field :department_code, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(department, attrs) do
    department
    |> cast(attrs, [:department_code, :name])
    |> validate_required([:department_code, :name])
  end
end
