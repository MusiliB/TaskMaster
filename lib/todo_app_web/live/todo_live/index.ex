defmodule TodoAppWeb.TodoLive.Index do
  use TodoAppWeb, :live_view

  alias TodoApp.Todos
  alias Phoenix.LiveView.JS

  # Ensure the LiveView uses the authentication hook from UserAuth
  on_mount {TodoAppWeb.UserAuth, :require_authenticated}

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Todos
        <:actions>
          <.button variant="primary" navigate={~p"/todos/new"}>
            <.icon name="hero-plus" /> New Todo
          </.button>
        </:actions>
      </.header>

      <.table
        id="todos"
        rows={@streams.todos}
        row_click={fn {_id, todo} -> JS.navigate(~p"/todos/#{todo}") end}
      >
        <:col :let={{_id, todo}} label="Title">{todo.title}</:col>
        <:col :let={{_id, todo}} label="Done">{if todo.done, do: "✅", else: "❌"}</:col>
        <:action :let={{_id, todo}}>
          <div class="sr-only">
            <.link navigate={~p"/todos/#{todo}"}>Show</.link>
          </div>
          <.link navigate={~p"/todos/#{todo}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, todo}}>
          <.link
            phx-click={JS.push("delete", value: %{id: todo.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_scope.user

    {:ok,
     socket
     |> assign(:page_title, "Listing Todos")
     |> assign(:current_scope, socket.assigns.current_scope)
     |> stream(:todos, list_todos(user))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = socket.assigns.current_scope.user
    todo = Todos.get_todo!(user, id)
    {:ok, _} = Todos.delete_todo(todo)

    {:noreply, stream_delete(socket, :todos, todo)}
  end

  defp list_todos(user) do
    Todos.list_todos(user)
  end
end
