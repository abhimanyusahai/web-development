class MentorsController < ApplicationController
  def show
    @teacher = Teacher.find(params[:teacher_id])
    query = %q(
            SELECT (COALESCE(t.first_name, '') || ' ' || COALESCE(t.last_name, '')) AS mentor_name,
                   GROUP_CONCAT((COALESCE(s.first_name, '') || ' ' || COALESCE(s.last_name, ''))) AS mentee_names
            FROM teachers AS t LEFT JOIN students AS s 
            ON t.id = s.mentee_teacher_id
            GROUP BY t.id)
    @mentors_table = execute_sql(query)
  end
end
