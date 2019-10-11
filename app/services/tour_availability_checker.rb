# frozen_string_literal: true

class TourAvailabilityChecker

  def initialize(tour,selected_date)
    @tour = tour
    @selected_date = selected_date
  end

  def check_this
    return check_btms unless check_btms == false
    return check_stock unless check_stock == false

    'not available'
  end

  def check_btms
    begin
      return false unless @tour.allow_public_btms_communication?

      btms = BTMSWrapper.new
      available_btms_times = btms.check_tour_availability(@tour, @selected_date)

      return false if available_btms_times.dig('info').blank?

      unless available_btms_times.dig('info', 0, 'msg').blank?
        MyVeryOwnLog.create(authoring_class: 'TourAvailabilityChecker',
                            authoring_method: 'check_btms',
                            authoring_user_email: '',
                            info: "#{@tour.nome} #{@selected_date.strftime('%d/%m/%Y')} [BTMS] => #{available_btms_times['info'].first['cdg_erro']} #{available_btms_times['info'].first['msg']}")
      end

      return false unless available_btms_times.dig('info', 0, 'vagas_dia_atividade').to_i > 0

      return false if available_btms_times.dig('dados').blank?
      return false unless available_btms_times.dig('dados', 0, 0).values.map(&:to_i).sum > 0

      availability = []
      available_btms_times.dig('dados', 0, 0).each do |t|
        if t.last.to_i > 0
          availability_detail = {}
          availability_detail['system'] = 'BTMS'
          availability_detail['time'] = t.first
          availability_detail['slots'] = t.last
          availability << availability_detail
        end
      end

      availability
    rescue Exception => e
      MyVeryOwnLog.create(authoring_class: 'TourAvailabilityChecker',
                          authoring_method: 'check_btms',
                          authoring_user_email: '',
                          info: "#{@tour.nome} #{@selected_date.strftime('%d/%m/%Y')} [rescue] => #{e.backtrace&.first} #{e.inspect}")
      return false
    end
  end

  def check_stock
    available_stock_times = @tour.tour_stock_times.available_on_date(@selected_date)

    if available_stock_times.blank?
      availability = false
    else
      availability = []
      available_stock_times.display_on_website.each do |stock_time|
        availability_detail = {}
        availability_detail['system'] = stock_time.tour_stock_dates.available_on_date(@selected_date).first.id.to_s
        availability_detail['time'] = stock_time.variacao
        availability_detail['slots'] = stock_time.tour_stock_dates.available_on_date(@selected_date).first.estoque.to_s
        availability << availability_detail
      end
    end

    availability
  end
end
