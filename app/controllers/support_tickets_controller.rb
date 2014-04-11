class SupportTicketsController < ApplicationController
  before_filter :require_signed_in_user

  def index
    @tickets = SupportTicket.list_by_user(current_user).reverse
    @users = SupportTicket.user_map
  end

  def show
    @ticket = SupportTicket.retrieve(params[:id])
  end

  def new;end

  def update
    SupportTicket.update(params[:id], params[:comment], current_user)
    redirect_to support_ticket_path(params[:id])
  end

  def create  
    ticket = SupportTicket.create(current_user, params[:subject], params[:message])
    redirect_to support_ticket_path(ticket.id)
  end
end
