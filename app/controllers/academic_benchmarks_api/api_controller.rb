module AcademicBenchmarksApi
  class ApiController < ApplicationController

    require 'openssl'
    require 'base64'
    require 'net/http'

    def ab_api_url
      "https://api.academicbenchmarks.com/rest/v4"
    end

    def expiration
      1.day.from_now.to_i
    end

    def hash(auth_exp)
      key = Rails.application.secrets.academic_benchmarks_api_key

      # Rails.logger.info auth_exp
      data = "#{auth_exp}\n\nGET"
      message = OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha256'), key, data)
      #Base64.encode64(message).strip()
      Base64.strict_encode64(message)#.strip()
    end

    def auth_params
      auth_exp = expiration
      partner_id = Rails.application.secrets.academic_benchmarks_partner_id

      {"partner.id": partner_id,
       "auth.signature": hash(auth_exp),
       "auth.expires": auth_exp}
    end

    def ab_request(action, p)
      uri = URI.parse( "#{ab_api_url}/#{action}" );

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      req = Net::HTTP::Get.new( uri.path + '?' + p.to_query )
      response = http.request(req)

      #URI.decode(p.to_query)
      render :json => response.body
    end

    def authorities
      p = auth_params
      p[:facet] = "document.publication.authorities"
      p[:limit] = 0
      ab_request("standards", p)
    end

    def publications
      guid = params[:guid] || "A83297F2-901A-11DF-A622-0C319DFF4B22"
      p = auth_params
      p[:filter] = {:standards => "(document.publication.authorities.guid eq '#{guid}')"}
      p[:facet] = "document.publication"
      p[:limit] = 0
      ab_request("standards", p)
    end

    def documents
      guid = "964E0FEE-AD71-11DE-9BF2-C9169DFF4B22"
      p = auth_params
      p[:filter] = {:standards => "(document.publication.guid eq '#{guid}')"}
      p[:facet] = "document"
      p[:limit] = 0
      ab_request("standards", p)
    end

    def sections
      guid = "CF6A375C-67AD-11DF-AB5F-995D9DFF4B22"
      p = auth_params
      p[:filter] = {:standards => "(document.guid eq '#{guid}')"}
      p[:facet] = "section"
      p[:limit] = 0
      ab_request("standards", p)
    end

    def standards
      guid = params[:guid] ||"5E1148F4-7377-11DF-A1E8-223D9DFF4B22"
      level = params[:level] || "1"
      p = auth_params
      p[:fields] = {:standards => "seq,number,statement,children"} #
      p[:filter] = {:standards => "(section.guid eq '#{guid}' and level eq '#{level}')"} # and level eq 1
      p[:sort] = {:standards => "seq"}
      ab_request("standards", p)
    end

    def children
      guid = params[:guid] ||"2CE7D14A-74F7-11DF-80DD-6B359DFF4B22"
      p = auth_params
      p[:fields] = {:standards => "seq,number,statement,children"} #
      p[:filter] = {:standards => "(parent.id eq '#{guid}')"}
      p[:sort] = {:standards => "seq"}
      ab_request("standards", p)
    end

    def detail
      guid = params[:guid] || "7E7C05D8-7440-11DF-93FA-01FD9CFF4B22"
      p = auth_params
      p[:fields] = {:standards => "statement,section,document,education_levels,disciplines,number,parent,utilizations"} # ,topics,concepts,key_ideas
      #p[:include] = "topics,concepts"
      ab_request("standards/#{guid}", p)
    end


    # UNUSED #
    def education_levels
      guid = "CF6A375C-67AD-11DF-AB5F-995D9DFF4B22"
      p = auth_params
      p[:filter] = {:standards => "(document.guid eq '#{guid}')"}
      p[:facet] = "education_levels.grades"
      p[:limit] = 0
      ab_request("standards", p)
    end



    #
    #
    #https://api.academicbenchmarks.com/rest/v4/standards
    #?filter[standards]=(parent.id eq '1D9D7C1A-7053-11DF-8EBF-BE719DFF4B22')&sort[standards]=seq

    #p[:facet] = "section"
    #       #p[:filter] = {:standards => "(parent.id eq '#{guid}')"}

    # https://api.academicbenchmarks.com/rest/v4/standards
    # ?filter[standards]=(parent.id eq '1D9D7C1A-7053-11DF-8EBF-BE719DFF4B22')&sort[standards]=seq

    # https://api.academicbenchmarks.com/rest/v4/
    #     standards?filter[standards]=(section.guid eq '6C23310C-6EC0-11DF-AB2D-366B9DFF4B22' and level eq 1)&sort[standards]=seq
  end
end
