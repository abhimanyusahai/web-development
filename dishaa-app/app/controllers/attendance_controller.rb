class AttendanceController < ApplicationController
  def edit
    @teacher = Teacher.find(params[:teacher_id])
    @grade_subjects = @teacher.grade_subjects
    @grade_ids = @grade_subjects.map { |gs| gs.grade_id }
    @grades = Grade.select { |g| @grade_ids.include? g.id }
    @subject_ids = @grade_subjects.map { |gs| gs.subject_id }
    @subjects = Subject.select { |s| @subject_ids.include? s.id }
    @students = Student.all
  end
  
  def update
    @teacher = Teacher.find(params[:teacher_id])
    grade_id = params[:attendance][:grade_id].to_i
    subject_id = params[:attendance][:subject_id].to_i
    date = params[:attendance][:date].to_date
    @students = Student.all # Need to figure out a way of only selecting students
    
    @students.each do |s|
      student_id = s.id
      record = Attendance.find_by student_id: student_id, subject_id: subject_id, date: date
      case params[:attendance][student_id.to_s]
      when "present"
        record ? record.update(present: true, absent: false, on_leave: false) : Attendance.create(
          student_id: student_id, grade_id: grade_id, subject_id: subject_id, date: date,
          present: true, absent: false, on_leave: false)
      when "absent"
        record ? record.update(present: false, absent: true, on_leave: false) : Attendance.create(
          student_id: student_id, grade_id: grade_id, subject_id: subject_id, date: date,
          present: false, absent: true, on_leave: false)
      when "on_leave"
        record ? record.update(present: false, absent: false, on_leave: true) : Attendance.create(
          student_id: student_id, grade_id: grade_id, subject_id: subject_id, date: date,
          present: false, absent: false, on_leave: true)
      else
      end
    end
  end
  
end
