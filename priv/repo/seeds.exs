# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ByuCourseMap.Repo.insert!(%ByuCourseMap.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ByuCourseMap.Repo
alias ByuCourseMap.ProgramType

Repo.delete_all(ProgramType)
program_types = [
  %{ name: "Bachelor of Science", abbreviation: "BS" },
  %{ name: "Bachelor of Arts", abbreviation: "BA" },
  %{ name: "Bachelor of Fine Arts", abbreviation: "BFA" },
  %{ name: "Minor", abbreviation: "Minor" },
]
Repo.insert_all(program_types)
