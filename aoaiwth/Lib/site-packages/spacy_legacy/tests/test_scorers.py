import spacy
from spacy.training import Example
from spacy_legacy.scorers import score_cats_v1


def test_score_cats_v1():
    nlp = spacy.blank("en")
    ref = nlp("one")
    ref.cats = {"winter": 1.0, "summer": 0.0, "spring": 0.0, "autumn": 0.0}
    pred = nlp("one")
    pred.cats = {"winter": 0.35, "summer": 0.25, "spring": 0.2, "autumn": 0.2}

    # with the previous threshold of 0.5 provided in the default textcat config,
    # this example is counted as incorrect even though winter should be the
    # "positive" prediction
    scores = score_cats_v1(
        [Example(pred, ref)],
        "cats",
        labels=["winter", "summer", "spring", "autumn"],
        multi_label=False,
        threshold=0.5,
    )
    assert scores["cats_micro_f"] == 0.0

    # with no provided threshold, the score is correct
    # (note that cats_score is incorrectly 0.25 because there are no examples
    # for the other labels and the default F-score for nothing with PRFScore is
    # 0.0 rather than undefined)
    scores = score_cats_v1(
        [Example(pred, ref)],
        "cats",
        labels=["winter", "summer", "spring", "autumn"],
        multi_label=False,
        threshold=None,
    )
    assert scores["cats_micro_f"] == 1.0
