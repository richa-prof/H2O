RailsAdmin.config do |config|

  config.main_app_name = ['Agência H2O','Interno']

  config.show_gravatar = false

  config.label_methods << :nome
  config.label_methods << :titulo_menu

  config.authenticate_with do
    warden.authenticate! scope: :admin
  end
  config.current_user_method(&:current_admin)

  config.audit_with :paper_trail, 'Admin', 'PaperTrail::Version'

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  PAPER_TRAIL_AUDIT_MODEL = [
    'Tour',
    'Institutional',
    'InstitutionalLocale',
    'Banner',
    'SpecialDeal',
    'Hotel'
  ]

  config.actions do
    dashboard do
      statistics false
    end
    index
    export
    show do
      except ['Lunch','Child','Ability','AdminType']
    end

    new do
      except ['Lunch','Child','Ability','AdminType','MyVeryOwnLog','SearchHistory']
    end

    edit do
      except ['Lunch','Child','Ability','AdminType','MyVeryOwnLog','SearchHistory']
    end

    delete do
      only ['Banner','BannerLocale']
    end

    history_show do
      only PAPER_TRAIL_AUDIT_MODEL
    end

    # show_in_app
    # bulk_delete
  end

  config.included_models = [
    'Lunch',
    'Child',
    'Ability',
    'Tour',
    'Admin',
    'AdminType',
    'MyVeryOwnLog',
    'Institutional',
    'InstitutionalLocale',
    'Banner',
    'BannerLocale',
    'SpecialDeal',
    'Hotel',
    'SearchHistory'
  ]
end
