# frozen_string_literal: true

class CartMailer < ApplicationMailer
  default from: 'Agência H2O <reservas@h2oecoturismo.com.br>'

  def reservations_requested(cart)
    @cart = cart
    mail(to: @cart.user.email, subject: "CA #{@cart.id} - #{t 'cart_mailer.reservations_requested'}")
  end

  def create_itinerary(itinerary)
    @itinerary = itinerary
    @confirmation_text = Institutional.friendly.find_by(tag: 'email_compra_online_reservas_confirmadas')
    to_emails = @itinerary.user.email + ',adm@h2oecoturismo.com.br,operacional@h2oecoturismo.com.br,promocao@h2oecoturismo.com.br'
    mail(to: to_emails, bcc: 'kassilene@h2oecoturismo.com.br', subject: "PD #{itinerary.id} - #{t 'cart_mailer.reservations_confirmed'}")
  end
end
