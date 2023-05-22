defmodule ByuCourseMapWeb.PageController do
  use ByuCourseMapWeb, :controller
  alias ByuCourseMap.Repo
  alias ByuCourseMap.Course
  alias ByuCourseMap.Program
  alias ByuCourseMap.ProgramType


  def home(conn, _params) do
    render(conn, :home)
  end

  def about(conn, _params) do
    render(conn, :about, courses: Repo.all(Course), programs: Repo.all(Program), program_types: Repo.all(ProgramType))
  end
end
