defmodule ByuCourseMap.Repo.Migrations.CreatePrograms do
  use Ecto.Migration

  def change do
    create table(:programs) do
      add :name, :string
      add :department_id, references(:departments, on_delete: :nothing)
      add :program_type_id, references(:program_types, on_delete: :nothing)

      timestamps()
    end

    create index(:programs, [:department_id])
    create index(:programs, [:program_type_id])
  end
end
