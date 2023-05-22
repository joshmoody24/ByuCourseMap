defmodule ByuCourseMap.Repo.Migrations.CreateCourses do
  use Ecto.Migration

  def change do
    create table(:courses) do
      add :name, :string
      add :course_code, :string
      add :description, :text
      add :credit_hours, :float
    end

  end
end
