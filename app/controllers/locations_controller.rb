class LocationsController < ApplicationController

  helper_method :sort_column, :sort_direction

  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 10)
    
    @csv_locations = Location.order(:name)
    @json = Location.search(params[:search]).to_gmaps4rails do |location, marker|
      location_link = view_context.link_to location.name, location_path(location)
      marker.title location.name
      marker.infowindow "<h4><u>#{location_link}</u></h4> <i>#{location.address}</i>"
      marker.picture({:picture => "http://maps.google.com/mapfiles/ms/icons/purple-dot.png",
     :width   => 32,
     :height  => 32
   })
    end

    respond_to do |format|
      format.html # index.html.erb
      format.csv { render text: @csv_locations.to_csv }
      format.json { render json: @locations }
    end
  end

  def import
    Location.import(params[:file])
    redirect_to root_url, notice: "Locations imported."
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    @location = Location.find(params[:id])
    @json = Location.find(params[:id]).to_gmaps4rails

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @location }
    end
  end

  # GET /locations/new
  # GET /locations/new.json
  def new
    @location = Location.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @location }
    end
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(params[:location])

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render json: @location, status: :created, location: @location }
      else
        format.html { render action: "new" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.json
  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end

private
  
  def sort_column
    Location.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
