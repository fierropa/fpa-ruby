module ApplicationHelper
  
  def current_user_email
    return unless current_user
    fa_icon("user").concat(content_tag(:span, current_user.try(:email), class: 'hidden-sm-down'))    
  end
  
  def sidebar_link_to(text, location)
    link_to text, location, data: { parent: '#sidebar' }, class: 'list-group-item d-inline-block collapsed'
  end
end
