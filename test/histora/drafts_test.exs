defmodule Histora.DraftsTest do
  use Histora.DataCase

  alias Histora.Drafts

  describe "drafts" do
    alias Histora.Drafts.Draft

    import Histora.DraftsFixtures

    @invalid_attrs %{}

    test "list_drafts/0 returns all drafts" do
      draft = draft_fixture()
      assert Drafts.list_drafts() == [draft]
    end

    test "get_draft!/1 returns the draft with given id" do
      draft = draft_fixture()
      assert Drafts.get_draft!(draft.id) == draft
    end

    test "create_draft/1 with valid data creates a draft" do
      valid_attrs = %{}

      assert {:ok, %Draft{} = draft} = Drafts.create_draft(valid_attrs)
    end

    test "create_draft/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Drafts.create_draft(@invalid_attrs)
    end

    test "update_draft/2 with valid data updates the draft" do
      draft = draft_fixture()
      update_attrs = %{}

      assert {:ok, %Draft{} = draft} = Drafts.update_draft(draft, update_attrs)
    end

    test "update_draft/2 with invalid data returns error changeset" do
      draft = draft_fixture()
      assert {:error, %Ecto.Changeset{}} = Drafts.update_draft(draft, @invalid_attrs)
      assert draft == Drafts.get_draft!(draft.id)
    end

    test "delete_draft/1 deletes the draft" do
      draft = draft_fixture()
      assert {:ok, %Draft{}} = Drafts.delete_draft(draft)
      assert_raise Ecto.NoResultsError, fn -> Drafts.get_draft!(draft.id) end
    end

    test "change_draft/1 returns a draft changeset" do
      draft = draft_fixture()
      assert %Ecto.Changeset{} = Drafts.change_draft(draft)
    end
  end

  describe "draft_users" do
    alias Histora.Drafts.Draft_user

    import Histora.DraftsFixtures

    @invalid_attrs %{}

    test "list_draft_users/0 returns all draft_users" do
      draft_user = draft_user_fixture()
      assert Drafts.list_draft_users() == [draft_user]
    end

    test "get_draft_user!/1 returns the draft_user with given id" do
      draft_user = draft_user_fixture()
      assert Drafts.get_draft_user!(draft_user.id) == draft_user
    end

    test "create_draft_user/1 with valid data creates a draft_user" do
      valid_attrs = %{}

      assert {:ok, %Draft_user{} = draft_user} = Drafts.create_draft_user(valid_attrs)
    end

    test "create_draft_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Drafts.create_draft_user(@invalid_attrs)
    end

    test "update_draft_user/2 with valid data updates the draft_user" do
      draft_user = draft_user_fixture()
      update_attrs = %{}

      assert {:ok, %Draft_user{} = draft_user} = Drafts.update_draft_user(draft_user, update_attrs)
    end

    test "update_draft_user/2 with invalid data returns error changeset" do
      draft_user = draft_user_fixture()
      assert {:error, %Ecto.Changeset{}} = Drafts.update_draft_user(draft_user, @invalid_attrs)
      assert draft_user == Drafts.get_draft_user!(draft_user.id)
    end

    test "delete_draft_user/1 deletes the draft_user" do
      draft_user = draft_user_fixture()
      assert {:ok, %Draft_user{}} = Drafts.delete_draft_user(draft_user)
      assert_raise Ecto.NoResultsError, fn -> Drafts.get_draft_user!(draft_user.id) end
    end

    test "change_draft_user/1 returns a draft_user changeset" do
      draft_user = draft_user_fixture()
      assert %Ecto.Changeset{} = Drafts.change_draft_user(draft_user)
    end
  end

  describe "draft_teams" do
    alias Histora.Drafts.Draft_team

    import Histora.DraftsFixtures

    @invalid_attrs %{}

    test "list_draft_teams/0 returns all draft_teams" do
      draft_team = draft_team_fixture()
      assert Drafts.list_draft_teams() == [draft_team]
    end

    test "get_draft_team!/1 returns the draft_team with given id" do
      draft_team = draft_team_fixture()
      assert Drafts.get_draft_team!(draft_team.id) == draft_team
    end

    test "create_draft_team/1 with valid data creates a draft_team" do
      valid_attrs = %{}

      assert {:ok, %Draft_team{} = draft_team} = Drafts.create_draft_team(valid_attrs)
    end

    test "create_draft_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Drafts.create_draft_team(@invalid_attrs)
    end

    test "update_draft_team/2 with valid data updates the draft_team" do
      draft_team = draft_team_fixture()
      update_attrs = %{}

      assert {:ok, %Draft_team{} = draft_team} = Drafts.update_draft_team(draft_team, update_attrs)
    end

    test "update_draft_team/2 with invalid data returns error changeset" do
      draft_team = draft_team_fixture()
      assert {:error, %Ecto.Changeset{}} = Drafts.update_draft_team(draft_team, @invalid_attrs)
      assert draft_team == Drafts.get_draft_team!(draft_team.id)
    end

    test "delete_draft_team/1 deletes the draft_team" do
      draft_team = draft_team_fixture()
      assert {:ok, %Draft_team{}} = Drafts.delete_draft_team(draft_team)
      assert_raise Ecto.NoResultsError, fn -> Drafts.get_draft_team!(draft_team.id) end
    end

    test "change_draft_team/1 returns a draft_team changeset" do
      draft_team = draft_team_fixture()
      assert %Ecto.Changeset{} = Drafts.change_draft_team(draft_team)
    end
  end

  describe "draft_options" do
    alias Histora.Drafts.Draft_option

    import Histora.DraftsFixtures

    @invalid_attrs %{}

    test "list_draft_options/0 returns all draft_options" do
      draft_option = draft_option_fixture()
      assert Drafts.list_draft_options() == [draft_option]
    end

    test "get_draft_option!/1 returns the draft_option with given id" do
      draft_option = draft_option_fixture()
      assert Drafts.get_draft_option!(draft_option.id) == draft_option
    end

    test "create_draft_option/1 with valid data creates a draft_option" do
      valid_attrs = %{}

      assert {:ok, %Draft_option{} = draft_option} = Drafts.create_draft_option(valid_attrs)
    end

    test "create_draft_option/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Drafts.create_draft_option(@invalid_attrs)
    end

    test "update_draft_option/2 with valid data updates the draft_option" do
      draft_option = draft_option_fixture()
      update_attrs = %{}

      assert {:ok, %Draft_option{} = draft_option} = Drafts.update_draft_option(draft_option, update_attrs)
    end

    test "update_draft_option/2 with invalid data returns error changeset" do
      draft_option = draft_option_fixture()
      assert {:error, %Ecto.Changeset{}} = Drafts.update_draft_option(draft_option, @invalid_attrs)
      assert draft_option == Drafts.get_draft_option!(draft_option.id)
    end

    test "delete_draft_option/1 deletes the draft_option" do
      draft_option = draft_option_fixture()
      assert {:ok, %Draft_option{}} = Drafts.delete_draft_option(draft_option)
      assert_raise Ecto.NoResultsError, fn -> Drafts.get_draft_option!(draft_option.id) end
    end

    test "change_draft_option/1 returns a draft_option changeset" do
      draft_option = draft_option_fixture()
      assert %Ecto.Changeset{} = Drafts.change_draft_option(draft_option)
    end
  end

  describe "draft_votes" do
    alias Histora.Drafts.Draft_vote

    import Histora.DraftsFixtures

    @invalid_attrs %{}

    test "list_draft_votes/0 returns all draft_votes" do
      draft_vote = draft_vote_fixture()
      assert Drafts.list_draft_votes() == [draft_vote]
    end

    test "get_draft_vote!/1 returns the draft_vote with given id" do
      draft_vote = draft_vote_fixture()
      assert Drafts.get_draft_vote!(draft_vote.id) == draft_vote
    end

    test "create_draft_vote/1 with valid data creates a draft_vote" do
      valid_attrs = %{}

      assert {:ok, %Draft_vote{} = draft_vote} = Drafts.create_draft_vote(valid_attrs)
    end

    test "create_draft_vote/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Drafts.create_draft_vote(@invalid_attrs)
    end

    test "update_draft_vote/2 with valid data updates the draft_vote" do
      draft_vote = draft_vote_fixture()
      update_attrs = %{}

      assert {:ok, %Draft_vote{} = draft_vote} = Drafts.update_draft_vote(draft_vote, update_attrs)
    end

    test "update_draft_vote/2 with invalid data returns error changeset" do
      draft_vote = draft_vote_fixture()
      assert {:error, %Ecto.Changeset{}} = Drafts.update_draft_vote(draft_vote, @invalid_attrs)
      assert draft_vote == Drafts.get_draft_vote!(draft_vote.id)
    end

    test "delete_draft_vote/1 deletes the draft_vote" do
      draft_vote = draft_vote_fixture()
      assert {:ok, %Draft_vote{}} = Drafts.delete_draft_vote(draft_vote)
      assert_raise Ecto.NoResultsError, fn -> Drafts.get_draft_vote!(draft_vote.id) end
    end

    test "change_draft_vote/1 returns a draft_vote changeset" do
      draft_vote = draft_vote_fixture()
      assert %Ecto.Changeset{} = Drafts.change_draft_vote(draft_vote)
    end
  end
end
