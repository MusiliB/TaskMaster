# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TodoApp.Repo.insert!(%TodoApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


# priv/repo/seeds.exs
# priv/repo/seeds.exs
alias TodoApp.Repo
alias TodoApp.Accounts.User

Repo.insert!(%User{
  email: "superuser@example.com",
  hashed_password: Bcrypt.hash_pwd_salt("password123456"),
  confirmed_at: DateTime.utc_now() |> DateTime.truncate(:second),
  role: :superuser
})
