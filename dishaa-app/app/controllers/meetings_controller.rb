class MeetingsController < ApplicationController
  def common_vars
    @teacher = Teacher.find(params[:teacher_id])
    query = %q(
              SELECT id
              FROM meetings
              WHERE date > DATE('now'))
    meeting_ids = execute_sql(query)
    meeting_ids = meeting_ids.map { |m| m["id"] }
    @meetings = Meeting.find(meeting_ids)
  end
  
  def show
    common_vars
  end
  
  def edit
    common_vars
  end
  
  def new
    @teacher = Teacher.find(params[:teacher_id])
    Meeting.create(date: Date.tomorrow, time: "", venue: "", agenda: "")
    query = %q(
              SELECT id
              FROM meetings
              WHERE date > DATE('now'))
    meeting_ids = execute_sql(query)
    meeting_ids = meeting_ids.map { |m| m["id"] }
    @meetings = Meeting.find(meeting_ids)
    render :edit
  end
  
  def update
    @teacher = Teacher.find(params[:teacher_id])
    
    params[:meetings].each do |id, m|
      id = id.to_i
      date = m["date"].to_date
      time = m["time"]
      venue = m["venue"]
      agenda = m["agenda"]
      meeting = Meeting.find(id)
      meeting.update(date: date, time: time, venue: venue, agenda: agenda)
    end
  end
  
  def delete
    @teacher = Teacher.find(params[:teacher_id])
    id = params[:meeting_id]
    Meeting.delete(id)
  end
end
