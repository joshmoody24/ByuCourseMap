defmodule ByuCourseMap.Repo.Migrations.CreateProgramTypes do
  use Ecto.Migration

  def change do
    create table(:program_types) do
      add :name, :string
      add :abbreviation, :string
    end
  end
end
