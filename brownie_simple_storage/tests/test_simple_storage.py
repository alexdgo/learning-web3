from brownie import SimpleStorage, accounts

# use `brownie test --pdb` to debug
# use `brownie test -s` to show printlines and more details
def test_deploy():
    # Arrange
    account = accounts[0]
    # Act
    simple_storage = SimpleStorage.deploy({"from": account})
    starting_value = simple_storage.retrieve()
    expected = 0
    # Assert
    assert starting_value == expected


def test_update_storage():
    account = accounts[0]
    simple_storage = SimpleStorage.deploy({"from": account})
    expected = 15
    simple_storage.store(expected, {"from": account})
    assert expected == simple_storage.retrieve()
