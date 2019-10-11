# frozen_string_literal: true

require 'rails_helper'

describe Tour do
  it 'shows selected records in order' do
    tour_second = create(:tour, exibir_site: true, ordem: 2)
    tour_first = create(:tour, exibir_site: true, ordem: 1)
    create(:tour, exibir_site: false)

    expect( Tour.count ).to eq 3
    expect( Tour.display_on_webiste.count ).to eq 2
    expect( Tour.display_on_webiste.first ).to eq tour_first
    expect( Tour.display_on_webiste.second ).to eq tour_second
  end

  it 'finds tours with same categories' do
    category = create(:category, :with_pt_br_locale)
    tour = create(:tour, :with_pt_br_locale)
    create(:tour_category, category: category, tour: tour)

    related_tour = create(:tour, :with_pt_br_locale)
    create(:tour_category, category: category, tour: related_tour)
    create(:tour_price, tour: related_tour)

    expect( tour.related_tours('pt-BR').first ).to eq related_tour
  end

  it 'excludes tours in different categories' do
    tour = create(:tour, :with_pt_br_locale)
    create(:tour_category, tour: tour)

    unrelated_tour = create(:tour, :with_pt_br_locale)
    create(:tour_category, tour: unrelated_tour)
    create(:tour_price, tour: unrelated_tour)

    expect( tour.related_tours('pt-BR').count ).to eq 0
  end

  it 'limits related tours results' do
    category = create(:category, :with_pt_br_locale)
    tour = create(:tour, :with_pt_br_locale)
    create(:tour_category, category: category, tour: tour)
    create_list(:tour_category, 7, :with_locales_and_prices, category: category)

    expect( tour.related_tours('pt-BR').count ).to eq 6
  end

  it 'returns price on selected date' do
    tour = create(:tour)
    create(:tour_price, tour: tour, preco_adulto: 1, inicio: '01/01/2001', fim: '10/01/2001' )
    create(:tour_price, tour: tour, preco_adulto: 2, inicio: '02/02/2002', fim: '20/02/2002' )
    create(:tour_price, tour: tour, preco_adulto: 3, inicio: '02/02/2002', fim: '20/02/2002' )

    expect( tour.check_price( Date.parse('05/01/2001') ).preco_adulto ).to eq 1
    expect( tour.check_price( Date.parse('05/02/2002') ).preco_adulto ).to eq 3
  end

  it 'returns extras to be displayed' do
    tour = create(:tour)
    tour_extra_price_type = create(:tour_extra_price_type, :unit_pt_br)

    tour_extra_yes = create(:tour_extra, tour: tour, tour_extra_price_type: tour_extra_price_type)
    create(:tour_extra_price, tour_extra: tour_extra_yes, inicio: '01/01/2001', fim: '10/01/2001')
    create(:tour_extra_locale, :pt_br, tour_extra: tour_extra_yes)

    tour_extra_bad_price_dates = create(:tour_extra, tour: tour, tour_extra_price_type: tour_extra_price_type)
    create(:tour_extra_price, tour_extra: tour_extra_bad_price_dates, inicio: '02/02/2002', fim: '20/02/2002')
    create(:tour_extra_locale, :pt_br, tour_extra: tour_extra_bad_price_dates)

    tour_extra_bad_locale = create(:tour_extra, tour: tour, tour_extra_price_type: tour_extra_price_type)
    create(:tour_extra_price, tour_extra: tour_extra_bad_locale, inicio: '01/01/2001', fim: '10/01/2001')
    create(:tour_extra_locale, tour_extra: tour_extra_bad_locale)

    these_extras = tour.extras_to_display( Date.parse('05/01/2001'), 'pt-BR' )

    expect( these_extras ).to include tour_extra_yes
    expect( these_extras ).not_to include tour_extra_bad_price_dates
    expect( these_extras ).not_to include tour_extra_bad_locale
  end

  it 'knows if tour is BTMS ready' do
    tour_yes = create(:tour, cdgbtms_atrativo: 'something', cdgbtms_atividade: 'or other')
    tour_no = create(:tour, cdgbtms_atrativo: 'something', cdgbtms_atividade: '')
    tour_no_no = create(:tour, cdgbtms_atrativo: '', cdgbtms_atividade: '')

    expect( tour_yes.btms_ready? ).to eq true
    expect( tour_no.btms_ready? ).to eq false
    expect( tour_no_no.btms_ready? ).to eq false
  end

  it 'determines when to allow BTMS communication' do
    good_tour = create(:tour, cdgbtms_atrativo: 'something', cdgbtms_atividade: 'or other', btms_online: true)
    lame_tour = create(:tour, cdgbtms_atrativo: 'something', cdgbtms_atividade: 'or other', btms_online: false)
    bad_tour = create(:tour, cdgbtms_atrativo: 'something', cdgbtms_atividade: 'or other', btms_online: nil)
    very_bad_tour = create(:tour, cdgbtms_atrativo: '', cdgbtms_atividade: '', btms_online: nil)
    confusing_tour = create(:tour, cdgbtms_atrativo: '', cdgbtms_atividade: '', btms_online: true)

    expect( good_tour.allow_public_btms_communication? ).to eq true
    expect( lame_tour.allow_public_btms_communication? ).to eq false
    expect( bad_tour.allow_public_btms_communication? ).to eq false
    expect( very_bad_tour.allow_public_btms_communication? ).to eq false
    expect( confusing_tour.allow_public_btms_communication? ).to eq false
  end

  it 'determines initial selected date' do
    normal_tour = create(:tour)
    false_tour = create(:tour, special_date: false)
    lonely_tour = create(:tour, special_date: true)

    old_date = (Date.current - 3.days).strftime('%d/%m/%Y')
    old_date_tour = create(:tour, special_date: true)
    old_date_tour_stock_time = create(:tour_stock_time, tour: old_date_tour, status: 'Ativo')
    create(:tour_stock_date, tour_stock_time: old_date_tour_stock_time, status: 'Ativo', subvariacao: old_date)

    ez_date = (Date.current + 40.days).strftime('%d/%m/%Y')
    ez_date_tour = create(:tour, special_date: true)
    ez_date_tour_stock_time = create(:tour_stock_time, tour: ez_date_tour, status: 'Ativo')
    create(:tour_stock_date, tour_stock_time: ez_date_tour_stock_time, status: 'Ativo', subvariacao: ez_date)

    date_1 = (Date.current + 1.days).strftime('%d/%m/%Y')
    date_2 = (Date.current + 2.days).strftime('%d/%m/%Y')
    two_dates_tour = create(:tour, special_date: true)
    two_dates_tour_stock_time = create(:tour_stock_time, tour: two_dates_tour, status: 'Ativo')
    create(:tour_stock_date, tour_stock_time: two_dates_tour_stock_time, status: 'Ativo', subvariacao: date_2)
    create(:tour_stock_date, tour_stock_time: two_dates_tour_stock_time, status: 'Ativo', subvariacao: date_1)

    expect( normal_tour.initial_selected_date ).to eq Date.current
    expect( false_tour.initial_selected_date ).to eq Date.current
    expect( lonely_tour.initial_selected_date ).to eq Date.current
    expect( old_date_tour.initial_selected_date ).to eq Date.current
    expect( ez_date_tour.initial_selected_date ).to eq (Date.current + 40.days)
    expect( two_dates_tour.initial_selected_date ).to eq (Date.current + 1.days)
  end
end
