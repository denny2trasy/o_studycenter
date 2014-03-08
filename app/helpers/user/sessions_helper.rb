module User::SessionsHelper
  def language_select
    if request.request_uri == '/el_studycenter/signin'
      '/el_studycenter/signup'
    elsif request.request_uri == '/el_studycenter/signin/zh'
      '/el_studycenter/signup/zh'
    elsif request.request_uri == '/el_studycenter/signin/tw'
      '/el_studycenter/signup/tw'
    elsif request.request_uri == '/el_studycenter/signin/ko'
      '/el_studycenter/signup/ko'
    elsif request.request_uri == '/el_studycenter/signin/pt'
      '/el_studycenter/signup/pt'
    elsif request.request_uri == '/el_studycenter/signin/es'
      '/el_studycenter/signup/es'
    else
      '/el_studycenter/signup/en'
    end
  end
end