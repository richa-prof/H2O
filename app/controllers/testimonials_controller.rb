# frozen_string_literal: true

class TestimonialsController < ApplicationController
  def create
    @testimonial = Testimonial.new(testimonial_params)
    @testimonial.status = 'inativo'
    @testimonial.created = Time.now
    if @testimonial.save
      redirect_back fallback_location: root_path, notice: 'OK'
    else
      redirect_back fallback_location: root_path, danger: @testimonial.errors.full_messages.join(', ')
    end
  end

  private

  def testimonial_params
    params.require(:testimonial).permit(:institucionai_id, :nome, :email, :cidade, :texto)
  end
end
