Rails.application.routes.draw do
  get 'student_data/show'

  get 'teachers/show'

  root 'sessions#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get 'static_pages/home'
  resources :teachers
  
  # Individual teacher links
  get '/teachers/:teacher_id/attendance', to: 'attendance#edit'
  post '/teachers/:teacher_id/attendance', to: 'attendance#update'
  get '/teachers/:teacher_id/assessment', to: 'assessment#edit'
  get '/teachers/:teacher_id/assessment/marks/:student_id', to: 'assessment#edit_marks'
  post '/teachers/:teacher_id/assessment/marks/:student_id', to: 'assessment#update_marks' 
  get '/teachers/:teacher_id/assessment/eca/:student_id', to: 'assessment#edit_eca'
  post '/teachers/:teacher_id/assessment/eca/:student_id', to: 'assessment#update_eca'
  get '/teachers/:teacher_id/mentors', to: 'mentors#show'
  get '/teachers/:teacher_id/meetings', to: 'meetings#show'
  get '/teachers/:teacher_id/meetings/edit', to: 'meetings#edit'
  get '/teachers/:teacher_id/meetings/new', to: 'meetings#new' 
  post '/teachers/:teacher_id/meetings/edit', to: 'meetings#update'
  post '/teachers/:teacher_id/meetings/:meeting_id/delete', to: 'meetings#delete'
  get '/teachers/:teacher_id/student_data', to: 'student_data#show'
end
