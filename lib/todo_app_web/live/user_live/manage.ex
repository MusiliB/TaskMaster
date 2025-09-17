defmodule TodoAppWeb.UserLive.Manage do
  use TodoAppWeb, :live_view
  alias TodoApp.Accounts

  on_mount {TodoAppWeb.UserAuth, :require_superuser}

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Manage Users
        <:subtitle>Grant or revoke admin access for users.</:subtitle>
      </.header>

      <.table id="users" rows={@users}>
        <:col :let={user} label="Email">{user.email}</:col>
        <:col :let={user} label="Role">{user.role}</:col>
        <:action :let={user}>
          <%= if user.role != :superuser do %>
            <%= if user.role == :frontend do %>
              <.link phx-click="grant_admin" phx-value-id={user.id} data-confirm="Grant admin access?">
                Grant Admin
              </.link>
            <% else %>
              <.link phx-click="revoke_admin" phx-value-id={user.id} data-confirm="Revoke admin access?">
                Revoke Admin
              </.link>
            <% end %>
          <% end %>
        </:action>
      </.table>

      <.button navigate={~p"/todos"}>Back to Todos</.button>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Manage Users")
     |> assign(:users, Accounts.list_users())}
  end

  @impl true
  def handle_event("grant_admin", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    {:ok, _} = Accounts.update_user_role(user, :admin)

    {:noreply,
     socket
     |> put_flash(:info, "Admin access granted")
     |> assign(:users, Accounts.list_users())}
  end

  def handle_event("revoke_admin", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    {:ok, _} = Accounts.update_user_role(user, :frontend)

    {:noreply,
     socket
     |> put_flash(:info, "Admin access revoked")
     |> assign(:users, Accounts.list_users())}
  end
end
