defmodule Histora.RecordsTest do
  use Histora.DataCase

  alias Histora.Records

  describe "records" do
    alias Histora.Records.Record

    import Histora.RecordsFixtures

    @invalid_attrs %{}

    test "list_records/0 returns all records" do
      record = record_fixture()
      assert Records.list_records() == [record]
    end

    test "get_record!/1 returns the record with given id" do
      record = record_fixture()
      assert Records.get_record!(record.id) == record
    end

    test "create_record/1 with valid data creates a record" do
      valid_attrs = %{}

      assert {:ok, %Record{} = record} = Records.create_record(valid_attrs)
    end

    test "create_record/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Records.create_record(@invalid_attrs)
    end

    test "update_record/2 with valid data updates the record" do
      record = record_fixture()
      update_attrs = %{}

      assert {:ok, %Record{} = record} = Records.update_record(record, update_attrs)
    end

    test "update_record/2 with invalid data returns error changeset" do
      record = record_fixture()
      assert {:error, %Ecto.Changeset{}} = Records.update_record(record, @invalid_attrs)
      assert record == Records.get_record!(record.id)
    end

    test "delete_record/1 deletes the record" do
      record = record_fixture()
      assert {:ok, %Record{}} = Records.delete_record(record)
      assert_raise Ecto.NoResultsError, fn -> Records.get_record!(record.id) end
    end

    test "change_record/1 returns a record changeset" do
      record = record_fixture()
      assert %Ecto.Changeset{} = Records.change_record(record)
    end
  end

  describe "record_users" do
    alias Histora.Records.Record_user

    import Histora.RecordsFixtures

    @invalid_attrs %{}

    test "list_record_users/0 returns all record_users" do
      record_user = record_user_fixture()
      assert Records.list_record_users() == [record_user]
    end

    test "get_record_user!/1 returns the record_user with given id" do
      record_user = record_user_fixture()
      assert Records.get_record_user!(record_user.id) == record_user
    end

    test "create_record_user/1 with valid data creates a record_user" do
      valid_attrs = %{}

      assert {:ok, %Record_user{} = record_user} = Records.create_record_user(valid_attrs)
    end

    test "create_record_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Records.create_record_user(@invalid_attrs)
    end

    test "update_record_user/2 with valid data updates the record_user" do
      record_user = record_user_fixture()
      update_attrs = %{}

      assert {:ok, %Record_user{} = record_user} = Records.update_record_user(record_user, update_attrs)
    end

    test "update_record_user/2 with invalid data returns error changeset" do
      record_user = record_user_fixture()
      assert {:error, %Ecto.Changeset{}} = Records.update_record_user(record_user, @invalid_attrs)
      assert record_user == Records.get_record_user!(record_user.id)
    end

    test "delete_record_user/1 deletes the record_user" do
      record_user = record_user_fixture()
      assert {:ok, %Record_user{}} = Records.delete_record_user(record_user)
      assert_raise Ecto.NoResultsError, fn -> Records.get_record_user!(record_user.id) end
    end

    test "change_record_user/1 returns a record_user changeset" do
      record_user = record_user_fixture()
      assert %Ecto.Changeset{} = Records.change_record_user(record_user)
    end
  end
end
