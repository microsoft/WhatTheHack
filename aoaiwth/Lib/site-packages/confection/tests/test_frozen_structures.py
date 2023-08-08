from pytest import raises

from confection import SimpleFrozenDict, SimpleFrozenList


def test_frozen_list():
    frozen = SimpleFrozenList(range(10))

    for k in range(10):
        assert frozen[k] == k

    with raises(NotImplementedError, match="frozen list"):
        frozen.append(5)

    with raises(NotImplementedError, match="frozen list"):
        frozen.reverse()

    with raises(NotImplementedError, match="frozen list"):
        frozen.pop(0)


def test_frozen_dict():
    frozen = SimpleFrozenDict({k: k for k in range(10)})

    for k in range(10):
        assert frozen[k] == k

    with raises(NotImplementedError, match="frozen dictionary"):
        frozen[0] = 1

    with raises(NotImplementedError, match="frozen dictionary"):
        frozen[10] = 1
