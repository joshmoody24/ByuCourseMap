defmodule ByuCourseMap.Repo.Migrations.CreateDepartments do
  use Ecto.Migration

  def change do
    create table(:departments) do
      add :department_code, :string
      add :name, :string

      timestamps()
    end
  end
end
