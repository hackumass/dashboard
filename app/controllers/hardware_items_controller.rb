class HardwareItemsController < ApplicationController
  before_action :set_hardware_item, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, except: [:search, :index, :facilities]
  before_action :check_attendee_slack, only: [:search, :index]
  before_action -> { is_feature_enabled($Hardware) }

  def search
    if params[:search].present?
      # if a number is searched and it matches the uid of a item, return the item
      if is_uid?(params[:search].to_i)
        item = HardwareItem.where(uid: params[:search])
        if !item.first.nil?
          redirect_to hardware_item_path(item.first)
        end
      end
      # otherwise, substring match the query for all item's name, category, and link fields
      @hardware_items = HardwareItem.where("lower(name) LIKE lower(?) OR lower(category) LIKE lower(?) OR lower(link) LIKE lower(?)", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
    else
      @hardware_items = HardwareItem.all
    end
  end

  def facilities
  end

  def index
    @all_hardware_items = HardwareItem.all.order(name: :asc)
    @hardware_items = HardwareItem.all.order(name: :asc).paginate(page: params[:page], per_page: 20)
  end

  def show
    # Create a new hardware checkout object in case that some hardware is checked out
    @hardware_checkout = HardwareCheckout.new

    # Get all the people that have checked out items
    @checked_out_items = HardwareCheckout.where(hardware_item: @hardware_item)

    # Get history of actions on this hardware item
    @checkout_log = HardwareCheckoutLog.where(hardware_item: @hardware_item).order(created_at: :desc)

    # Do we really need a csv page for one spcific hardware item ???
    respond_to do |format|
      format.html
      format.csv{ send_data @hardware_item.to_csv}
    end

  end

  def new
    @hardware_item = HardwareItem.new
  end

  def edit
  end

  def create
    @hardware_item = HardwareItem.new(hardware_item_params)
    if @hardware_item.save
      redirect_to hardware_items_url, notice: 'Hardware item was successfully created.'
    else
      render :new
    end
  end

  def update
    if @hardware_item.update(hardware_item_params)
      redirect_to hardware_items_path, notice: 'Hardware item was successfully updated.'
    else
      render :edit
    end
  end

  def all_checked_out

    if params[:search].present?
      @individual = true
      # If there is a value in the search field, search on email, first name, and last name
      @hardware_checkouts = HardwareCheckout.joins(:user).where("lower(users.email) LIKE lower(?)",
       "%#{params[:search]}%").paginate(page: params[:page], per_page: 20)
       @email = params[:search]
    else
      @individual = false
      @hardware_checkouts = HardwareCheckout.all.paginate(page: params[:page], per_page: 20)
    end

  end

  def slack_message_all_checked_out

    if !HackumassWeb::Application::SLACK_ENABLED
      flash[:alert] = "Slack integration disabled. Please enable Slack integration to use this feature."
      redirect_to hardware_items_url
      return
    end

    cnt = 0
    message = params[:message] or ""

    @checkouts = params[:search].present? ? HardwareCheckout.joins(:user).where("lower(users.email) LIKE lower(?)") :  HardwareCheckout.all

    @checkouts.each do |c|
      user = User.find(c.user_id)
      hwitem = HardwareItem.find(c.hardware_item_id)
      if user.has_slack?
        slack_notify_user(user.slack_id, "You still have this hardware item checked out: #{hwitem.name}. #{message}")
        HardwareCheckoutLog.create(user_id: user.id, hardware_item_id: hwitem.id, action: "Sent Slack Message", message: "#{message}")
        cnt += 1
      end
    end
    flash[:success] = "Contacted #{cnt} user(s) on Slack with message: #{message}"
    redirect_to hardware_items_path
  end

  def slack_message_individual_checkout

    if !HackumassWeb::Application::SLACK_ENABLED
      flash[:alert] = "Slack integration disabled. Please enable Slack integration to use this feature."
      redirect_to hardware_items_url
      return
    end

    c = HardwareCheckout.find(params[:checkout_id])
    user = User.find(c.user_id)
    hwitem = HardwareItem.find(c.hardware_item_id)
    message = params[:message] or ""
    cnt = 0
    if user.has_slack?
      slack_notify_user(user.slack_id, "You still have this hardware item checked out: #{hwitem.name}. #{message}")
      HardwareCheckoutLog.create(user_id: user.id, hardware_item_id: hwitem.id, action: "Sent Slack Message", message: "#{message}")
      cnt += 1
    end
    flash[:success] = "Contacted the user on Slack with message: #{message}"
    redirect_to hardware_item_path(hwitem.id)
  end

  def slack_message_individual_item

    if !HackumassWeb::Application::SLACK_ENABLED
      flash[:alert] = "Slack integration disabled. Please enable Slack integration to use this feature."
      redirect_to hardware_item_path(params[:hwitem_id])
      return
    end

    cnt = 0
    message = params[:message] or ""

    @checkouts = HardwareCheckout.where(hardware_item_id: params[:hwitem_id])

    @checkouts.each do |c|
      user = User.find(c.user_id)
      hwitem = HardwareItem.find(c.hardware_item_id)
      if user.has_slack?
        slack_notify_user(user.slack_id, "You still have this hardware item checked out: #{hwitem.name}. #{message}")
        HardwareCheckoutLog.create(user_id: user.id, hardware_item_id: hwitem.id, action: "Sent Slack Message", message: "#{message}")
        cnt += 1
      end
    end
    flash[:success] = "Contacted #{cnt} user(s) on Slack with message: #{message}"
    redirect_to hardware_item_path(params[:hwitem_id])
  end

  def destroy
    @hardware_item.destroy
    redirect_to hardware_items_url, notice: 'Hardware item was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hardware_item
      begin
        @hardware_item = HardwareItem.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to hardware_items_url, alert: 'Item could not be found'
      end
    end

    # Only admins and organizers have the ability to create, update, edit, show, and destroy hardware items
    def check_permissions
      unless current_user.is_organizer?
        redirect_to index_path, alert: 'You do not have the permissions to visit this section of hardware.'
      end
    end

    # Users who are attendees and don't have slack are not allowed to look at the hardware inventory
    def check_attendee_slack
      if current_user and HackumassWeb::Application::SLACK_ENABLED and current_user.is_attendee? and !current_user.has_slack?
        redirect_to join_slack_path, alert: 'You will need to join slack before you access our hardware page.'
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hardware_item_params
      params.require(:hardware_item).permit(:name, :count, :link, :category, :available, :uid, :location)
    end

    # Checks if the uid is in range
    def is_uid?(number)
      number > 0 and number < 1000000000
    end

    # Randomly and recursively generate a uid number
    def generate_uid
      random_uid = rand(1000000000)
      if(HardwareItem.where(uid: random_uid)).any?
        generate_uid
      else
        random_uid
      end
    end

end
