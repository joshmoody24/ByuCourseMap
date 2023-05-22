defmodule ByuCourseMap.Repo.Migrations.CreatePrograms do
  use Ecto.Migration

  def change do
    create table(:programs) do
      add :name, :string
      add :program_type_id, references(:program_types, on_delete: :nothing)
    end

    create index(:programs, [:program_type_id])
  end
end
