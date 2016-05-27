defmodule Constable.Plugs.ApiAuthTest do
  use Constable.ConnCase

  test "active user is assigned to current_user assigns on conn" do
    user = insert(:user, active: true)
    conn = conn()
      |> bypass_through
      |> put_req_header("authorization", user.token)
      |> run_plug

    assert conn.assigns[:current_user]
  end

  test "inactive user is not assigned to current_user assigns on conn" do
    user = insert(:user, active: false)
    conn = conn()
      |> bypass_through
      |> put_req_header("authorization", user.token)
      |> run_plug

    refute conn.assigns[:current_user]
  end

  defp run_plug(conn) do
    conn |> Constable.Plugs.ApiAuth.call(%{})
  end
end