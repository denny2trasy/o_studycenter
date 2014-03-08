module ApplicationHelper

  # highlight the top nav, default the highlight nav is current page.
  # you could pass a hash {'/abc' => '/def'} to accomplish highlight /def when access /abc.
  def highlight_top_nav(hash = {})
    path = hash[request.path].presence || request.path
    javascript_tag do
      %{$(function() {
        $('a[href=#{path}]').parent().attr('class', 'active');
        })}
      end
    end

    def show_flash
      [:notice, :error, :warning].collect do |key|
        content_tag(:p, flash[key], :id => key, :class => "flash flash_#{key}") unless flash[key].blank?
      end.join
    end
    
    def show_report
      [:report].collect do |key|
        content_tag(:p, flash[key], :id => key, :class => "flash flash_#{key}") unless flash[key].blank?
      end.join
    end

    def format_params_to_conditions(params)
      return ""  unless search = params[:search]
      search = remove_blank_value(search)
      search = ActiveSupport::HashWithIndifferentAccess.new(search)
      build_conditions(search)
    end

    private

    def remove_blank_value(hash)
      Hash[hash.map{|key, value| [key, value.select{|k, v| v.present?}]}]
    end

    def fetch_user_ids(search)
      search[:user].blank? ? [] : User.search(search[:user]).all.map(&:id) 
    end

    def fetch_customer_ids(search)
      search[:customer].blank? ? [] : Customer.search(search[:customer]).all.map(&:id)
    end

    def build_conditions(search)
      {:user_id => fetch_user_ids(search), :customer_id => fetch_customer_ids(search)}.
      select{|key, ids| ids.present?}.
      map{|key, ids| "#{key} IN (#{ids.join(', ')})"}.
      join(" AND ")
    end

  end
