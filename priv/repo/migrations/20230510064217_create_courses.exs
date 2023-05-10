defmodule ByuCourseMap.Repo.Migrations.CreateCourses do
  use Ecto.Migration

  def change do
    create table(:courses) do
      add :name, :string
      add :subject_code, :string
      add :credit_hours, :integer

      timestamps()
    end
  end
end
