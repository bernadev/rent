class RoomsController < ApplicationController
  require "i18n"
  before_action :set_room, only: [:show, :edit, :update, :destroy]

  # GET /rooms
  # GET /rooms.json
  def index
    @datatable = Effective::Datatables::Rooms.new
    @rooms = Room.all
  end

  def fetch

    loginResponseJSON= `curl -c myCookie 'http://www.compartodepa.com.mx/Account/Login' -H 'Pragma: no-cache' -H 'X-NewRelic-ID: VwAFUl9aGwcAU1NbBwM=' -H 'Origin: http://www.compartodepa.com.mx' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36' -H 'Content-Type: application/json; charset=UTF-8' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Cache-Control: no-cache' -H 'X-Requested-With: XMLHttpRequest' -H 'Cookie: ASP.NET_SessionId=mrnrtz5zzdr55oqgtohje0rm; __utmt=1; __utmt_global=1; __utma=266890268.11386725.1445460360.1445460360.1445473498.2; __utmb=266890268.2.10.1445473498; __utmc=266890268; __utmz=266890268.1445460360.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _dc_gtm_UA-51362008-1=1; _ga=GA1.3.11386725.1445460360' -H 'Connection: keep-alive' -H 'Referer: http://www.compartodepa.com.mx/' --data-binary '{\"UserName\":\"#{Config.find_by_key('username').value}\",\"Password\":\"#{Config.find_by_key('password').value}\",\"LoginSuccessful\":false,\"RememberMe\":true}' --compressed`
    loginResponse = JSON.parse(loginResponseJSON)
    if !loginResponse["LoginSuccessful"]
      puts "ERROR on login"
      puts JSON.pretty_generate(loginResponse)
    end
    resultJSON = `curl -c myCookie 'http://www.compartodepa.com.mx/Search/DynamicRoomSearch/GetResults' -H 'Pragma: no-cache' -H 'X-NewRelic-ID: VwAFUl9aGwcAU1NbBwM=' -H 'Origin: http://www.compartodepa.com.mx' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36' -H 'Content-Type: application/json; charset=UTF-8' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Cache-Control: no-cache' -H 'X-Requested-With: XMLHttpRequest' -H 'Cookie: ASP.NET_SessionId=mrnrtz5zzdr55oqgtohje0rm; haslogin=perm; usercode=2007040319551652174; checkcode=AAEAC8B5-C533-41D9-8F79-B3DD7E4DF74A; __utma=266890268.11386725.1445460360.1445460360.1445473498.2; __utmb=266890268.4.10.1445473498; __utmc=266890268; __utmz=266890268.1445460360.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); showProfileTeaserL15062218282926=false; _ga=GA1.3.11386725.1445460360; _gat_UA-51362008-1=1' -H 'Connection: keep-alive' -H 'Referer: http://www.compartodepa.com.mx/results-room/loc/52/pic/0/amax/99/amin/18/gen/0/occ/0/rmax/4000/rmin/0/ptyp/0/bed/1/doub/0/furn/0/shor/0' --data-binary '{\"jsonFilter\":{\"ageMin\":\"18\",\"ageMax\":\"99\",\"rentMin\":\"0\",\"rentMax\":\"#{Config.find_by_key('max_price').value}\",\"locationIds\":[\"53\",\"54\",\"55\",\"56\",\"62\",\"57\",\"58\",\"59\",\"60\",\"61\"],\"bedroomsAvailable\":\"1\",\"propertyCategory\":\"\",\"flatmateGender\":\"\",\"flatmateOccupation\":\"\",\"sortOrder\":\"LastupdateDate\",\"limit\":#{Config.find_by_key('limit').value},\"totalLocations\":[\"53\",\"54\",\"55\",\"56\",\"62\",\"57\",\"58\",\"59\",\"60\",\"61\"],\"pageNumber\":1},\"locationId\":\"52\"}' --compressed`
    results = JSON.parse(resultJSON)
    results = results["Results"]
    urls = Array.new
    results.select do |result| urls << result["ListingUrl"] end
    urls.each do |url|
      p "Checking if room is duplicated"
      next if Room.find_by_url("http://www.compartodepa.com.mx#{url}")
      p "Downloading room"
      room = `curl -c myCookie 'http://www.compartodepa.com.mx#{url}' -H 'Pragma: no-cache' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Referer: http://www.compartodepa.com.mx/results-room/loc/52/rmax/4000/bed/1/pic/0/doub/0/furn/0/shor/0/amin/18/amax/99/pag/11/srt/3' -H 'Cookie: ASP.NET_SessionId=mrnrtz5zzdr55oqgtohje0rm; showProfileTeaserL15062218282926=false; accountcode=L15062218282926; _ga=GA1.3.11386725.1445460360; search_locations=52|53,54,55,56,62,57,58,59,60,61; haslogin=perm; usercode=2007040319551652174; checkcode=AAEAC8B5-C533-41D9-8F79-B3DD7E4DF74A; __utma=266890268.11386725.1445460360.1445460360.1445473498.2; __utmb=266890268.40.8.1445477796850; __utmc=266890268; __utmz=266890268.1445460360.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none)' -H 'Connection: keep-alive' -H 'Cache-Control: no-cache' --compressed`
      newURL = room[room.index("moved to <a href=\"/")+19, room.index("\">here</a>.")-room.index("moved to <a href=\"/")-19]
      realRoom = `curl -c myCookie 'http://www.compartodepa.com.mx/#{newURL}' -H 'Pragma: no-cache' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: no-cache' -H 'Cookie: ASP.NET_SessionId=mrnrtz5zzdr55oqgtohje0rm; showProfileTeaserL15062218282926=false; accountcode=L15062218282926; search_locations=52|53,54,55,56,62,57,58,59,60,61; haslogin=perm; usercode=2007040319551652174; checkcode=AAEAC8B5-C533-41D9-8F79-B3DD7E4DF74A; __utmt=1; __utmt_global=1; __utma=266890268.11386725.1445460360.1445460360.1445473498.2; __utmb=266890268.44.8.1445477796850; __utmc=266890268; __utmz=266890268.1445460360.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.11386725.1445460360; _dc_gtm_UA-51362008-1=1' -H 'Connection: keep-alive' --compressed`
      begin
        p "Looking for room price"
        pricetmp = realRoom[realRoom.index("product:price:amount"), 100]
        price = pricetmp[/^(.*?)content=\"(.*?)\" \/>\n/, 2]
      rescue
        price = -1
      end
      p "==Looking for coordinates"
      coordinates = realRoom[realRoom.index("latitude"), 100]
      latitude= coordinates[/^latitude: \"(.*?)\".\n/, 1]
      longitude = coordinates[/^(.*?)longitude: \"(.*?)\".\n/, 2]
      room_coordinates=[latitude, longitude]
      request = "curl 'https://maps.googleapis.com/maps/api/distancematrix/json?origins=#{Config.find_by_key('work_coordinates').value}&destinations=#{room_coordinates.join(",")}&mode=walking&transit_routing_preference=less_walking&key=#{Config.find_by_key('api_key').value}'"
      result = `#{request}`
      p "Checking duration"
      unless (JSON.parse(result)["rows"][0]["elements"][0]["duration"]["value"] rescue nil).nil?
        @room_html = Nokogiri::HTML(realRoom)
        p "==Creating new room"
        roomi = Room.new
        roomi.url = "http://www.compartodepa.com.mx#{url}"
        roomi.price = price
        roomi.status = @room_html.xpath("/html/body/div[3]/"+
                                  "div/div[1]/section/div[2]/p")[0].text[0,255]
        roomi.requirements = I18n.transliterate(@room_html.xpath("/html/body/div[3]/div/div[1]/section/div[3]/p")[0].text[0,255])
        roomi.description = I18n.transliterate(@room_html.xpath("/html/body/div[3]/div/div[1]/section/div[4]/p")[0].text[0,255])
        roomi.time = JSON.parse(result)["rows"][0]["elements"][0]["duration"]["value"].to_f/60
        roomi.save!
      end
    end
    redirect_to action: 'index'
  end
  def togglediscard
    p "lol"
    render nothing: true
  end
  # GET /rooms/1
  # GET /rooms/1.json
  def show
  end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)

    respond_to do |format|
      if @room.save
        format.html { redirect_to @room, notice: 'Room was successfully created.' }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to @room, notice: 'Room was successfully updated.' }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_url, notice: 'Room was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_room
    @room = Room.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def room_params
    params.require(:room).permit(:url, :time, :price, :status, :requirements, :description, :discarded)
  end
end
