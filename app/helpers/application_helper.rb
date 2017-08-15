module ApplicationHelper
  
  def company_name
    content_tag(:span,  'Presidio Strategic Communications', class: 'hidden-sm-down presidio')
  end
  
  def current_user_email
    return '' unless current_user
    fa_icon("user").concat(content_tag(:span, " #{current_user.try(:email)}", class: 'hidden-sm-down'))    
  end
  
  def sidebar_calendar_icon
    fa_icon("calendar").concat(content_tag(:span, ' Calendar', class: 'hidden-sm-down'))
  end
  
  def sidebar_email_icon
    fa_icon("envelope").concat(content_tag(:span, ' Email', class: 'hidden-sm-down'))
  end
  
  def sidebar_logout_icon
    fa_icon("sign-out").concat(content_tag(:span, 'Log Out', class: 'hidden-sm-down'))
  end
  
  def sidebar_media_icon
    fa_icon("film").concat(content_tag(:span, ' Media', class: 'hidden-sm-down'))
  end
  
  def sidebar_reports_icon
    fa_icon("bar-chart-o").concat(content_tag(:span, ' Reports', class: 'hidden-sm-down'))
  end
  
  def sidebar_slack_icon
    fa_icon("slack").concat(content_tag(:span, ' Slack', class: 'hidden-sm-down'))
  end
  
  def sidebar_strongbox_icon
    fa_icon("cube").concat(content_tag(:span, ' Strongbox', class: 'hidden-sm-down strongbox'))
  end
  
  def sidebar_link_to(text, location, method=nil)
    html_options = { data: { parent: '#sidebar' }, class: 'list-group-item d-inline-block collapsed' }
    html_options.merge!(method: method) if method
    link_to text, location, html_options
  end
  
  def sidebar_link_to_logout
    return unless current_user
    sidebar_link_to sidebar_logout_icon, destroy_user_session_path, 'delete'
  end
  
  
end
