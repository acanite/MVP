defmodule AppWeb.TagController do
  use AppWeb, :controller
  alias App.Tag
  plug :permission_tag when action in [:edit, :update, :delete]

  def index(conn, _params) do
    person_id = conn.assigns[:person][:id] || 0
    tags = Tag.list_person_tags(person_id)

    render(conn, "index.html", tags: tags)
  end

  def edit(conn, %{"id" => id}) do
    tag = Tag.get_tag!(id)
    changeset = Tag.changeset(tag)
    render(conn, "edit.html", tag: tag, changeset: changeset)
  end

  def update(conn, %{"id" => id, "tag" => tag_params}) do
    tag = Tag.get_tag!(id)

    case Tag.update_tag(tag, tag_params) do
      {:ok, _tag} ->
        conn
        |> put_flash(:info, "Tag updated successfully.")
        |> redirect(to: Routes.tag_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", tag: tag, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tag = Tag.get_tag!(id)

    {:ok, _tag} = Tag.delete_tag(tag)

    conn
    |> put_flash(:info, "Tick deleted successfully.")
    |> redirect(to: Routes.tag_path(conn, :index))
  end

  defp permission_tag(conn, _opts) do
    tag = Tag.get_tag!(conn.params["id"])

    person_id = conn.assigns[:person][:id] || 0

    if tag.person_id == person_id do
      conn
    else
      conn
      |> put_flash(:info, "You can't access that page")
      |> redirect(to: "/tags")
      |> halt()
    end
  end
end