require 'sinatra'
require 'sinatra/json'
require_relative 'helpers'

module Http
  class GithubRoutes < Sinatra::Base
    include Http::Helpers

    configure do
      enable :method_override
    end

    configure :development do
      enable :logging, :dump_errors, :raise_errors
      set :force_ssl, false
    end

    configure :production do
      set :raise_errors, false
      set :show_exceptions, false
      set :force_ssl, true
    end

    post '/webhooks/issues' do
      payload = JSON.parse(request.body.read, symbolize_names: true)
      issue = issue_from_payload(payload)
      if issue.should_track?
        create_wizeline_issue(issue)
      end
      json :ok
    end
  end
end
