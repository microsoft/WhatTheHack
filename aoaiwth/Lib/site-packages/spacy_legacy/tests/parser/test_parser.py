import pytest
from spacy.lang.en import English
from spacy.training import Example
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

TRAIN_DATA = [
    (
        "They trade mortgage-backed securities.",
        {
            "heads": [1, 1, 4, 4, 5, 1, 1],
            "deps": ["nsubj", "ROOT", "compound", "punct", "nmod", "dobj", "punct"],
        },
    ),
    (
        "I like London and Berlin.",
        {
            "heads": [1, 1, 1, 2, 2, 1],
            "deps": ["nsubj", "ROOT", "dobj", "cc", "conj", "punct"],
        },
    ),
]


@pytest.mark.parametrize(
    "parser_config",
    [
        {
            "@architectures": "spacy-legacy.TransitionBasedParser.v1",
            "state_type": "parser",
            "extra_state_tokens": False,
            "hidden_width": 66,
            "maxout_pieces": 2,
            "use_upper": True,
            "tok2vec": DEFAULT_TOK2VEC_MODEL,
        }
    ],
)
def test_parser(parser_config):
    pipe_config = {"model": parser_config}
    nlp = English()
    parser = nlp.add_pipe("parser", config=pipe_config)
    train_examples = []
    for text, annotations in TRAIN_DATA:
        train_examples.append(Example.from_dict(nlp.make_doc(text), annotations))
        for dep in annotations.get("deps", []):
            if dep is not None:
                parser.add_label(dep)
    optimizer = nlp.initialize(get_examples=lambda: train_examples)
    for i in range(150):
        losses = {}
        nlp.update(train_examples, sgd=optimizer, losses=losses)
    assert losses["parser"] < 0.0001
