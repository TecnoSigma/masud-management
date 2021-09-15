class Dashboards::Subscribers::TicketsController < ApplicationController
  before_action :validate_sessions
  before_action :find_subscriber

  def index
    @opened = Ticket.opened(@subscriber)
    @in_treatment = Ticket.in_treatment(@subscriber)
    @finished = Ticket.finished(@subscriber)
  end

  def new
    @new_ticket = Ticket.new
    @new_ticket.comments.build
  end

  def show
    if has_ticket?
      @ticket = Ticket.find(params['ticket_id'])
    else
      redirect_to dashboards_assinantes_chamados_path,
                  alert: I18n.t('messages.errors.ticket_not_found')
    end
  rescue
    redirect_to dashboards_assinantes_chamados_path,
                alert: I18n.t('messages.errors.failed_to_show_ticket')
  end

  def create
    new_ticket = Ticket.new(ticket_params.except('comment', 'author', 'image'))	

    if new_ticket.valid?
      new_ticket.save!
      create_comment!(new_ticket)
 
      redirect_to dashboards_assinantes_chamados_path,
                  notice: I18n.t('messages.successes.save_data')
    else
      redirect_to dashboards_assinantes_chamados_path,
                  alert: I18n.t('messages.errors.save_data_failed')
    end
  rescue
    redirect_to dashboards_assinantes_chamados_path,
                alert: I18n.t('messages.errors.save_data_failed')
  end

  def edit
    if has_ticket?
      @ticket = Ticket.find(params['ticket_id'])
    else
      redirect_to dashboards_assinantes_chamados_path,
                  alert: I18n.t('messages.errors.ticket_not_found')
    end
  end

  def reopen
    if has_ticket?
      ticket = Ticket.find(params['ticket_id'])
      if ticket.update_attributes!(status: Status::TICKET_STATUSES[:recurrence])
        create_comment!(ticket)
      end
      redirect_to show_ticket_path(ticket, type: Ticket::GROUPS[:recurrence]),
                  notice: I18n.t('messages.successes.opened_ticket')
    else
      redirect_to dashboards_assinantes_chamados_path,
                  alert: I18n.t('messages.errors.ticket_not_found')
    end
  rescue
    redirect_to dashboards_assinantes_chamados_path,
                alert: I18n.t('messages.errors.ticket_not_found')
  end

  private
    def create_comment!(ticket)
      comment = Comment
                  .create(content: comment_params['comment'],
                          author: comment_params['author'],
                          ticket: ticket)

      return unless params['ticket']['image'].present?

      if allowed_attachment?(comment, params['ticket']['image'])
        comment.image.attach(params['ticket']['image'])
      end
    end

    def allowed_attachment?(comment, file_info)
      comment.allowed_attachment_type?(file_info.content_type) &&
        comment.allowed_attachment_size?(file_info.size)
    end

    def has_ticket?
      Ticket
        .send(params['type'].to_sym, @subscriber)
        .pluck(:id)
        .include?(params['ticket_id'].to_i)
    end

    def comment_params
      ticket_params.except('department', 'subject', 'subscriber')
    end

    def ticket_params
      params
        .require(:ticket)
        .permit(:department, :subject, :comment, :author, :image)
        .merge({ subscriber: @subscriber, status: Status::TICKET_STATUSES[:opened] })
    end
end
