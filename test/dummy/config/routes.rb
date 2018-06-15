Rails.application.routes.draw do
  mount AcademicBenchmarksApi::Engine => "/academic_benchmarks_api"
end
