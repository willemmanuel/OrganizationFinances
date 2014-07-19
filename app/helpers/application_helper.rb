module ApplicationHelper
  def markdown(text)
    options = {
      filter_html:     true,
      hard_wrap:       true,
      link_attributes: { rel: 'nofollow', target: "_blank" },
      space_after_headers: true,
      fenced_code_blocks: true
    }

    extensions = {
      autolink:           true,
      superscript:        true,
      disable_indented_code_blocks: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end

  def get_semester(chapter, semester_name)
    if !chapter
      return nil
    end
    if !semester_name
      return chapter.get_current_semester
    end
    sem = Semester.where(name: semester_name, chapter_id: chapter.id).first
    if !sem
      return chapter.get_current_semester
    end
    return sem
  end

  def get_next_semester(semester)
    s = Semester.where(chapter_id: semester.chapter.id, semester_id: semester.id).first
    if s
      return s
    else
      return nil
    end
  end

  def get_previous_semester(semester)
    if semester.semester != nil
      return semester.semester
    else
      return nil
    end
  end

end
