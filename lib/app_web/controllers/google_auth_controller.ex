defmodule AppWeb.GoogleAuthController do
  use AppWeb, :controller
  # use AppWeb, :router
  alias AppWeb.Router.Helpers
  alias App.Ctx.Session
  # alias App.Repo

  @elixir_auth_google Application.get_env(:app, :elixir_auth_google) || ElixirAuthGoogle

  def index(conn, %{"code" => code}) do
    {:ok, token} = @elixir_auth_google.get_token(code, conn)
    {:ok, profile} = @elixir_auth_google.get_user_profile(token["access_token"])

    person = App.Ctx.Person.transform_profile_data_to_person(profile)

    # get the person by email
    case App.Ctx.get_person_by_email(profile["email"]) do
      nil ->
        # Create the person
        {:ok, google_person} = App.Ctx.create_google_person(person)

        # Create session
        session_attrs = %{
          "auth_token" => token["access_token"],
          "refresh_token" => token["refresh_token"]
        }

        App.Ctx.create_session(google_person, session_attrs)

        # Create Phoenix session
        AppWeb.Auth.login(conn, google_person)
        |> render("index.html", person: person)
      person ->
        # create new session and
        session_attrs = %{
          "auth_token" => token["access_token"],
          "refresh_token" => "dummy_refresh_token", # we don't need refresh for now.
        }

        App.Ctx.create_session(person, session_attrs)

        # Create Phoenix session
        AppWeb.Auth.login(conn, person)
        |> render("index.html", person: person)
    end
  end
end
