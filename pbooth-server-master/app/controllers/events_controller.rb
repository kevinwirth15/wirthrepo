class EventsController < ApplicationController

  before_action :set_event, only: [:show, :edit, :update, :destroy, :activate, :sync, :deactivate]

  # GET /events/settings
  def settings
    render json: Event.latest
  end

  # GET /events/:id/photos
  def photos
    @event = Event.find(params[:id])
    @photo_ids = @event.gif_mode? ? gif_list : photo_list
    render json: @photo_ids
  end

  def photo_list
    puts "called gif_list"
    @event.photos.where(validated: true).order(updated_at: :asc).map do |photo|
      { id: photo.id, gif: false, url: photo_path(photo.id) }
    end
  end

  def gif_list
    puts "called gif_list"
    @event.photosets.where(validated: true).order(updated_at: :asc).map do |photoset|
      { id: photoset.id, gif: true, url: photoset_path(photoset.id) }
    end
  end

  def activate
    @event.touch

    # Re validate all photos
    @event.photos.find_each do |photo|
      photo.validate!
    end

    # Re validate all photosets
    @event.photosets.find_each do |photoset|
      photoset.validate!
    end

    @event.activate

    redirect_to admin_path, notice: "Event \"#{@event.name}\" activated"
  end

  def deactivate
    @event.deactivate
    redirect_to admin_path, notice: "Event \"#{@event.name}\" deactivated"
  end

  def sync
    redirect_to admin_path, notice: "Event \"#{@event.name}\" synced"
  end

  # GET /events
  # GET /events.json
  def index
    redirect_to root_path
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    @event.set_defaults
  end

  # POST /events
  # POST /events.json
  def create
    #@event = Event.new(event_params)

    #Dir::mkdir("#{PROJECT_ROOT}/events/#{@event.name}")

    #respond_to do |format|
    #  if @event.save
    #    format.html { redirect_to @event, notice: 'Event was successfully created.' }
    #    format.json { render action: 'show', status: :created, location: @event }
    #  else
    #    format.html { render action: 'new' }
    #    format.json { render json: @event.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    #    @event.destroy
    #    respond_to do |format|
    #      format.html { redirect_to events_url }
    #      format.json { head :no_content }
    #    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(
      :name, :gif_mode, :multiple_orientations,
      :photos_in_set, :branded_image_width, :branded_image_height,
      :display_image_width, :display_image_height,
      :print_image_width, :print_image_height,
      :copy_email_subject, :copy_email_body, :copy_social, :copy_twitter,
      :smugmug_album,
      :option_smugmug, :option_print, :option_email, :option_twitter, :option_facebook
    )
  end
end
