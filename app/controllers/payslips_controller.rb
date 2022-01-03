# frozen_string_literal: true

class PayslipsController < ApplicationController
  before_action :authenticate_user!

  def index
    @payslips = policy_scope(Payslip.reverse_chronologic).page(params[:page]).per(10)
  end

  def new
    @payslip = authorize Payslip.new month: DateTime.current.beginning_of_month
  end

  def create
    authorize Payslip
    Payslip.create! payslip_attributes
    ui.navigate_to payslips_path
  end

  def destroy
    @payslip = authorize Payslip.find(params[:id])
    @payslip.destroy!
    redirect_to payslips_path
  end

  private

  def payslip_attributes
    params.require(:payslip).permit(:user_id, :month, :pdf)
  end
end
