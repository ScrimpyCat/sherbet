defmodule Sherbet.API.Contact.Email do
    @moduledoc """
      Handles the authorization of session tokens.
    """

    @service Sherbet.Service.Contact
    @credential_type :email

    @doc """
      Associate an email with the given identity.

      Returns `:ok` on successful addition. Otherwise returns a error.
    """
    @spec add(Auth.uuid, String.t) :: :ok | { :error, String.t }
    def add(identity, email) do
        GenServer.call(@service, { :add, { @credential_type, email }, identity })
    end

    @doc """
      Associate an email with the given identity, and specify its priority.

      Returns `:ok` on successful addition. Otherwise returns a error.
    """
    @spec add(Auth.uuid, String.t, :secondary | :primary) :: :ok | { :error, String.t }
    def add(identity, email, priority) do
        GenServer.call(@service, { :add, { @credential_type, email, priority }, identity })
    end

    @doc """
      Remove an email that was associated with the given identity.

      Returns `:ok` on successful removal. Otherwise returns an error.
    """
    @spec remove(Auth.uuid, String.t) :: :ok | { :error, String.t }
    def remove(identity, email) do
        GenServer.call(@service, { :remove, { @credential_type, email }, identity })
    end

    @doc """
      Make an email associated with the identity become the primary email contact for
      that identity.

      Will turn any other primary email contact for that identity into a secondary
      option.

      Returns `:ok` on successful change. Otherwise returns an error.
    """
    @spec make_primary(Auth.uuid, String.t) :: :ok | { :error, String.t }
    def make_primary(identity, email) do
        GenServer.call(@service, { :make_primary, { @credential_type, email }, identity })
    end

    @doc """
      Request an email associated with another identity, be removed.

      Removal requests only apply to unverified emails.

      Returns `:ok` if request was successful. Otherwise returns an error.
    """
    @spec request_removal(String.t) :: :ok | { :error, String.t }
    def request_removal(email) do
        GenServer.call(@service, { :request_removal, { @credential_type, email } })
    end

    @doc """
      Finalise the request that an email be removed.

      Returns `:ok` if removal was successful. Otherwise returns an error.
    """
    @spec finalise_removal(String.t, String.t) :: :ok | { :error, String.t }
    def finalise_removal(email, key) do
        GenServer.call(@service, { :finalise_removal, { @credential_type, email, key } })
    end

    @doc """
      Check if an email belonging to the given identity has been verified.

      Returns `{ :ok, verified }` if the operation was successful, where `verified`
      is whether the email was verified (`true`) or not (`false`). Otherwise returns
      an error.
    """
    @spec verified?(Auth.uuid, String.t) :: { :ok, boolean } | { :error, String.t }
    def verified?(identity, email) do
        GenServer.call(@service, { :verified?, { @credential_type, email }, identity })
    end

    @doc """
      Request an email be verified.

      Verification requests only apply to unverified emails.

      Returns `:ok` if request was successful. Otherwise returns an error.
    """
    @spec request_verification(Auth.uuid, String.t) :: :ok | { :error, String.t }
    def request_verification(identity, email) do
        GenServer.call(@service, { :request_verification, { @credential_type, email }, identity })
    end

    @doc """
      Finalise the verification request for an email.

      Returns `:ok` if verification was successful. Otherwise returns an error.
    """
    @spec finalise_verification(Auth.uuid, String.t, String.t) :: :ok | { :error, String.t }
    def finalise_verification(identity, email, key) do
        GenServer.call(@service, { :finalise_verification, { @credential_type, email, key }, identity })
    end

    @doc """
      Get a list of emails associated with the given identity.

      Returns `{ :ok, contacts }` if the operation was successful, where `contacts` is
      the list of emails associated with the given identity and their current verification
      status and priority. Otherwise returns the reason of failure.
    """
    @spec contacts(Auth.uuid) :: { :ok, [{ :unverified | :verified, :secondary | :primary, String.t }] } | { :error, String.t }
    def contacts(identity) do
        GenServer.call(@service, { :contacts, { @credential_type }, identity })
    end

    @doc """
      Get the primary email associated with the given identity.

      Returns `{ :ok, contact }` if the operation was successful, where `contact` is
      the primary email associated with the given identity and its current verification
      status. Otherwise returns the reason of failure.
    """
    @spec primary_contact(Auth.uuid) :: { :ok, { :unverified | :verified, String.t } } | { :error, String.t }
    def primary_contact(identity) do
        GenServer.call(@service, { :primary_contact, { @credential_type }, identity })
    end
end
