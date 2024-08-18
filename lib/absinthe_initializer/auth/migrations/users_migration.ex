defmodule AbsintheInitializer.Auth.Migrations.UsersMigration do
  def generate_migration(project_capitalized) do
    migration_content = """
    defmodule #{project_capitalized}Web.Migrations.CreateUsers do
      use Ecto.Migration

      def change do
        execute "CREATE EXTENSION IF NOT EXISTS citext", ""

        create table(:users) do
          add :email, :citext, null: false
          add :hashed_password, :string, null: false
          add :confirmed_at, :naive_datetime
          add :is_admin, :boolean, default: false
          timestamps()
        end

        create unique_index(:users, [:email])

        create table(:users_tokens) do
          add :user_id, references(:users, on_delete: :delete_all), null: false
          add :token, :binary, null: false
          add :context, :string, null: false
          add :sent_to, :string
          timestamps(updated_at: false)
        end

        create index(:users_tokens, [:user_id])
        create unique_index(:users_tokens, [:context, :token])
      end
    end
    """
    timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.to_string() |> String.slice(0..18) |> String.replace(["-", ":", ".", " "], "")
    File.write!("priv/repo/migrations/#{timestamp}_create_users.exs", migration_content)
  end
end
