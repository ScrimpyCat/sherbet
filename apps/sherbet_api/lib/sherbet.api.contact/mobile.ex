defmodule Sherbet.API.Contact.Mobile do
    @moduledoc """
      Handles the management of mobile contacts.
    """

    alias Gobstopper.API.Auth

    @service Sherbet.Service.Contact
    @credential_type :mobile

    @doc """
      Associate an mobile with the given identity.

      Returns `:ok` on successful addition. Otherwise returns a error.
    """
    @spec add(Auth.uuid, String.t) :: :ok | { :error, String.t }
    def add(identity, mobile) do
        GenServer.call(@service, { :add, { @credential_type, mobile }, identity })
    end

    @doc """
      Associate an mobile with the given identity, and specify its priority.

      Returns `:ok` on successful addition. Otherwise returns a error.
    """
    @spec add(Auth.uuid, String.t, :secondary | :primary) :: :ok | { :error, String.t }
    def add(identity, mobile, priority) do
        GenServer.call(@service, { :add, { @credential_type, mobile, priority }, identity })
    end

    @doc """
      Remove an mobile that was associated with the given identity.

      Returns `:ok` on successful removal. Otherwise returns an error.
    """
    @spec remove(Auth.uuid, String.t) :: :ok | { :error, String.t }
    def remove(identity, mobile) do
        GenServer.call(@service, { :remove, { @credential_type, mobile }, identity })
    end

    @doc """
      Make an mobile associated with the identity become the primary mobile contact for
      that identity.

      Will turn any other primary mobile contact for that identity into a secondary
      option.

      Returns `:ok` on successful change. Otherwise returns an error.
    """
    @spec make_primary(Auth.uuid, String.t) :: :ok | { :error, String.t }
    def make_primary(identity, mobile) do
        GenServer.call(@service, { :make_primary, { @credential_type, mobile }, identity })
    end

    @doc """
      Request an mobile associated with another identity, be removed.

      Removal requests only apply to unverified mobiles.

      Returns `:ok` if request was successful. Otherwise returns an error.
    """
    @spec request_removal(String.t) :: :ok | { :error, String.t }
    def request_removal(mobile) do
        GenServer.call(@service, { :request_removal, { @credential_type, mobile } })
    end

    @doc """
      Finalise the request that an mobile be removed.

      Returns `:ok` if removal was successful. Otherwise returns an error.
    """
    @spec finalise_removal(String.t, String.t) :: :ok | { :error, String.t }
    def finalise_removal(mobile, key) do
        GenServer.call(@service, { :finalise_removal, { @credential_type, mobile, key } })
    end

    @doc """
      Check if an mobile belonging to the given identity has been verified.

      Returns `{ :ok, verified }` if the operation was successful, where `verified`
      is whether the mobile was verified (`true`) or not (`false`). Otherwise returns
      an error.
    """
    @spec verified?(Auth.uuid, String.t) :: { :ok, boolean } | { :error, String.t }
    def verified?(identity, mobile) do
        GenServer.call(@service, { :verified?, { @credential_type, mobile }, identity })
    end

    @doc """
      Request an mobile be verified.

      Verification requests only apply to unverified mobiles.

      Returns `:ok` if request was successful. Otherwise returns an error.
    """
    @spec request_verification(Auth.uuid, String.t) :: :ok | { :error, String.t }
    def request_verification(identity, mobile) do
        GenServer.call(@service, { :request_verification, { @credential_type, mobile }, identity })
    end

    @doc """
      Finalise the verification request for an mobile.

      Returns `:ok` if verification was successful. Otherwise returns an error.
    """
    @spec finalise_verification(Auth.uuid, String.t, String.t) :: :ok | { :error, String.t }
    def finalise_verification(identity, mobile, key) do
        GenServer.call(@service, { :finalise_verification, { @credential_type, mobile, key }, identity })
    end

    @doc """
      Get a list of mobiles associated with the given identity.

      Returns `{ :ok, contacts }` if the operation was successful, where `contacts` is
      the list of mobiles associated with the given identity and their current verification
      status and priority. Otherwise returns the reason of failure.
    """
    @spec contacts(Auth.uuid) :: { :ok, [{ :unverified | :verified, :secondary | :primary, String.t }] } | { :error, String.t }
    def contacts(identity) do
        GenServer.call(@service, { :contacts, { @credential_type }, identity })
    end

    @doc """
      Get the primary mobile associated with the given identity.

      Returns `{ :ok, contact }` if the operation was successful, where `contact` is
      the primary mobile associated with the given identity and its current verification
      status. Otherwise returns the reason of failure.
    """
    @spec primary_contact(Auth.uuid) :: { :ok, { :unverified | :verified, String.t } } | { :error, String.t }
    def primary_contact(identity) do
        GenServer.call(@service, { :primary_contact, { @credential_type }, identity })
    end
end