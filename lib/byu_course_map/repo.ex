defmodule ByuCourseMap.Repo do
  use Ecto.Repo,
    otp_app: :byu_course_map,
    adapter: Ecto.Adapters.MyXQL
end
