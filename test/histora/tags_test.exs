defmodule Histora.TagsTest do
  use Histora.DataCase

  alias Histora.Tags

  describe "tags" do
    alias Histora.Tags.Tag

    import Histora.TagsFixtures

    @invalid_attrs %{}

    test "list_tags/0 returns all tags" do
      tag = tag_fixture()
      assert Tags.list_tags() == [tag]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = tag_fixture()
      assert Tags.get_tag!(tag.id) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      valid_attrs = %{}

      assert {:ok, %Tag{} = tag} = Tags.create_tag(valid_attrs)
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tags.create_tag(@invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()
      update_attrs = %{}

      assert {:ok, %Tag{} = tag} = Tags.update_tag(tag, update_attrs)
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Tags.update_tag(tag, @invalid_attrs)
      assert tag == Tags.get_tag!(tag.id)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Tags.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Tags.get_tag!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Tags.change_tag(tag)
    end
  end

  describe "tag_decisions" do
    alias Histora.Tags.Tag_decision

    import Histora.TagsFixtures

    @invalid_attrs %{}

    test "list_tag_decisions/0 returns all tag_decisions" do
      tag_decision = tag_decision_fixture()
      assert Tags.list_tag_decisions() == [tag_decision]
    end

    test "get_tag_decision!/1 returns the tag_decision with given id" do
      tag_decision = tag_decision_fixture()
      assert Tags.get_tag_decision!(tag_decision.id) == tag_decision
    end

    test "create_tag_decision/1 with valid data creates a tag_decision" do
      valid_attrs = %{}

      assert {:ok, %Tag_decision{} = tag_decision} = Tags.create_tag_decision(valid_attrs)
    end

    test "create_tag_decision/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tags.create_tag_decision(@invalid_attrs)
    end

    test "update_tag_decision/2 with valid data updates the tag_decision" do
      tag_decision = tag_decision_fixture()
      update_attrs = %{}

      assert {:ok, %Tag_decision{} = tag_decision} = Tags.update_tag_decision(tag_decision, update_attrs)
    end

    test "update_tag_decision/2 with invalid data returns error changeset" do
      tag_decision = tag_decision_fixture()
      assert {:error, %Ecto.Changeset{}} = Tags.update_tag_decision(tag_decision, @invalid_attrs)
      assert tag_decision == Tags.get_tag_decision!(tag_decision.id)
    end

    test "delete_tag_decision/1 deletes the tag_decision" do
      tag_decision = tag_decision_fixture()
      assert {:ok, %Tag_decision{}} = Tags.delete_tag_decision(tag_decision)
      assert_raise Ecto.NoResultsError, fn -> Tags.get_tag_decision!(tag_decision.id) end
    end

    test "change_tag_decision/1 returns a tag_decision changeset" do
      tag_decision = tag_decision_fixture()
      assert %Ecto.Changeset{} = Tags.change_tag_decision(tag_decision)
    end
  end

  describe "tag_favorites" do
    alias Histora.Tags.Tag_favorite

    import Histora.TagsFixtures

    @invalid_attrs %{}

    test "list_tag_favorites/0 returns all tag_favorites" do
      tag_favorite = tag_favorite_fixture()
      assert Tags.list_tag_favorites() == [tag_favorite]
    end

    test "get_tag_favorite!/1 returns the tag_favorite with given id" do
      tag_favorite = tag_favorite_fixture()
      assert Tags.get_tag_favorite!(tag_favorite.id) == tag_favorite
    end

    test "create_tag_favorite/1 with valid data creates a tag_favorite" do
      valid_attrs = %{}

      assert {:ok, %Tag_favorite{} = tag_favorite} = Tags.create_tag_favorite(valid_attrs)
    end

    test "create_tag_favorite/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tags.create_tag_favorite(@invalid_attrs)
    end

    test "update_tag_favorite/2 with valid data updates the tag_favorite" do
      tag_favorite = tag_favorite_fixture()
      update_attrs = %{}

      assert {:ok, %Tag_favorite{} = tag_favorite} = Tags.update_tag_favorite(tag_favorite, update_attrs)
    end

    test "update_tag_favorite/2 with invalid data returns error changeset" do
      tag_favorite = tag_favorite_fixture()
      assert {:error, %Ecto.Changeset{}} = Tags.update_tag_favorite(tag_favorite, @invalid_attrs)
      assert tag_favorite == Tags.get_tag_favorite!(tag_favorite.id)
    end

    test "delete_tag_favorite/1 deletes the tag_favorite" do
      tag_favorite = tag_favorite_fixture()
      assert {:ok, %Tag_favorite{}} = Tags.delete_tag_favorite(tag_favorite)
      assert_raise Ecto.NoResultsError, fn -> Tags.get_tag_favorite!(tag_favorite.id) end
    end

    test "change_tag_favorite/1 returns a tag_favorite changeset" do
      tag_favorite = tag_favorite_fixture()
      assert %Ecto.Changeset{} = Tags.change_tag_favorite(tag_favorite)
    end
  end
end
