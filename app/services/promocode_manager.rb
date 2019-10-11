# frozen_string_literal: true

class PromocodeManager
  def self.run_promocode(cupom_id, cart, current_user)
    cupon = Cupon.find_by(chave: cupom_id)

    cupon_is_valid = (cupon.present? && (cupon.usuario_id.nil? || (cupon.usuario_id == current_user.id)))

    return { msg: 'invalid_promocode' } unless cupon_is_valid

    return { msg: 'promocode_expired' } unless cupon.vencimento.nil? || (cupon.vencimento >= Date.current)

    return { msg: 'reached_limit' } unless cupon.limite.nil? || (cupon.limite.to_i > cupon.vezes_usado.to_i)

    discount = cart.subtotal * cupon.porcentagem.to_i / 100 if cupon.tipo == 'Porcentagem'

    discount = cupon.brl.to_f if cupon.tipo == 'BRL'

    cart.update(
      cupom_id: cupon.id,
      desconto: discount,
      total: cart.subtotal - discount.to_f
    )

    cupon.update(vezes_usado: cupon.vezes_usado.to_i + 1)

    if %w[Porcentagem BRL].include? cupon.tipo
      { msg: 'applied_successfully' }
    else
      cart.update(cupom_id: cupon.id, desconto: nil, total: cart.subtotal)
      { msg: 'congratulations_prize', extra: cupon.tipo }
    end
  end
end
