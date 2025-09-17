defmodule TodoApp.Todos do
  @moduledoc """
  The Todos context.
  """

  import Ecto.Query, warn: false
  alias TodoApp.Repo

  alias TodoApp.Todos.Todo
  alias TodoApp.Accounts.User

  @doc """
  Returns the list of todos.
  """
  def list_todos(user) do
    case user.role do
      role when role in [:admin, :superuser] ->
        Repo.all(Todo)

      :frontend ->
        Repo.all(from t in Todo, where: t.user_id == ^user.id)
    end
  end

  @doc """
  Gets a single todo.
  """
  def get_todo!(user, id) do
    case user.role do
      role when role in [:admin, :superuser] ->
        Repo.get!(Todo, id)

      :frontend ->
        Repo.get_by!(Todo, id: id, user_id: user.id)
    end
  end

  @doc """
  Creates a todo.
  """
  def create_todo(user, attrs \\ %{}) do
    %Todo{}
    |> Todo.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a todo.
  """
  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> Todo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a todo.
  """
  def delete_todo(%Todo{} = todo) do
    Repo.delete(todo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo changes.
  """
  def change_todo(%Todo{} = todo, attrs \\ %{}) do
    Todo.changeset(todo, attrs)
  end

  @doc """
  Updates a user’s role.
  """
  def update_user_role(user, role) when role in [:frontend, :admin, :superuser] do
    user
    |> User.changeset(%{role: role})
    |> Repo.update()
  end

  def list_users do
    Repo.all(User)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end
end
