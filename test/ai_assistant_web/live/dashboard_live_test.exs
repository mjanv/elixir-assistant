defmodule AiAssistantWeb.DashboardLiveTest do
  use AiAssistantWeb.ConnCase

  import Phoenix.LiveViewTest
  import AiAssistant.DashboardsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_dashboard(_) do
    dashboard = dashboard_fixture()
    %{dashboard: dashboard}
  end

  describe "Index" do
    setup [:create_dashboard]

    test "lists all dashboards", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/dashboards")

      assert html =~ "Listing Dashboards"
    end

    test "saves new dashboard", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/dashboards")

      assert index_live |> element("a", "New Dashboard") |> render_click() =~
               "New Dashboard"

      assert_patch(index_live, ~p"/dashboards/new")

      assert index_live
             |> form("#dashboard-form", dashboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#dashboard-form", dashboard: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/dashboards")

      html = render(index_live)
      assert html =~ "Dashboard created successfully"
    end

    test "updates dashboard in listing", %{conn: conn, dashboard: dashboard} do
      {:ok, index_live, _html} = live(conn, ~p"/dashboards")

      assert index_live |> element("#dashboards-#{dashboard.id} a", "Edit") |> render_click() =~
               "Edit Dashboard"

      assert_patch(index_live, ~p"/dashboards/#{dashboard}/edit")

      assert index_live
             |> form("#dashboard-form", dashboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#dashboard-form", dashboard: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/dashboards")

      html = render(index_live)
      assert html =~ "Dashboard updated successfully"
    end

    test "deletes dashboard in listing", %{conn: conn, dashboard: dashboard} do
      {:ok, index_live, _html} = live(conn, ~p"/dashboards")

      assert index_live |> element("#dashboards-#{dashboard.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#dashboards-#{dashboard.id}")
    end
  end

  describe "Show" do
    setup [:create_dashboard]

    test "displays dashboard", %{conn: conn, dashboard: dashboard} do
      {:ok, _show_live, html} = live(conn, ~p"/dashboards/#{dashboard}")

      assert html =~ "Show Dashboard"
    end

    test "updates dashboard within modal", %{conn: conn, dashboard: dashboard} do
      {:ok, show_live, _html} = live(conn, ~p"/dashboards/#{dashboard}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Dashboard"

      assert_patch(show_live, ~p"/dashboards/#{dashboard}/show/edit")

      assert show_live
             |> form("#dashboard-form", dashboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#dashboard-form", dashboard: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/dashboards/#{dashboard}")

      html = render(show_live)
      assert html =~ "Dashboard updated successfully"
    end
  end
end
