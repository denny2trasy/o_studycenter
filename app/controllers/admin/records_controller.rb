require "csv"
class Admin::RecordsController < Admin::BaseController
  
  
  def create
    puts params
    if request.post? && params[:file].present?
      infile = params[:file].read
      n, errs = 0, []
      CSV.parse(infile,:quote_char => "\"").each do |row|  
                
        n += 1
        # SKIP: header i.e. first row OR blank row
        next if n == 1 or row.join.blank?
        begin
          WebexRecord.build_from_csv(row)
        # rescue
          # errs << row
        end
      end
      # Export Error file for later upload upon correction
      if errs.any?
        errFile ="errors_#{Date.today.strftime('%d%b%y')}.csv"
        # errs.insert(0, Customer.csv_header)
        errCSV = CSV.generate do |csv|
          errs.each {|row| csv << row}
        end
        send_data errCSV,
          :type => 'text/csv; charset=iso-8859-1; header=present',
          :disposition => "attachment; filename=#{errFile}.csv"
      else
        flash[:notice] = "Success Import"
        redirect_to admin_records_path 
      end
    end
  end
  
  def index
    page = params[:page] || 1
    puts "***********************#{page}"
    @webex_records = WebexRecord.page(page).per(20).order("created_at desc") #.combo_search(params)
  end
  
  
end
