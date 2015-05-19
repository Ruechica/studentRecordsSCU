require 'dm-core'
require 'dm-migrations'

class Student
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :age, Integer
  property :sex, String
end

configure do
  enable :sessions
  set :username, 'frank'
  set :password, 'sinatra'
end

DataMapper.finalize

get '/students' do
  @students = Student.all
  slim :students
end

get '/students/new' do
  halt(401,'Not Authorized') unless session[:admin]
  @student = Student.new
  slim :new_student
end

get '/students/:id' do
  @student = Student.get(params[:id])
  slim :show_student
end

get '/students/:id/edit' do
  @student = Student.get(params[:id])
  slim :edit_student
end

post '/students' do  
  student = Student.create(params[:student])
  redirect to("/students/#{student.id}")
end

put '/students/:id' do
  student = Student.get(params[:id])
  student.update(params[:student])
  redirect to("/students/#{student.id}")
end

delete '/students/:id' do
  Student.get(params[:id]).destroy
  redirect to('/students')
end


