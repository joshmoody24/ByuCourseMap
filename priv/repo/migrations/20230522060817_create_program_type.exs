defmodule ByuCourseMap.Repo.Migrations.CreateProgramType do
  use Ecto.Migration

  def change do
    create table(:program_types) do
      add :name, :string

      timestamps()
    end
  end
end
