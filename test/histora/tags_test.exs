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

  describe "tag_records" do
    alias Histora.Tags.Tag_record

    import Histora.TagsFixtures

    @invalid_attrs %{}

    test "list_tag_records/0 returns all tag_records" do
      tag_record = tag_record_fixture()
      assert Tags.list_tag_records() == [tag_record]
    end

    test "get_tag_record!/1 returns the tag_record with given id" do
      tag_record = tag_record_fixture()
      assert Tags.get_tag_record!(tag_record.id) == tag_record
    end

    test "create_tag_record/1 with valid data creates a tag_record" do
      valid_attrs = %{}

      assert {:ok, %Tag_record{} = tag_record} = Tags.create_tag_record(valid_attrs)
    end

    test "create_tag_record/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tags.create_tag_record(@invalid_attrs)
    end

    test "update_tag_record/2 with valid data updates the tag_record" do
      tag_record = tag_record_fixture()
      update_attrs = %{}

      assert {:ok, %Tag_record{} = tag_record} = Tags.update_tag_record(tag_record, update_attrs)
    end

    test "update_tag_record/2 with invalid data returns error changeset" do
      tag_record = tag_record_fixture()
      assert {:error, %Ecto.Changeset{}} = Tags.update_tag_record(tag_record, @invalid_attrs)
      assert tag_record == Tags.get_tag_record!(tag_record.id)
    end

    test "delete_tag_record/1 deletes the tag_record" do
      tag_record = tag_record_fixture()
      assert {:ok, %Tag_record{}} = Tags.delete_tag_record(tag_record)
      assert_raise Ecto.NoResultsError, fn -> Tags.get_tag_record!(tag_record.id) end
    end

    test "change_tag_record/1 returns a tag_record changeset" do
      tag_record = tag_record_fixture()
      assert %Ecto.Changeset{} = Tags.change_tag_record(tag_record)
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
