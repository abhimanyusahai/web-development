class StudentDataController < ApplicationController
  def show
    @teacher = Teacher.find(params[:teacher_id])
    @students = Student.all
  end
end
