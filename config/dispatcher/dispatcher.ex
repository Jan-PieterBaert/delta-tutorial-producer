defmodule Dispatcher do
  use Matcher
  define_accept_types [
    html: [ "text/html", "application/xhtml+html" ],
    json: [ "application/json", "application/vnd.api+json" ]
  ]

  @any %{}
  @json %{ accept: %{ json: true } }
  @html %{ accept: %{ html: true } }

  # In order to forward the 'themes' resource to the
  # resource service, use the following forward rule:
  #
  # match "/themes/*path", @json do
  #   Proxy.forward conn, path, "http://resource/themes/"
  # end
  #
  # Run `docker-compose restart dispatcher` after updating
  # this file.

  match "/books/*path" do
    Proxy.forward conn, path, "http://books/books/"
  end

  match "/boooks/*path" do
    Proxy.forward conn, path, "http://books/books/"
  end

  match "/authors/*path" do
    Proxy.forward conn, path, "http://books/authors/"
  end

  match "/books-frontend/*path" do
    Proxy.forward conn, path, "http://frontend_books/"
  end

  # Step 2

  match "/remote-data-objects/*path" do
    Proxy.forward conn, path, "http://cache/remote-data-objects/"
  end

  match "/basic-authentication-credentials/*path" do
    Proxy.forward conn, path, "http://cache/basic-authentication-credentials/"
  end

  match "/basic-security-schemes/*path" do
    Proxy.forward conn, path, "http://cache/basic-security-schemes/"
  end

  match "/oauth2-credentials/*path" do
    Proxy.forward conn, path, "http://cache/oauth2-credentials/"
  end

  match "/oauth2-security-schemes/*path" do
    Proxy.forward conn, path, "http://cache/oauth2-security-schemes/"
  end

  match "/authentication-configurations/*path" do
    Proxy.forward conn, path, "http://cache/authentication-configurations/"
  end

  match "/harvesting-collections/*path" do
    Proxy.forward conn, path, "http://cache/harvesting-collections/"
  end

  match "/jobs/*path" do
    Proxy.forward conn, path, "http://cache/jobs/"
  end

  match "/tasks/*path" do
    Proxy.forward conn, path, "http://cache/tasks/"
  end

  match "/scheduled-jobs/*path" do
    Proxy.forward conn, path, "http://cache/scheduled-jobs/"
  end

  match "/scheduled-tasks/*path" do
    Proxy.forward conn, path, "http://cache/scheduled-tasks/"
  end

  match "/cron-schedules/*path" do
    Proxy.forward conn, path, "http://cache/cron-schedules/"
  end

  match "/data-containers/*path" do
    Proxy.forward conn, path, "http://cache/data-containers/"
  end

  match "/job-errors/*path" do
    Proxy.forward conn, path, "http://cache/job-errors/"
  end

  get "/files/:id/download" do
    Proxy.forward conn, [], "http://file/files/" <> id <> "/download"
  end

  match "/files/*path" do
    Proxy.forward conn, path, "http://cache/files/"
  end

  get "/sync/books/files/*path" do
    Proxy.forward conn, path, "http://delta-producer-publication-graph-maintainer/books/files/"
  end

  #################################################################
  # DCAT
  #################################################################
  match "/datasets/*path" do
    Proxy.forward conn, path, "http://cache/datasets/"
  end

  match "/distributions/*path" do
    Proxy.forward conn, path, "http://cache/distributions/"
  end

  ###############
  # SPARQL
  ###############
  #match "/sparql", %{ layer: :sparql, accept: %{ sparql: true } } do
  match "/sparql" do
    forward conn, [], "http://database:8890/sparql"
  end

  match "/*_", %{ last_call: true } do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end
end
