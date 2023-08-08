import pytest
from spacy.training import Example
from spacy.lang.en import English
from thinc.api import Config


default_tok2vec_config = """
[model]
@architectures = "spacy-legacy.HashEmbedCNN.v1"
pretrained_vectors = null
width = 96
depth = 4
embed_size = 2000
window_size = 1
maxout_pieces = 3
subword_features = true
"""
DEFAULT_TOK2VEC_MODEL = Config().from_str(default_tok2vec_config)["model"]


TAGS = ("N", "V", "J")

TRAIN_DATA = [
    ("I like green eggs", {"tags": ["N", "V", "J", "N"]}),
    ("Eat blue ham", {"tags": ["V", "J", "N"]}),
]


@pytest.mark.parametrize(
    "tagger_config",
    [
        {
            "@architectures": "spacy-legacy.Tagger.v1",
            "tok2vec": DEFAULT_TOK2VEC_MODEL,
        }
    ],
)
def test_overfitting_IO(tagger_config):
    # Simple test to try and quickly overfit the tagger - ensuring the ML models work correctly
    pipe_config = {"model": tagger_config}
    nlp = English()
    tagger = nlp.add_pipe("tagger", config=pipe_config)
    train_examples = []
    for t in TRAIN_DATA:
        train_examples.append(Example.from_dict(nlp.make_doc(t[0]), t[1]))
    optimizer = nlp.initialize(get_examples=lambda: train_examples)
    assert tagger.model.get_dim("nO") == len(TAGS)

    for i in range(50):
        losses = {}
        nlp.update(train_examples, sgd=optimizer, losses=losses)
    assert losses["tagger"] < 0.00001

    # test the trained model
    test_text = "I like blue eggs"
    doc = nlp(test_text)
    assert doc[0].tag_ == "N"
    assert doc[1].tag_ == "V"
    assert doc[2].tag_ == "J"
    assert doc[3].tag_ == "N"
