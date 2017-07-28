class AssessmentController < ApplicationController
  before_action :common_vars
  
  def common_vars
    @teacher = Teacher.find(params[:teacher_id])
  end
  
  def edit
    @students = Student.all
  end
  
  def edit_marks
    @student = Student.find(params[:student_id])
    @grade_subjects = @teacher.grade_subjects
    @subject_ids = @grade_subjects.map { |gs| gs.subject_id }
    @subjects = Subject.select { |s| @subject_ids.include? s.id }
    @exam_types = ExamType.all
  end
  
  def update_marks
    @student = Student.find(params[:student_id])
    subject_id = params[:marks][:subject_id].to_i
    date = params[:marks][:date].to_date
    exam_type_id = params[:marks][:exam_type_id].to_i
    marks_achieved = params[:marks][:marks_achieved].to_f
    max_marks = params[:marks][:max_marks].to_f
    
    record = Mark.find_by student_id: @student.id, subject_id: subject_id, date: date, exam_type_id: exam_type_id
    record ? record.update(marks_achieved: marks_achieved, max_marks: max_marks) : Mark.create(
      student_id: @student.id, subject_id: subject_id, date: date, exam_type_id: exam_type_id, marks_achieved: marks_achieved,
      max_marks: max_marks)
  end
  
  def edit_eca
    @student = Student.find(params[:student_id])
  end
  
  def update_eca
    @student = Student.find(params[:student_id])
    record = params[:eca_record]
    text = record[:text]
    doc_desc = record[:doc_desc]
    uploaded_io = record[:doc_file]
    if uploaded_io
      student_dir = Rails.root.join('private', 'uploaded_docs', 'student_eca', 
        "#{@student.first_name + (@student.last_name ? '_' + @student.last_name : '')}")
      FileUtils.mkdir(student_dir) unless Dir.exists? student_dir
      doc_link = student_dir + uploaded_io.original_filename
      File.open(doc_link, 'wb') do |file|
        file.write(uploaded_io.read)
      end
    end
    
    EcaRecord.create(student_id: @student.id, eca_record: text, doc_link: (doc_link || ''), 
      doc_desc: doc_desc, teacher_id: @teacher.id)
  end
end