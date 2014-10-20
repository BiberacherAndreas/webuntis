require "webuntis/version"
require "httparty"
require "securerandom"

class WebUntis
  include HTTParty # http://www.youtube.com/watch?v=6Zbi0XmGtMw
  format :json
  base_uri "demo.webuntis.com"
  
  attr_accessor :school
  attr_accessor :user
  attr_accessor :password
  
  attr_reader :session_id
  attr_reader :person_type
  attr_reader :person_id
  attr_reader :class_id
  
  # @param school [String] The school name (e.g. htl-stp)
  # @param user [String] The user name
  # @param password [String] The user's password
  # @param server [String] The server to use, without +/WebUntis+ (e.g. demo.webuntis.com).
  def initialize(school, user, password, server="demo.webuntis.com")
    @school = school
    @user = user
    @password = password
    self.class.base_uri server
  end
  
  # Authenticates the given user and starts a session.
  def authenticate()
    options = make_options("authenticate", {user: @user, password: @password, client: CLIENT_NAME})
    response = self.class.post("/WebUntis/jsonrpc.do?school=#{@school}", options)
    raise response["error"]["message"] unless response["error"].nil?
    @session_id  = response["result"]["sessionId"]
    @class_id    = response["result"]["klasseId"]
    @person_type = response["result"]["personType"]
    @person_id   = response["result"]["personId"]
  end
  alias authorize authenticate
  alias login authenticate
  
  # Gets a list of teachers.  Requires Authentication.
  # @return [Array] Array of hashes.
  def teachers()
    require_authentication!
    options = make_options("getTeachers")
    response = self.class.post("/WebUntis/jsonrpc.do;jsessionid=#{@session_id}?school=#{@school}", options)
    raise response["error"]["message"] unless response["error"].nil?
    response["result"]
  end
  
  # Gets a list of classes for the school year with ID +schoolyear+.
  # @param schoolyear [Integer] The ID of the school year, whatever that could be.  Defaults to +nil+ (current schoolyear) 
  # @return [Array] Array of hashes.
  def classes(schoolyear=nil)
    require_authentication!
    options = make_options("getKlassen", (schoolyear.nil? ? {} : {schoolyear: schoolyear}))
    response = self.class.post("/WebUntis/jsonrpc.do;jsessionid=#{@session_id}?school=#{@school}", options)
    raise response["error"]["message"] unless response["error"].nil?
    response["result"]
  end
  alias klassen classes
  
  # Gets a list of subjects. 
  # @return [Array] Array of hashes.
  def subjects()
    require_authentication!
    options = make_options("getSubjects")
    response = self.class.post("/WebUntis/jsonrpc.do;jsessionid=#{@session_id}?school=#{@school}", options)
    raise response["error"]["message"] unless response["error"].nil?
    response["result"]
  end
  
  # Gets a list of rooms.
  # @return [Array] Array of hashes.
  def rooms()
    require_authentication!
    options = make_options("getRooms")
    response = self.class.post("/WebUntis/jsonrpc.do;jsessionid=#{@session_id}?school=#{@school}", options)
    raise response["error"]["message"] unless response["error"].nil?
    response["result"]
  end
  
  # Gets a list of departments.
  # @return [Array] Array of hashes.
  def departments()
    require_authentication!
    options = make_options("getDepartments")
    response = self.class.post("/WebUntis/jsonrpc.do;jsessionid=#{@session_id}?school=#{@school}", options)
    raise response["error"]["message"] unless response["error"].nil?
    response["result"]
  end
  
  # Gets a list of holidays.
  # Dates are stored as an integer in the format yyyymmdd (e.g. 20141026)
  # @return [Array] Array of hashes.
  def holidays()
    require_authentication!
    options = make_options("getHolidays")
    response = self.class.post("/WebUntis/jsonrpc.do;jsessionid=#{@session_id}?school=#{@school}", options)
    raise response["error"]["message"] unless response["error"].nil?
    response["result"]
  end
  
  # Gets the timegrid units.
  # Times are stored as an integer in the format hhmm (e.g. 750, 1030)
  # @return [Array] Array of hashes.
  def timegrid()
    require_authentication!
    options = make_options("getTimegridUnits")
    response = self.class.post("/WebUntis/jsonrpc.do;jsessionid=#{@session_id}?school=#{@school}", options)
    raise response["error"]["message"] unless response["error"].nil?
    response["result"]
  end
  
  # Gets information about lesson types, period codes and their colours.
  # Lession types (lstypes): +ls+: lesson; +oh+: office hour; +sb+: standby;
  # +bs+: break supervision; +ex+: examination
  # @return [Array] Array of hashes.
  def status_data()
    require_authentication!
    options = make_options("getStatusData")
    response = self.class.post("/WebUntis/jsonrpc.do;jsessionid=#{@session_id}?school=#{@school}", options)
    raise response["error"]["message"] unless response["error"].nil?
    response["result"]
  end
  
  # Gets the current school year.
  # @return [Hash] The current school year object as a hash.
  def current_schoolyear()
    require_authentication!
    options = make_options("getCurrentSchoolyear")
    response = self.class.post("/WebUntis/jsonrpc.do;jsessionid=#{@session_id}?school=#{@school}", options)
    raise response["error"]["message"] unless response["error"].nil?
    response["result"]
  end
  
  # Gets all available school years.
  # @return [Array] Array of hashes.
  def schoolyears()
    require_authentication!
    options = make_options("getSchoolyears")
    response = self.class.post("/WebUntis/jsonrpc.do;jsessionid=#{@session_id}?school=#{@school}", options)
    raise response["error"]["message"] unless response["error"].nil?
    response["result"]
  end
  
  # Ends the session.  Requires Authentication.
  def logout()
    require_authentication!
    options = make_options("logout")
    response  = self.class.post("/WebUntis/jsonrpc.do;jsessionid=#{@session_id}?school=#{@school}", options)
    raise response["error"]["message"] unless response["error"].nil?
    @session_id = nil
  end
  
  private
    def require_authentication!
      raise "Please authenticate first!" if @session_id.nil?
    end
  
    # contains options given to HTTParty, including params for webuntis calls
    # @param method [String] the method that gets called
    # @param params [Hash] additional params for the method
    # @return [Hash]
    def make_options(method, params={})
      options = base_options
      options[:body][:params].merge! params
      options[:body].merge!({ method: method })
      options[:body] = options[:body].to_json
      options
    end
  
    # @return [Hash] the base options used for all HTTP POST requests
    def base_options
      {
        body: {
          id: SecureRandom.hex,
          params: {},
          jsonrpc: "2.0"
        },
        options: {
          headers: {
            "Content-Type" => "application/json",
          }
        }
      }
    end
end
